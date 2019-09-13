import 'package:equatable/equatable.dart';
import 'package:generic_login/Login/repos/AuthRepo.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

abstract class AuthState extends Equatable {}

class AuthUninitialized extends AuthState{
	@override
  String toString() => 'AuthUninitialized';
}

class AuthUnauthenticated extends AuthState{
	@override
	String toString() => 'AuthUnauthenticated';
}

class AuthAuthenticated extends AuthState{
	@override
	String toString() => 'AuthAuthenticated';
}

class AuthLoading extends AuthState{
	@override
	String toString() => 'AuthLoading';
}

abstract class AuthEvent extends Equatable{
	AuthEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthEvent{
	@override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthEvent{
	final String token;

	LoggedIn({@required this.token}) : super([token]);

	@override
	String toString() => 'LoggedIn';
}

class LoggedOut extends AuthEvent{
	@override
	String toString() => 'LoggedOut';
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
	final AuthRepository authRepo;

	AuthBloc({@required this.authRepo}): assert(authRepo != null);

	@override
	AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthState currentState, AuthEvent event) async*{
    if(event is AppStarted){
    	final bool status = await authRepo.isLoggedIn();
    	if(status) {
    		yield AuthAuthenticated();
			}else{
				yield AuthUnauthenticated();
			}
		}

		if(event is LoggedIn){
			yield AuthLoading();
			await authRepo.saveToken(token: event.token);
			yield AuthAuthenticated();
		}

		if(event is LoggedOut){
			yield AuthLoading();
			await authRepo.logOut();
			yield AuthUnauthenticated();
		}
  }
}