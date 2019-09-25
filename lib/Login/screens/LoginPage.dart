import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_login/Login/blocs/AuthBloc.dart';
import 'package:generic_login/Login/blocs/LoginBloc.dart';
import 'package:generic_login/Login/repos/AuthRepo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

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
    return BlocBuilder<LoginEvent, LoginState>(
        bloc: _loginBloc,
        builder: (
          BuildContext context,
          LoginState state,
        ) {
          if (state is LoginFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
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
                            child: Text('Hello',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                            child: Text('There',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding:
                                EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                            child: Text('.',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow)),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: 'PHONE NUMBER',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.yellow))),
                            ),
                            //password field
                            SizedBox(height: 20.0),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: 'PASSWORD',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.yellow))),
                              obscureText: true,
                            ),

                            //forgot password text
                            SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              child: InkWell(
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
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
                                  onPressed: state is! LoginLoading
                                      ? _onLoginButtonPressed
                                      : null,
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.0),
                            Container(
                              child: state is LoginLoading
                                  ? SpinKitChasingDots(
                                      color: Colors.yellow,
                                      size: 50.0,
                                    )
                                  : null,
                            )
                          ],
                        ))
                  ]));
        });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  _onLoginButtonPressed() {
    _loginBloc.dispatch(LoginBtnPressed(
      phoneNo: _phoneController.text,
      password: _passwordController.text,
    ));

    final snackbar = SnackBar(
      content: Text('phoneNo: ' +
          _phoneController.text +
          ', password: ' +
          _passwordController.text),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }
}
