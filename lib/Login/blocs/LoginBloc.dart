import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generic_login/Login/blocs/AuthBloc.dart';
import 'package:generic_login/Login/repos/AuthRepo.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable{
	LoginState([List props = const[]]) : super(props);
}

class LoginInitial extends LoginState{
	@override
  String toString() => 'LoginIntial';
}

class LoginLoading extends LoginState{
	@override
	String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState{
	final String error;

	LoginFailure(this.error): super([error]);

	@override
	String toString() => 'LoginFailure {error: $error}';
}

abstract class LoginEvent extends Equatable {
	LoginEvent([List props = const[]]) : super(props);
}

class LoginBtnPressed extends LoginEvent{
	final String phoneNo;
	final String password;

  LoginBtnPressed({@required this.phoneNo, @required this.password}): super([phoneNo, password]);

  @override
  String toString() => 'LoginPressed {phoneNo: $phoneNo, password: $password}';
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
	final AuthRepository authRepo;
	final AuthBloc authBloc;

	LoginBloc({@required this.authRepo, @required this.authBloc}) : assert(authRepo != null), assert(authBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
  	if(event is LoginBtnPressed){
  		yield LoginLoading();

  		try{
  			final response = await authRepo.login(phoneNo: event.phoneNo, password: event.password);

  			if(response['success']){
  				authBloc.dispatch(LoggedIn(token: response['data']));
  				yield LoginInitial();
				}else {
  				yield LoginFailure(response['message'] as String);
				}
			}catch(error) {
  			yield LoginFailure(error.toString());
			}
		}
  }

}


