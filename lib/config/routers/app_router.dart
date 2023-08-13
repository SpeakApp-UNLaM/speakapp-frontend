import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_front/presentations/screens/choice_exercise_screen.dart';
import '../../presentations/screens/exercise_screen.dart';
import '../../presentations/screens/views.dart';

// GoRouter configuration
/*
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
);*/

final appRouter = GoRouter(initialLocation: '/', routes: [
  ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const PhonemeView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/messages_view',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const MessagesView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/turns_view',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const TurnsView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/choice_exercise/:phoneme/:namePhoneme',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: ChoiceExerciseScreen(
                  phoneme: int.parse("${state.pathParameters['phoneme']}"),
                  namePhoneme: "${state.pathParameters['namePhoneme']}"),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ]),
  GoRoute(
    path: '/exercise/:idPhoneme/:namePhoneme/:level/:categorias',
    builder: (context, state) => ExerciseScreen(
        idPhoneme: int.parse("${state.pathParameters['idPhoneme']}"),
        namePhoneme: "${state.pathParameters['namePhoneme']}",
        level: "${state.pathParameters['level']}",
        categorias: "${state.pathParameters['categorias']}"),
  ),
]);
