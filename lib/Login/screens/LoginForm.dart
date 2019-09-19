import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:generic_login/Login/blocs/AuthBloc.dart';
import 'package:generic_login/Login/blocs/LoginBloc.dart';


class LoginForm extends StatefulWidget {
	final LoginBloc loginBloc;
	final AuthBloc authBloc;

	LoginForm({Key key, @required this.loginBloc, @required this.authBloc,}) : super(key: key);

	@override
	State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
	final _phoneController = TextEditingController();
	final _passwordController = TextEditingController();

	LoginBloc get _loginBloc => widget.loginBloc;

	@override
	Widget build(BuildContext context) {
		return BlocBuilder<LoginEvent, LoginState>(
			bloc: _loginBloc,
			builder: (BuildContext context, LoginState state,) {
				if (state is LoginFailure) {
					_onWidgetDidBuild(() {
						Scaffold.of(context).showSnackBar(
							SnackBar(
								content: Text('${state.error}'),
								backgroundColor: Colors.red,
							),
						);
					});
				}
				return Container(
						padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
						child: Column(
							children: <Widget>[

								//phone number field
								TextField(
									controller: _phoneController,
									keyboardType: TextInputType.phone,
									decoration: InputDecoration(
											labelText: 'PHONE NUMBER',
											labelStyle: TextStyle(fontFamily: 'Montserrat',
													fontWeight: FontWeight.bold,
													color: Colors.grey),
											focusedBorder: UnderlineInputBorder(
													borderSide: BorderSide(color: Colors.yellow))),
								),

								//password field
								SizedBox(height: 20.0),
								TextField(
									controller: _passwordController,
									decoration: InputDecoration(
											labelText: 'PASSWORD',
											labelStyle: TextStyle(fontFamily: 'Montserrat',
													fontWeight: FontWeight.bold,
													color: Colors.grey),
											focusedBorder: UnderlineInputBorder(
													borderSide: BorderSide(color: Colors.yellow))),
									obscureText: true,
								),

								//forgot password text
								SizedBox(height: 5.0),
								Container(
									alignment: Alignment(1.0, 0.0),
									padding: EdgeInsets.only(top: 15.0, left: 20.0),
									child: InkWell(
										child: Text('Forgot Password', style: TextStyle(
												color: Colors.yellow,
												fontWeight: FontWeight.bold,
												fontFamily: 'Montserrat',
												decoration: TextDecoration.underline),
										),
									),
								),

								//login button
								SizedBox(height: 40.0),
								Container(
									height: 40.0,
									child: Material(
										borderRadius: BorderRadius.circular(20.0),
										shadowColor: Colors.yellowAccent,
										color: Colors.yellow,
										elevation: 7.0,
										child: RaisedButton(
											onPressed:
												state is! LoginLoading ? _onLoginButtonPressed : null,
											child: Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),
									),
									),
								),
								SizedBox(height: 20.0),
								Container(
									child: state is LoginLoading ? SpinKitChasingDots(color: Colors.white, size: 50.0,) : null,
								)
							],
						)
				);
		});
	}

	void _onWidgetDidBuild(Function callback) {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			callback();
		});
	}

	_onLoginButtonPressed() {
		_loginBloc.dispatch(
				LoginBtnPressed(phoneNo: _phoneController.text, password: _passwordController.text,)
		);
	}
}
