import 'dart:convert';

import 'package:generic_login/Login/common/constants.dart';
import 'package:generic_login/Login/interceptors/HttpInterceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AuthApiProvider {
	final _url = apiUrl + '/auth';
	Client client = HttpClientWithInterceptor.build(interceptors: [HttpInterceptor()]);

	Future<dynamic> loginUser(data) async {
		Response response = await client.post(_url + '/login', body: data);
		return json.decode(response.body);
	}

	Future<dynamic> registerUser(data) async {
		Response response = await client.post(_url + '/register', body: data);
		return json.decode(response.body);
	}
}