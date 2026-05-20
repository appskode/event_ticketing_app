import 'package:event_ticket_app/providers/event_categories_provider.dart';
import 'package:event_ticket_app/providers/events_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EventFiltersBar extends ConsumerWidget {
  const EventFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsProvider);
    final filters = eventsState.filters;
    final colorScheme = context.colorScheme;
    final categories = ref.watch(eventCategoriesProvider).value ?? [];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 38.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: filters.category == null,
                  onSelected: () =>
                      ref.read(eventsProvider.notifier).setCategory(null),
                ),
                ...categories.map(
                  (category) => _CategoryChip(
                    label: category.label,
                    selected: filters.category == category.key,
                    onSelected: () => ref
                        .read(eventsProvider.notifier)
                        .setCategory(category.key),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceTiny,
          Row(
            children: [
              FilterChip(
                label: Text(
                  ref.read(eventsProvider.notifier).dateFilterLabel(),
                  style: TextStyle(fontSize: 13.sp),
                ),
                selected: filters.dateFrom != null || filters.dateTo != null,
                showCheckmark: false,
                avatar: Icon(
                  Icons.calendar_month_outlined,
                  size: 16.sp,
                  color: filters.dateFrom != null || filters.dateTo != null
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                onSelected: (_) => _showDateFilterSheet(context, ref),
              ),
              if (filters.isActive) ...[
                horizontalSpaceSmall,
                TextButton.icon(
                  onPressed: () =>
                      ref.read(eventsProvider.notifier).clearFilters(),
                  icon: Icon(Icons.close, size: 16.sp),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDateFilterSheet(BuildContext context, WidgetRef ref) async {
    final filters = ref.read(eventsProvider).filters;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _DateFilterSheet(
        initialFrom: filters.dateFrom,
        initialTo: filters.dateTo,
        onApply: (from, to) {
          ref.read(eventsProvider.notifier).setDateRange(from: from, to: to);
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 13.sp)),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class _DateFilterSheet extends StatefulWidget {
  const _DateFilterSheet({
    required this.initialFrom,
    required this.initialTo,
    required this.onApply,
  });

  final DateTime? initialFrom;
  final DateTime? initialTo;
  final void Function(DateTime? from, DateTime? to) onApply;

  @override
  State<_DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<_DateFilterSheet> {
  late DateTime? _from;
  late DateTime? _to;
  static final _displayFormat = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom
        ? (_from ?? DateTime.now())
        : (_to ?? _from ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        if (_to != null && _to!.isBefore(_from!)) _to = _from;
      } else {
        _to = picked;
        if (_from != null && _from!.isAfter(_to!)) _from = _to;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        8.h,
        20.w,
        20.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Filter by date',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          verticalSpaceSmall,
          _DateTile(
            label: 'From',
            value: _from != null ? _displayFormat.format(_from!) : 'Any date',
            onTap: () => _pickDate(isFrom: true),
          ),
          _DateTile(
            label: 'To',
            value: _to != null ? _displayFormat.format(_to!) : 'Any date',
            onTap: () => _pickDate(isFrom: false),
          ),
          verticalSpaceSmall,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onApply(null, null);
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: FilledButton(
                  onPressed: (_from != null || _to != null)
                      ? () {
                          widget.onApply(_from, _to);
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      title: Text(label, style: TextStyle(fontSize: 12.sp, color: colorScheme.onSurfaceVariant)),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: colorScheme.primary),
      onTap: onTap,
    );
  }
}
