import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/providers/event_categories_provider.dart';
import 'package:event_ticket_app/providers/events_provider.dart';
import 'package:event_ticket_app/providers/tickets_provider.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/events/events_screen.dart';
import 'package:event_ticket_app/ui/screens/tickets/my_tickets_screen.dart';
import 'package:event_ticket_app/ui/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  final List<Widget> _screens = const [
    EventsScreen(),
    MyTicketsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex.clamp(0, _screens.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(isOnlineProvider, (previous, next) {
      final wasOffline = previous?.value == false;
      final isOnline = next.value == true;
      if (wasOffline && isOnline) {
        ref.read(eventsProvider.notifier).loadEvents(refresh: true);
        ref.read(ticketsProvider.notifier).loadTickets(refresh: true);
        ref.invalidate(eventCategoriesProvider);
      }
    });

    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        height: 64.h,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'My Tickets',
          ),
        ],
      ),
    );
  }
}
