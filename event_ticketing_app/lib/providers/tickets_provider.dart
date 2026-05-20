import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/services/connectivity_service.dart';
import 'package:event_ticket_app/services/offline_cache_service.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:event_ticket_app/services/storage_service.dart';
import 'package:event_ticket_app/services/ticket_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final ticketsProvider = StateNotifierProvider<TicketsNotifier, TicketsState>((
  ref,
) {
  return TicketsNotifier(
    ref.watch(ticketServiceProvider),
    ref.watch(storageServiceProvider),
    ref.watch(offlineCacheServiceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class TicketsState {
  final List<Ticket> tickets;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;
  final bool isShowingCachedData;

  TicketsState({
    this.tickets = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.isShowingCachedData = false,
  });

  TicketsState copyWith({
    List<Ticket>? tickets,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? hasMore,
    int? currentPage,
    bool? isShowingCachedData,
  }) {
    return TicketsState(
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isShowingCachedData: isShowingCachedData ?? this.isShowingCachedData,
    );
  }
}

class TicketsNotifier extends StateNotifier<TicketsState> {
  final TicketService _ticketService;
  final StorageService _storage;
  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;

  TicketsNotifier(
    this._ticketService,
    this._storage,
    this._cache,
    this._connectivity,
  ) : super(TicketsState()) {
    loadTickets();
  }

  Future<void> loadTickets({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        tickets: [],
        currentPage: 1,
        hasMore: true,
        clearError: true,
        isShowingCachedData: false,
      );
    }

    if (!refresh && state.tickets.isEmpty) {
      final cached = await _loadCachedTickets();
      if (cached.isNotEmpty) {
        state = state.copyWith(tickets: cached);
      }
    }

    final online = await _connectivity.isOnline;
    if (!online) {
      await _showCachedOnly();
      return;
    }

    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response =
          await _ticketService.getMyTickets(page: state.currentPage);
      final List<dynamic> ticketsData = response['data']['data'];
      final newTickets =
          ticketsData.map((t) => Ticket.fromJson(t)).toList();
      final hasMore = response['data']['next_page_url'] != null;
      final allTickets =
          refresh ? newTickets : [...state.tickets, ...newTickets];

      await _persistTickets(allTickets);

      state = state.copyWith(
        tickets: allTickets,
        isLoading: false,
        hasMore: hasMore,
        currentPage: state.currentPage + 1,
        isShowingCachedData: false,
      );
    } catch (e) {
      if (isNetworkError(e)) {
        await _showCachedOnly(preferOverError: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: userFacingError(e),
        );
      }
    }
  }

  Future<List<Ticket>> _loadCachedTickets() async {
    final fromPrefs = await _cache.getTickets();
    if (fromPrefs != null && fromPrefs.isNotEmpty) return fromPrefs;
    return _storage.getStoredTickets();
  }

  Future<void> _persistTickets(List<Ticket> tickets) async {
    await _storage.saveTickets(tickets);
    await _cache.saveTickets(tickets);
    for (final ticket in tickets) {
      await _cache.saveTicketDetail(ticket);
    }
  }

  Future<void> _showCachedOnly({bool preferOverError = false}) async {
    final cached = await _loadCachedTickets();
    if (cached.isNotEmpty) {
      state = state.copyWith(
        tickets: cached,
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
      error: preferOverError
          ? 'You\'re offline. No tickets cached yet — connect once while signed in.'
          : 'You\'re offline. No cached tickets available.',
    );
  }

  Future<bool> cancelTicket(int ticketId) async {
    if (!await _connectivity.isOnline) {
      state = state.copyWith(
        error: 'You\'re offline. Connect to cancel a ticket.',
      );
      return false;
    }
    try {
      await _ticketService.cancelTicket(ticketId);
      await loadTickets(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(error: userFacingError(e));
      return false;
    }
  }
}
