import 'dart:convert';

import 'package:event_ticket_app/models/event_category.dart';
import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists API responses for offline read access.
class OfflineCacheService {
  static const _eventsPrefix = 'offline_events_';
  static const _eventDetailPrefix = 'offline_event_';
  static const _categoriesKey = 'offline_categories';
  static const _ticketsKey = 'offline_tickets';
  static const _ticketDetailPrefix = 'offline_ticket_';
  static const _masterEventsKey = '${_eventsPrefix}all';

  static String eventsCacheKey({
    String? category,
    String? dateFrom,
    String? dateTo,
  }) =>
      '${category ?? ''}|${dateFrom ?? ''}|${dateTo ?? ''}';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveEvents({
    required String cacheKey,
    required List<Event> events,
    bool saveAsMaster = false,
  }) async {
    final prefs = await _prefs;
    final json = jsonEncode(events.map((e) => e.toJson()).toList());
    await prefs.setString('$_eventsPrefix$cacheKey', json);
    if (saveAsMaster) {
      await prefs.setString(_masterEventsKey, json);
    }
  }

  Future<List<Event>?> getEvents({
    required String cacheKey,
    String? category,
    String? dateFrom,
    String? dateTo,
  }) async {
    final prefs = await _prefs;
    final exact = _readEventsList(
      prefs.getString('$_eventsPrefix$cacheKey'),
    );
    if (exact != null) return exact;

    final hasFilters = (category != null && category.isNotEmpty) ||
        dateFrom != null ||
        dateTo != null;
    if (hasFilters) {
      final all = _readEventsList(prefs.getString(_masterEventsKey));
      if (all != null) {
        return _applyClientFilters(
          all,
          category: category,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
      }
    }
    return null;
  }

  List<Event>? _readEventsList(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
  }

  List<Event> _applyClientFilters(
    List<Event> events, {
    String? category,
    String? dateFrom,
    String? dateTo,
  }) {
    return events.where((event) {
      if (category != null &&
          category.isNotEmpty &&
          event.category != category) {
        return false;
      }
      final eventDay = DateTime.parse(event.eventDate);
      final eventDate = DateTime(eventDay.year, eventDay.month, eventDay.day);
      if (dateFrom != null) {
        final from = DateTime.parse(dateFrom);
        if (eventDate.isBefore(from)) return false;
      }
      if (dateTo != null) {
        final to = DateTime.parse(dateTo);
        if (eventDate.isAfter(to)) return false;
      }
      return true;
    }).toList();
  }

  Future<void> saveEventDetail(Event event) async {
    final prefs = await _prefs;
    await prefs.setString(
      '$_eventDetailPrefix${event.id}',
      jsonEncode(event.toJson()),
    );
  }

  Future<Event?> getEventDetail(int id) async {
    final prefs = await _prefs;
    final raw = prefs.getString('$_eventDetailPrefix$id');
    if (raw == null) return null;
    return Event.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveCategories(List<EventCategory> categories) async {
    final prefs = await _prefs;
    await prefs.setString(
      _categoriesKey,
      jsonEncode(categories.map((c) => {
            'key': c.key,
            'label': c.label,
            'event_count': c.eventCount,
          }).toList()),
    );
  }

  Future<List<EventCategory>?> getCategories() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_categoriesKey);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => EventCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTickets(List<Ticket> tickets) async {
    final prefs = await _prefs;
    await prefs.setString(
      _ticketsKey,
      jsonEncode(tickets.map((t) => t.toJson()).toList()),
    );
  }

  Future<List<Ticket>?> getTickets() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_ticketsKey);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((t) => Ticket.fromJson(t as Map<String, dynamic>)).toList();
  }

  Future<void> saveTicketDetail(Ticket ticket) async {
    final prefs = await _prefs;
    await prefs.setString(
      '$_ticketDetailPrefix${ticket.id}',
      jsonEncode(ticket.toJson()),
    );
  }

  Future<Ticket?> getTicketDetail(int id) async {
    final prefs = await _prefs;
    final raw = prefs.getString('$_ticketDetailPrefix$id');
    if (raw == null) return null;
    return Ticket.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys().where(
      (k) =>
          k.startsWith(_eventsPrefix) ||
          k.startsWith(_eventDetailPrefix) ||
          k.startsWith(_ticketDetailPrefix) ||
          k == _categoriesKey ||
          k == _ticketsKey,
    );
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
