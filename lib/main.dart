import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Login/blocs/AuthBloc.dart';
import 'Login/repos/AuthRepo.dart';
import 'Login/screens/HomePage.dart';
import 'Login/screens/LoginPage.dart';
import 'Login/screens/SplashScreen.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition.toString());
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
//  runApp(App(authRepo: AuthRepository()));

  final authRepo = AuthRepository();
  runApp(
      BlocProvider<AuthBloc>(
        bloc: AuthBloc(authRepo: authRepo)
        ..dispatch(AppStarted()),
        child: App(authRepo: authRepo,),
      )
  );
}

class App extends StatefulWidget {
  final AuthRepository authRepo;

  App({Key key, @required this.authRepo}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthBloc authenticationBloc;
  AuthRepository get authRepo => widget.authRepo;

  @override
  void initState() {
    authenticationBloc = AuthBloc(authRepo: authRepo);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthEvent, AuthState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthState state) {
            if (state is AuthAuthenticated) {
              return HomePage();
            }
            if (state is AuthUnauthenticated) {
              return LoginPage(authRepo: authRepo);
            }
            if (state is AuthLoading) {
              return SpinKitChasingDots(color: Colors.red, size: 50.0);
            }
            return SplashScreen();
          },
        ),
      ),
    );
  }
}

//class App extends StatelessWidget {
//  final AuthRepository authRepo;
//
//  App({Key key, @required this.authRepo}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: BlocBuilder<AuthBloc, AuthState>(
//        builder: (context, state) {
//          if(state is AuthAuthenticated) {
//            return HomePage();
//          }
//          if(state is AuthUnauthenticated) {
//            return LoginPage(authRepo: authRepo,);
//          }
//          if (state is AuthLoading) {
//            return SpinKitChasingDots(color: Colors.blue, size: 50.0);
//          }
//          return SplashScreen();
//        },
//      )
//    );
//  }
//}
