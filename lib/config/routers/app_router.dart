import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/auth/check_auth_status_screen.dart';
import 'package:sp_front/presentations/screens/choice_exercise_screen.dart';
import 'package:sp_front/providers/auth_provider.dart';
import '../../domain/entities/task.dart';
import '../../presentations/screens/auth/screens/login_screen.dart';
import '../../presentations/screens/auth/screens/register_screen.dart';
import '../../presentations/screens/exercise_screen.dart';
import '../../presentations/screens/views.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

// GoRouter configuration
class AppRouter {
  final AuthProvider authProvider;
  AppRouter(this.authProvider);

  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
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
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            return HomeScreen(childView: child);
          },
          routes: [
            GoRoute(
              path: '/',
              name: 'HomeScreen',
              parentNavigatorKey: _shellNavigator,
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
              parentNavigatorKey: _shellNavigator,
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
              parentNavigatorKey: _shellNavigator,
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
              path: '/choice_exercise',
              name: 'choice_exercise',
              pageBuilder: (context, state) {
                Task args = state.extra as Task;

                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ChoiceExerciseScreen(object: args),
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
          path: '/exercise',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            ExerciseParameters params = state.extra as ExerciseParameters;
            return ExerciseScreen(object: params);
          }),
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loginLoc = state.pageKey;
      final loggingIn = state.matchedLocation == loginLoc;

      //final createAccountLoc = state.namedLocation(createAccountRouteName);
      //final creatingAccount = state.subloc == createAccountLoc;
      final loggedIn = authProvider.loggedIn;
      //final rootLoc = state.namedLocation(rootRouteName);

      if (state.fullPath == '/register') {
        // Si estás en la página de registro y el usuario está autenticado, puedes redirigir a otra página, por ejemplo, la página de inicio.
        if (loggedIn) return '/home';
      } else {
        // Si no estás en la página de registro, aplicar la lógica original.
        if (!loggedIn) return '/login';
      }

      // En cualquier otro caso, no redirigir.
      return null;
    },
  );
}
