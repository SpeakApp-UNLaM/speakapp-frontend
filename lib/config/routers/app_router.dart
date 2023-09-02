import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_front/auth/check_auth_status_screen.dart';
import 'package:sp_front/presentations/screens/choice_exercise_screen.dart';
import '../../presentations/screens/auth/screens/login_screen.dart';
import '../../presentations/screens/auth/screens/register_screen.dart';
import '../../presentations/screens/exercise_screen.dart';
import '../../presentations/screens/views.dart';

// GoRouter configuration

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
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
  ],
);
