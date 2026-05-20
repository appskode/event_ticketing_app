import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/admin/widget/ticket_card_widget.dart';
import 'package:flutter/material.dart';

class TicketTypesSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> ticketTypes;
  final Function(Map<String, dynamic>) onAddTicketType;
  final Function(int) onRemoveTicketType;

  const TicketTypesSectionWidget({
    super.key,
    required this.ticketTypes,
    required this.onAddTicketType,
    required this.onRemoveTicketType,
  });

  void _showAddTicketDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Ticket Type',
          style: TextStyle(fontSize: 21.sp),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(fontSize: 16.sp),
                decoration: const InputDecoration(
                  labelText: 'Ticket Name*',
                  border: OutlineInputBorder(),
                ),
              ),
              verticalSpaceSmall,
              TextField(
                controller: descriptionController,
                style: TextStyle(fontSize: 16.sp),
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              verticalSpaceSmall,
              TextField(
                controller: priceController,
                style: TextStyle(fontSize: 16.sp),
                decoration: const InputDecoration(
                  labelText: 'Price*',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
              ),
              verticalSpaceSmall,
              TextField(
                controller: quantityController,
                style: TextStyle(fontSize: 16.sp),
                decoration: const InputDecoration(
                  labelText: 'Total Quantity*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty) {
                onAddTicketType({
                  'name': nameController.text,
                  'description': descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                  'quantity': int.tryParse(quantityController.text) ?? 0,
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Add',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ticket Types',
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddTicketDialog(context),
              icon: Icon(Icons.add, size: 14.sp),
              label: Text(
                'Add Ticket',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
        verticalSpaceSmall,
        if (ticketTypes.isEmpty)
          Container(
            padding: EdgeInsets.all(SMALL_PADDING.w + 14.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Center(
              child: Text(
                'No ticket types added yet.\nClick "Add Ticket" to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 16.sp,
                ),
              ),
            ),
          )
        else
          ...List.generate(
            ticketTypes.length,
            (index) => TicketTypeCardWidget(
              ticketType: ticketTypes[index],
              index: index,
              onRemove: () => onRemoveTicketType(index),
            ),
          ),
      ],
    );
  }
}
