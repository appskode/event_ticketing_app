import 'package:event_ticket_app/providers/auth_provider.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/providers/events_provider.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/admin/widget/event_form_widget.dart';
import 'package:event_ticket_app/ui/screens/admin/widget/ticket_type_selector.dart';
import 'package:event_ticket_app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime? _eventDate;
  DateTime? _saleStartDate;
  DateTime? _saleEndDate;
  bool _allowCancellation = true;
  int _cancellationHours = 24;
  String _category = 'general';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _ticketTypes = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateEventDate(DateTime date) => setState(() => _eventDate = date);
  void _updateSaleStartDate(DateTime date) =>
      setState(() => _saleStartDate = date);
  void _updateSaleEndDate(DateTime date) => setState(() => _saleEndDate = date);
  void _updateAllowCancellation(bool? value) =>
      setState(() => _allowCancellation = value ?? false);
  void _updateCancellationHours(String value) => setState(
        () => _cancellationHours = int.tryParse(value) ?? 24,
      );
  void _addTicketType(Map<String, dynamic> ticketType) =>
      setState(() => _ticketTypes.add(ticketType));
  void _removeTicketType(int index) =>
      setState(() => _ticketTypes.removeAt(index));

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user?.isAdmin != true) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Create Event', hasBackButton: true),
        body: Center(
          child: Text(
            'You do not have permission to access this page.',
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Event'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(SMALL_PADDING.w + 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventFormWidget(
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      locationController: _locationController,
                      imageUrlController: _imageUrlController,
                      categoryKey: _category,
                      onCategoryChanged: (v) => setState(() => _category = v),
                      eventDate: _eventDate,
                      saleStartDate: _saleStartDate,
                      saleEndDate: _saleEndDate,
                      allowCancellation: _allowCancellation,
                      cancellationHours: _cancellationHours,
                      onEventDateSelected: _updateEventDate,
                      onSaleStartDateSelected: _updateSaleStartDate,
                      onSaleEndDateSelected: _updateSaleEndDate,
                      onAllowCancellationChanged: _updateAllowCancellation,
                      onCancellationHoursChanged: _updateCancellationHours,
                    ),
                    verticalSpaceMedium,
                    TicketTypesSectionWidget(
                      ticketTypes: _ticketTypes,
                      onAddTicketType: _addTicketType,
                      onRemoveTicketType: _removeTicketType,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(SMALL_PADDING.w + 14.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, -5.h),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed:
                      _isLoading || _ticketTypes.isEmpty ? null : _createEvent,
                  child: _isLoading
                      ? CircularProgressIndicator(color: colorScheme.onPrimary)
                      : Text(
                          'Create Event',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    final online = ref.read(isOnlineProvider).value ?? true;
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You\'re offline. Connect to create events.'),
        ),
      );
      return;
    }

    if (_eventDate == null || _saleStartDate == null || _saleEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all required dates')),
      );
      return;
    }
    if (_ticketTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ticket type')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final eventData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'category': _category,
        'image_url': _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        'event_date': _eventDate!.toIso8601String(),
        'sale_start_date': _saleStartDate!.toIso8601String(),
        'sale_end_date': _saleEndDate!.toIso8601String(),
        'allow_cancellation': _allowCancellation,
      };
      if (_allowCancellation) {
        eventData['cancellation_hours_before'] = _cancellationHours;
      }

      final created =
          await ref.read(eventsProvider.notifier).createEvent(eventData);

      if (created != null) {
        for (final ticketType in _ticketTypes) {
          final ticketData = {
            'name': ticketType['name'],
            'description': ticketType['description'],
            'price': ticketType['price'],
            'total_quantity': ticketType['quantity'],
          };

          await ref
              .read(eventServiceProvider)
              .addTicketType(created.id, ticketData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully!')),
          );
          context.pop();
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create event. Please try again.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
