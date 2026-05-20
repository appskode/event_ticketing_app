import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'date_selector_widget.dart';

/// Keys must match `App\Models\Event::CATEGORIES` on the Laravel API.
const List<String> kAdminEventCategoryKeys = [
  'music',
  'tech',
  'food_drink',
  'sports',
  'arts',
  'comedy',
  'business',
  'wellness',
  'general',
];

String _adminCategoryLabel(String key) {
  if (key == 'food_drink') return 'Food & drink';
  return key.replaceAll('_', ' ').split(' ').map((w) {
    if (w.isEmpty) return w;
    return '${w[0].toUpperCase()}${w.substring(1)}';
  }).join(' ');
}

class EventFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TextEditingController imageUrlController;
  final String categoryKey;
  final ValueChanged<String> onCategoryChanged;
  final DateTime? eventDate;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;
  final bool allowCancellation;
  final int cancellationHours;
  final Function(DateTime) onEventDateSelected;
  final Function(DateTime) onSaleStartDateSelected;
  final Function(DateTime) onSaleEndDateSelected;
  final Function(bool?) onAllowCancellationChanged;
  final Function(String) onCancellationHoursChanged;

  const EventFormWidget({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.locationController,
    required this.imageUrlController,
    required this.categoryKey,
    required this.onCategoryChanged,
    required this.eventDate,
    required this.saleStartDate,
    required this.saleEndDate,
    required this.allowCancellation,
    required this.cancellationHours,
    required this.onEventDateSelected,
    required this.onSaleStartDateSelected,
    required this.onSaleEndDateSelected,
    required this.onAllowCancellationChanged,
    required this.onCancellationHoursChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Details',
          style: TextStyle(
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceSmall,
        TextFormField(
          controller: nameController,
          style: TextStyle(fontSize: 16.sp),
          decoration: const InputDecoration(
            labelText: 'Event Name*',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter event name' : null,
        ),
        verticalSpaceSmall,
        TextFormField(
          controller: descriptionController,
          style: TextStyle(fontSize: 16.sp),
          decoration: const InputDecoration(
            labelText: 'Description*',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter description' : null,
        ),
        verticalSpaceSmall,
        TextFormField(
          controller: locationController,
          style: TextStyle(fontSize: 16.sp),
          decoration: const InputDecoration(
            labelText: 'Location*',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter location' : null,
        ),
        verticalSpaceSmall,
        DropdownButtonFormField<String>(
          key: ValueKey('admin_category_$categoryKey'),
          initialValue: categoryKey,
          decoration: const InputDecoration(
            labelText: 'Category*',
            border: OutlineInputBorder(),
          ),
          items: kAdminEventCategoryKeys
              .map(
                (k) => DropdownMenuItem(
                  value: k,
                  child: Text(_adminCategoryLabel(k)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onCategoryChanged(value);
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Please select a category' : null,
        ),
        verticalSpaceSmall,
        TextFormField(
          controller: imageUrlController,
          style: TextStyle(fontSize: 16.sp),
          decoration: const InputDecoration(
            labelText: 'Image URL (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        verticalSpaceMedium,
        DateSelectorWidget(
          label: 'Event Date*',
          selectedDate: eventDate,
          onDateSelected: onEventDateSelected,
        ),
        verticalSpaceSmall,
        DateSelectorWidget(
          label: 'Sale Start Date*',
          selectedDate: saleStartDate,
          onDateSelected: onSaleStartDateSelected,
        ),
        verticalSpaceSmall,
        DateSelectorWidget(
          label: 'Sale End Date*',
          selectedDate: saleEndDate,
          onDateSelected: onSaleEndDateSelected,
        ),
        verticalSpaceMedium,
        Row(
          children: [
            Checkbox(
              value: allowCancellation,
              onChanged: onAllowCancellationChanged,
            ),
            Text(
              'Allow ticket cancellation',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
        if (allowCancellation) ...[
          verticalSpaceSmall,
          TextFormField(
            initialValue: cancellationHours.toString(),
            style: TextStyle(fontSize: 16.sp),
            decoration: const InputDecoration(
              labelText: 'Cancellation hours before event',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: onCancellationHoursChanged,
          ),
        ],
      ],
    );
  }
}
