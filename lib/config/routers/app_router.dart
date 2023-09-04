import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/auth/check_auth_status_screen.dart';
import 'package:sp_front/presentations/screens/choice_exercise_screen.dart';
import 'package:sp_front/providers/auth_provider.dart';
import '../../presentations/screens/auth/screens/login_screen.dart';
import '../../presentations/screens/auth/screens/register_screen.dart';
import '../../presentations/screens/exercise_screen.dart';
import '../../presentations/screens/views.dart';

// GoRouter configuration
class AppRouter {
  final AuthProvider authProvider;
  AppRouter(this.authProvider);

  late final router = GoRouter(
    refreshListenable: authProvider,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: 'LoginScreen',
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: 'RegisterScreen',
        path: '/register',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      ShellRoute(
          builder: (context, state, child) {
            return HomeScreen(childView: child);
          },
          routes: [
            GoRoute(
              path: '/',
              name: 'HomeScreen',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  name: 'PhonemeScreen',
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
              name: 'MessageScreen',
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
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loginLoc = state.pageKey;
      final loggingIn = state.matchedLocation == loginLoc;
      
      //final createAccountLoc = state.namedLocation(createAccountRouteName);
      //final creatingAccount = state.subloc == createAccountLoc;
      final loggedIn = authProvider.loggedIn;
      //final rootLoc = state.namedLocation(rootRouteName);

      if (!loggedIn) return '/login';
      return null;
    },
  );
}
