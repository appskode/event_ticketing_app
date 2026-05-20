import 'package:event_ticket_app/app/page_transitions.dart';
import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/providers/auth_provider.dart';
import 'package:event_ticket_app/ui/screens/admin/create_event_screen.dart';
import 'package:event_ticket_app/ui/screens/auth/login_screen.dart';
import 'package:event_ticket_app/ui/screens/auth/register_screen.dart';
import 'package:event_ticket_app/ui/screens/event_detail/event_detail_screen.dart';
import 'package:event_ticket_app/ui/screens/home/home_screen.dart';
import 'package:event_ticket_app/ui/screens/purchase/purchase_screen.dart';
import 'package:event_ticket_app/ui/screens/splash/splash_screen.dart';
import 'package:event_ticket_app/ui/screens/tickets/ticket_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final isAuthRoute = location.startsWith('/auth');
      final isSplash = location == '/';

      if (isLoading) {
        return isSplash ? null : '/';
      }

      if (!isAuthenticated) {
        return isAuthRoute ? null : '/auth/login';
      }

      if (isSplash || isAuthRoute) {
        return '/home';
      }

      if (location.startsWith('/admin') && !(authState.user?.isAdmin ?? false)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0;
          return HomeScreen(initialTabIndex: tab);
        },
      ),
      GoRoute(
        path: '/auth/login',
        pageBuilder: (context, state) => heroFriendlyPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/register',
        pageBuilder: (context, state) => heroFriendlyPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/event/:id',
        pageBuilder: (context, state) {
          final preview = state.extra is Event ? state.extra as Event : null;
          return heroFriendlyPage(
            key: state.pageKey,
            child: EventDetailScreen(
              eventId: int.parse(state.pathParameters['id']!),
              previewEvent: preview,
            ),
          );
        },
      ),
      GoRoute(
        path: '/purchase/:eventId',
        pageBuilder: (context, state) => heroFriendlyPage(
          key: state.pageKey,
          child: PurchaseScreen(
            eventId: int.parse(state.pathParameters['eventId']!),
          ),
        ),
      ),
      GoRoute(
        path: '/ticket/:id',
        pageBuilder: (context, state) => heroFriendlyPage(
          key: state.pageKey,
          child: TicketDetailScreen(
            ticketId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ),
      GoRoute(
        path: '/admin/create-event',
        pageBuilder: (context, state) => heroFriendlyPage(
          key: state.pageKey,
          child: const CreateEventScreen(),
        ),
      ),
    ],
  );
});
