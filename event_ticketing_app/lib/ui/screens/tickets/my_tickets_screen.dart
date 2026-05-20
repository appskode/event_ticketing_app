import 'package:event_ticket_app/providers/tickets_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/tickets/widget/ticket_card.dart';
import 'package:event_ticket_app/ui/widgets/custom_app_bar.dart';
import 'package:event_ticket_app/ui/widgets/list_error_view.dart';
import 'package:event_ticket_app/ui/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyTicketsScreen extends ConsumerStatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  ConsumerState<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends ConsumerState<MyTicketsScreen> {
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
    final ticketsState = ref.read(ticketsProvider);
    if (ticketsState.isShowingCachedData) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(ticketsProvider.notifier).loadTickets();
    }
  }

  Future<void> _refresh() =>
      ref.read(ticketsProvider.notifier).loadTickets(refresh: true);

  @override
  Widget build(BuildContext context) {
    final ticketsState = ref.watch(ticketsProvider);
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'My Tickets',
        subtitle: 'Tap a ticket to show your QR code',
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: colorScheme.primary,
        child: _buildBody(ticketsState, colorScheme),
      ),
    );
  }

  Widget _buildBody(TicketsState ticketsState, ColorScheme colorScheme) {
    if (ticketsState.isLoading && ticketsState.tickets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ticketsState.error != null && ticketsState.tickets.isEmpty) {
      return ListErrorView(message: ticketsState.error!, onRetry: _refresh);
    }

    if (ticketsState.tickets.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          SizedBox(height: screenHeight(context) * 0.2),
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              size: 56.sp,
              color: colorScheme.primary,
            ),
          ),
          verticalSpaceMedium,
          Text(
            'No tickets yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          verticalSpaceSmall,
          Text(
            'Find an event you love and grab your first ticket.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.45,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return _buildTicketsList(ticketsState);
  }

  Widget _buildTicketsList(TicketsState ticketsState) {
    final now = DateTime.now();
    final upcomingTickets = ticketsState.tickets
        .where(
          (t) =>
              t.event != null &&
              DateTime.parse(t.event!.eventDate).isAfter(now),
        )
        .toList();
    final pastTickets = ticketsState.tickets
        .where(
          (t) =>
              t.event != null &&
              !DateTime.parse(t.event!.eventDate).isAfter(now),
        )
        .toList();

    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        if (ticketsState.isShowingCachedData) const CachedDataBanner(),
        _StatsRow(
          upcoming: upcomingTickets.length,
          past: pastTickets.length,
        ),
        verticalSpaceSmall,
        if (upcomingTickets.isNotEmpty) ...[
          _TabLabel(
            icon: Icons.upcoming_outlined,
            label: 'Upcoming',
            count: upcomingTickets.length,
          ),
          ...upcomingTickets.map(
            (ticket) => TicketCard(
              ticket: ticket,
              onTap: () => context.push('/ticket/${ticket.id}'),
            ),
          ),
        ] else
          _EmptySection(message: 'No upcoming events on your calendar'),
        verticalSpaceMedium,
        if (pastTickets.isNotEmpty) ...[
          _TabLabel(
            icon: Icons.history,
            label: 'Past',
            count: pastTickets.length,
          ),
          ...pastTickets.map(
            (ticket) => TicketCard(
              ticket: ticket,
              isPast: true,
              onTap: () => context.push('/ticket/${ticket.id}'),
            ),
          ),
        ] else if (upcomingTickets.isNotEmpty)
          _EmptySection(message: 'No past tickets yet'),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.upcoming, required this.past});

  final int upcoming;
  final int past;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Upcoming',
            value: '$upcoming',
            color: colorScheme.primary,
            background: colorScheme.primaryContainer.withValues(alpha: 0.35),
          ),
        ),
        horizontalSpaceSmall,
        Expanded(
          child: _StatCard(
            label: 'Past',
            value: '$past',
            color: colorScheme.onSurfaceVariant,
            background: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          verticalSpaceTiny,
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: colorScheme.primary),
          horizontalSpaceSmall,
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          horizontalSpaceTiny,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
