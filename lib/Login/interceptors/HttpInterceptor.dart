import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpInterceptor implements InterceptorContract {
	@override
	Future<RequestData> interceptRequest({RequestData data}) {
		try{
			data.headers["Content-Type"] = "application/json";
			data.headers["Authorization"] = new FlutterSecureStorage().read(key: 'church_jwt') as String;
		} catch (e) {
			print(e);
		}
		return Future.value(data);
	}

	@override
	Future<ResponseData> interceptResponse({ResponseData data}) async => data;
}