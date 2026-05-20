class EventCategory {
  final String key;
  final String label;
  final int eventCount;

  const EventCategory({
    required this.key,
    required this.label,
    required this.eventCount,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      key: json['key'] as String,
      label: json['label'] as String,
      eventCount: json['event_count'] as int? ?? 0,
    );
  }
}
