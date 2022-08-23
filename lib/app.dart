import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/authentication/bloc/authentication_bloc.dart';
import 'package:login_bloc/home/view/home_page.dart';
import 'package:login_bloc/login/view/login_page.dart';
import 'package:login_bloc/splash/view/splash_page.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App(
      {required this.authenticationRepository, required this.userRepository});

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
            userRepository: userRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: ((context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: ((context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(), (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(), (route) => false);
                break;
              case AuthenticationStatus.unknown:
                break;
            }
          }),
          child: child,
        );
      }),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
