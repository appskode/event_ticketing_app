import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/services/connectivity_service.dart';
import 'package:event_ticket_app/services/event_service.dart';
import 'package:event_ticket_app/services/offline_cache_service.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((
  ref,
) {
  return EventsNotifier(
    ref.watch(eventServiceProvider),
    ref.watch(offlineCacheServiceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class EventFilters {
  final String? category;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const EventFilters({this.category, this.dateFrom, this.dateTo});

  bool get isActive =>
      (category != null && category!.isNotEmpty) ||
      dateFrom != null ||
      dateTo != null;

  String? get dateFromParam =>
      dateFrom != null ? DateFormat('yyyy-MM-dd').format(dateFrom!) : null;

  String? get dateToParam =>
      dateTo != null ? DateFormat('yyyy-MM-dd').format(dateTo!) : null;

  String get cacheKey => OfflineCacheService.eventsCacheKey(
        category: category,
        dateFrom: dateFromParam,
        dateTo: dateToParam,
      );

  EventFilters copyWith({
    String? category,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearCategory = false,
    bool clearDates = false,
  }) {
    return EventFilters(
      category: clearCategory ? null : (category ?? this.category),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
    );
  }
}

class EventsState {
  final List<Event> events;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;
  final EventFilters filters;
  final bool isShowingCachedData;

  EventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.filters = const EventFilters(),
    this.isShowingCachedData = false,
  });

  EventsState copyWith({
    List<Event>? events,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? hasMore,
    int? currentPage,
    EventFilters? filters,
    bool? isShowingCachedData,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      filters: filters ?? this.filters,
      isShowingCachedData: isShowingCachedData ?? this.isShowingCachedData,
    );
  }
}

class EventsNotifier extends StateNotifier<EventsState> {
  final EventService _eventService;
  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;
  static final _dateFormat = DateFormat('MMM d');

  EventsNotifier(this._eventService, this._cache, this._connectivity)
      : super(EventsState()) {
    loadEvents();
  }

  Future<void> setCategory(String? category) async {
    final filters = state.filters.copyWith(
      category: category,
      clearCategory: category == null,
    );
    await _applyFilters(filters);
  }

  Future<void> setDateRange({DateTime? from, DateTime? to}) async {
    final filters = EventFilters(
      category: state.filters.category,
      dateFrom: from != null ? _dateOnly(from) : null,
      dateTo: to != null ? _dateOnly(to) : null,
    );
    await _applyFilters(filters);
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> clearFilters() => _applyFilters(const EventFilters());

  Future<void> _applyFilters(EventFilters filters) async {
    state = state.copyWith(
      filters: filters,
      events: [],
      currentPage: 1,
      hasMore: true,
      clearError: true,
      isShowingCachedData: false,
    );
    await loadEvents(refresh: true);
  }

  Future<void> loadEvents({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        events: [],
        currentPage: 1,
        hasMore: true,
        isLoading: false,
        clearError: true,
        isShowingCachedData: false,
      );
    }

    if (!refresh && (state.isLoading || !state.hasMore)) return;

    final filters = state.filters;
    final online = await _connectivity.isOnline;

    if (!online) {
      await _loadFromCache(filters);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _eventService.getEvents(
        page: state.currentPage,
        category: filters.category,
        dateFrom: filters.dateFromParam,
        dateTo: filters.dateToParam,
      );
      final List<dynamic> eventsData = response['data']['data'];
      final newEvents = eventsData.map((e) => Event.fromJson(e)).toList();
      final hasMore = response['data']['next_page_url'] != null;
      final allEvents =
          refresh ? newEvents : [...state.events, ...newEvents];

      await _cache.saveEvents(
        cacheKey: filters.cacheKey,
        events: allEvents,
        saveAsMaster: !filters.isActive,
      );
      for (final event in newEvents) {
        await _cache.saveEventDetail(event);
      }

      state = state.copyWith(
        events: allEvents,
        isLoading: false,
        hasMore: hasMore,
        currentPage: state.currentPage + 1,
        isShowingCachedData: false,
      );
    } catch (e) {
      if (isNetworkError(e)) {
        await _loadFromCache(filters, preferCacheOverError: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: userFacingError(e),
        );
      }
    }
  }

  Future<void> _loadFromCache(
    EventFilters filters, {
    bool preferCacheOverError = false,
  }) async {
    final cached = await _cache.getEvents(
      cacheKey: filters.cacheKey,
      category: filters.category,
      dateFrom: filters.dateFromParam,
      dateTo: filters.dateToParam,
    );

    if (cached != null && cached.isNotEmpty) {
      state = state.copyWith(
        events: cached,
        isLoading: false,
        hasMore: false,
        isShowingCachedData: true,
        clearError: true,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasMore: false,
      isShowingCachedData: false,
      error: preferCacheOverError
          ? 'You\'re offline. No cached events for this view yet — connect once while browsing.'
          : 'You\'re offline. No cached events available.',
    );
  }

  String dateFilterLabel() {
    final from = state.filters.dateFrom;
    final to = state.filters.dateTo;
    if (from != null && to != null) {
      return '${_dateFormat.format(from)} – ${_dateFormat.format(to)}';
    }
    if (from != null) return 'From ${_dateFormat.format(from)}';
    if (to != null) return 'Until ${_dateFormat.format(to)}';
    return 'Date';
  }

  Future<bool> createEvent(Map<String, dynamic> eventData) async {
    if (!await _connectivity.isOnline) {
      state = state.copyWith(
        error: 'You\'re offline. Connect to the internet to create events.',
      );
      return false;
    }
    try {
      await _eventService.createEvent(eventData);
      await loadEvents(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: userFacingError(e));
      rethrow;
    }
  }
}
