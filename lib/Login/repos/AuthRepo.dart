import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:generic_login/Login/providers/AuthApiProvider.dart';
import 'package:meta/meta.dart';

class AuthRepository {
	final authProvider = AuthApiProvider();

	Future<dynamic> login({@required String phoneNo, @required String password}) async {
		return await authProvider.loginUser({'phoneNo': phoneNo, 'password': password});
	}

	Future<void> saveToken({@required String token}) async {
		new FlutterSecureStorage().write(key: 'jwt', value: token);
	}

	Future<bool> isLoggedIn() async {
		bool status = false;
		try{
			var jwt = await new FlutterSecureStorage().read(key: 'jwt');

			if(jwt != null && jwt != ''){
				status = true;
			}
		}catch(error){
			return status;
		}

		return status;
	}

	Future<dynamic> registerUser({@required String phoneNo, @required String password}) async {
		return await authProvider.registerUser({'phoneNo': phoneNo, 'password': password});
	}

	Future<void> logOut() async {
		new FlutterSecureStorage().delete(key: 'church_jwt');
	}
}