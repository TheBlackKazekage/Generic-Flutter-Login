import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_login/Login/blocs/AuthBloc.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  	final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
			appBar: AppBar(
				title: Text('Home Page'),
			),
			body: (Container(
				child: Center(
					child: RaisedButton(
						child: Text('Logout'),
						onPressed: () {
							authBloc.dispatch(LoggedOut());
						},
					),
				),
			)),
		);
  }

}