import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/providers/auth_provider.dart';
import 'package:event_ticket_app/providers/event_categories_provider.dart';
import 'package:event_ticket_app/providers/events_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/events/widget/event_card.dart';
import 'package:event_ticket_app/ui/screens/events/widget/event_filters_bar.dart';
import 'package:event_ticket_app/ui/widgets/custom_app_bar.dart';
import 'package:event_ticket_app/ui/widgets/event_hero_image.dart';
import 'package:event_ticket_app/ui/widgets/list_error_view.dart';
import 'package:event_ticket_app/ui/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final eventsState = ref.read(eventsProvider);
    if (eventsState.isShowingCachedData) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(eventsProvider.notifier).loadEvents();
    }
  }

  Future<void> _refresh() =>
      ref.read(eventsProvider.notifier).loadEvents(refresh: true);

  String? _categoryLabel(String key) {
    final categories = ref.read(eventCategoriesProvider).value;
    if (categories == null) return null;
    for (final category in categories) {
      if (category.key == key) return category.label;
    }
    return null;
  }

  void _openEvent(Event event) {
    ref.read(offlineCacheServiceProvider).saveEventDetail(event);
    precacheEventImage(context, event.imageUrl);
    context.push('/event/${event.id}', extra: event);
  }

  void _openCreateEvent() {
    final online = ref.read(isOnlineProvider).value ?? true;
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You\'re offline. Connect to create events.'),
        ),
      );
      return;
    }
    context.push('/admin/create-event');
  }

  Future<void> _signOut() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final eventsState = ref.watch(eventsProvider);
    final user = authState.user;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        subtitle: user != null ? 'Hi, ${user.name.split(' ').first}' : null,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 22.sp),
            onSelected: (value) {
              if (value == 'logout') _signOut();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Sign out')),
            ],
          ),
        ],
      ),
      floatingActionButton: user?.isAdmin == true
          ? FloatingActionButton.extended(
              onPressed: _openCreateEvent,
              icon: const Icon(Icons.add),
              label: const Text('Event'),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const EventFiltersBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: colorScheme.primary,
              child: _buildBody(eventsState, colorScheme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(EventsState eventsState, ColorScheme colorScheme) {
    if (eventsState.isLoading && eventsState.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventsState.error != null && eventsState.events.isEmpty) {
      return ListErrorView(
        message: eventsState.error!,
        onRetry: _refresh,
      );
    }

    if (eventsState.events.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          SizedBox(height: screenHeight(context) * 0.18),
          Icon(
            Icons.event_busy_outlined,
            size: 72.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          verticalSpaceSmall,
          Text(
            eventsState.filters.isActive
                ? 'No events match your filters'
                : 'No events yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpaceTiny,
          Text(
            eventsState.filters.isActive
                ? 'Try adjusting category or date range'
                : 'Check back soon for new events',
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (eventsState.filters.isActive) ...[
            verticalSpaceSmall,
            Center(
              child: TextButton(
                onPressed: () =>
                    ref.read(eventsProvider.notifier).clearFilters(),
                child: const Text('Clear filters'),
              ),
            ),
          ],
        ],
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (eventsState.isShowingCachedData)
          const SliverToBoxAdapter(child: CachedDataBanner()),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 88.h),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= eventsState.events.length) {
                  return Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final event = eventsState.events[index];
                return EventCard(
                  event: event,
                  categoryLabel: _categoryLabel(event.category),
                  onTap: () => _openEvent(event),
                );
              },
              childCount:
                  eventsState.events.length + (eventsState.hasMore ? 1 : 0),
            ),
          ),
        ),
      ],
    );
  }
}
