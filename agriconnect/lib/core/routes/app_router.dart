import 'package:go_router/go_router.dart';

import '../../screens/home_screen.dart';
import '../../screens/cultures_screen.dart';
import '../../screens/activites_screen.dart';
import '../../screens/conseils_screen.dart';

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
  ],
);