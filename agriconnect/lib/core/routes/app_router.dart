import 'package:go_router/go_router.dart';

import '../../screens/home_screen.dart';
import '../../screens/cultures_screen.dart';
import '../../screens/activites_screen.dart';
import '../../screens/conseils_screen.dart';
import '../../screens/culture_form_screen.dart';
import '../../models/culture.dart';
import '../../screens/culture_detail_screen.dart';
//import '../../screens/activites_screen.dart';
import '../../screens/activite_form_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cultures',
      builder: (context, state) => const CulturesScreen(),
    ),
    GoRoute(
      path: '/activites',
      builder: (context, state) => const ActivitesScreen(),
    ),
    GoRoute(
      path: '/conseils',
      builder: (context, state) => const ConseilsScreen(),
    ),
    GoRoute(
      path: '/cultures/new',
      builder: (context, state) => const CultureFormScreen(),
    ),
    GoRoute(
      path: '/cultures/:id',
      builder: (context, state) {
        return CultureDetailScreen(
          cultureId: state.pathParameters['id']!,
        );
      },
    ),
    GoRoute(
      path: '/cultures/:id/edit',
      builder: (context, state) {
        final culture = state.extra as Culture;

        return CultureFormScreen(
          culture: culture,
        );
      },
    ),
    GoRoute(
      path: '/activites',
      builder: (context, state) => const ActivitesScreen(),
    ),
    GoRoute(
      path: '/activites/new',
      builder: (context, state) => const ActiviteFormScreen(),
    ),
  ],
);