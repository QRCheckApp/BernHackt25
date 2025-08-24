import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/trips/presentation/trips_dashboard_page.dart';
import '../../features/trips/presentation/trip_detail_page.dart';
import '../../features/trips/stage1/swipe_page.dart';
import '../../features/common/presentation/shell_scaffold.dart';
import '../../features/onboarding/presentation/profile_onboarding_page.dart';
import '../../features/app_state/providers.dart';

// Router provider that handles onboarding redirect
final routerProvider = Provider<GoRouter>((ref) {
  final onboardingComplete = ref.watch(onboardingCompleteProvider);
  
  return GoRouter(
    initialLocation: onboardingComplete ? '/trips' : '/profile/onboarding',
    routes: [
      GoRoute(
        path: '/profile/onboarding',
        builder: (context, state) => const ProfileOnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/trips',
            builder: (context, state) => const TripsDashboardPage(),
            routes: [
              GoRoute(
                path: ':tripId',
                builder: (context, state) {
                  final tripId = state.pathParameters['tripId']!;
                  return TripDetailPage(tripId: tripId);
                },
                routes: [
                  GoRoute(
                    path: 'swipe',
                    builder: (context, state) {
                      final tripId = state.pathParameters['tripId']!;
                      return TripSwipePage(tripId: tripId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
