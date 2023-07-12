import 'package:go_router/go_router.dart';
import '../../presentations/screens/views.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/exercises_pending_view',
      name: PhonemeView.name,
      builder: (context, state) => const PhonemeView(),
    ),
    GoRoute(
      path: '/messages_view',
      name: MessagesView.name,
      builder: (context, state) => const MessagesView(),
    ),
    GoRoute(
      path: '/turns_view',
      name: TurnsView.name,
      builder: (context, state) => const TurnsView(),
    ),
  ],
);
