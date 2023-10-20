import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/presentations/screens/choice_exercise_screen.dart';
import 'package:sp_front/presentations/screens/choice_exercise_specialist_screen.dart';
import 'package:sp_front/presentations/screens/choice_patient_screen.dart';
import 'package:sp_front/presentations/screens/home_specialist_screen.dart';
import 'package:sp_front/providers/auth_provider.dart';
import '../../domain/entities/phoneme.dart';
import '../../domain/entities/task.dart';
import '../../presentations/screens/auth/screens/login_screen.dart';
import '../../presentations/screens/auth/screens/register_screen.dart';
import '../../presentations/screens/exercise_screen.dart';
import '../../presentations/screens/exercise_specialist_screen.dart';
import '../../presentations/screens/rfi_screen.dart';
import '../../presentations/screens/views.dart';
import '../../presentations/screens/views/phoneme_specialist_view.dart';

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
      GoRoute(
        name: 'ChoicePatientScreen',
        path: '/choice_patient',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ChoicePatientScreen(),
        ),
      ),
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            if (authProvider.typeUser == "professional") {
              return HomeSpecialistScreen(childView: child);
            }
            return HomeScreen(childView: child);
          },
          routes: [
            GoRoute(
              path: '/',
              name: 'HomeScreen',
              parentNavigatorKey: _shellNavigator,
              pageBuilder: (context, state) {
                if (authProvider.typeUser == "professional") {
                  return CustomTransitionPage(
                    name: 'PhonemeSpecialistScreen',
                    key: state.pageKey,
                    child: const PhonemeSpecialistView(),
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
                }
                int idPatient;
                if (state.extra == null) {
                  idPatient = authProvider.prefs.getInt('userId') as int;
                } else {
                  idPatient = state.extra as int;
                }
                return CustomTransitionPage(
                  name: 'PhonemeScreen',
                  key: state.pageKey,
                  child: PhonemeView(idPatient: idPatient),
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
              path: '/rfi_view',
              name: 'rfi_view',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const RfiView(),
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
            GoRoute(
              path: '/choice_exercise_specialist',
              name: 'choice_exercise_specialist',
              pageBuilder: (context, state) {
                Phoneme args = state.extra as Phoneme;

                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ChoiceExerciseSpecialistScreen(phoneme: args),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
          path: '/rfi',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            return const RfiScreen();
          }),
      GoRoute(
          path: '/exercise',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            ExerciseParameters params = state.extra as ExerciseParameters;
            return ExerciseScreen(object: params);
          }),
      GoRoute(
          path: '/exercise_specialist',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            Map<String, dynamic> queryParameters =
                state.extra as Map<String, dynamic>;
            return ExerciseSpecialistScreen(
              queryParameters: queryParameters,
              namePhoneme: queryParameters["namePhoneme"],
            );
          }),
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      //final createAccountLoc = state.namedLocation(createAccountRouteName);
      //final creatingAccount = state.subloc == createAccountLoc;
      final loggedIn = authProvider.loggedIn;
      //final rootLoc = state.namedLocation(rootRouteName);

/*
      if (state.fullPath == '/register') {
        if (loggedIn) return '/home';
      } else {
        if (!loggedIn) return '/login';
      }*/

      if (!loggedIn) return '/login';
      return null;
    },
  );
}
