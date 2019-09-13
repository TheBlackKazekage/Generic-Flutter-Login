import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_login/Login/blocs/AuthBloc.dart';
import 'package:generic_login/Login/blocs/LoginBloc.dart';
import 'package:generic_login/Login/repos/AuthRepo.dart';

import 'LoginForm.dart';

class LoginPage extends StatefulWidget {
	final AuthRepository authRepo;

	LoginPage({Key key, @required this.authRepo})
			: assert(authRepo != null),
				super(key: key);

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	LoginBloc _loginBloc;
	AuthBloc _authBloc;

	AuthRepository get _authRepo => widget.authRepo;

	@override
	void initState() {
		_authBloc = BlocProvider.of<AuthBloc>(context);
		_loginBloc = LoginBloc(
			authRepo: _authRepo,
			authBloc: _authBloc,
		);
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			resizeToAvoidBottomPadding: false,
			body: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					Container(
						child: Stack(
							children: <Widget>[
								Container(
									padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
									child: Text('Hello', style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
								),
								Container(
									padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
									child: Text('There', style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
								),
								Container(
									padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
									child: Text('.', style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.yellow)),
								)
							],
						),
					),
					Container(
							padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
							child: Column(
								children: <Widget>[
									LoginForm(
										authBloc: _authBloc,
										loginBloc: _loginBloc
									)
								],
							)
					),
				],
			)
		);
	}

	@override
	void dispose() {
		_loginBloc.dispose();
		super.dispose();
	}
}