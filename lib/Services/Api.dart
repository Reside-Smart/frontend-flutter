import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class Api {
  static const String baseURL = "http://10.0.2.2:8000";
  static final dio = Dio(
    BaseOptions(
      baseUrl: "${baseURL}/api",
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 30),
    ),
  );

  static void initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          var token = await GetStorage().read('login_token');

          var headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
            'Connection': 'Keep-Alive',
            'Accept-Encoding': 'gzip, deflate, br',
          };

          request.headers.addAll(headers);

          print('${request.method} ${request.path}');
          print("${request.headers}");
          return handler.next(request);
        },
        onResponse: (response, handler) {
          print("${response.data}");

          return handler.next(response);
        },
        onError: (error, handler) {
          // print(error.response?.data);

          if (Get.isDialogOpen! == true) {
            Get.back();
          }
          print(error);

          if (error.response!.statusCode != 422) {
            AppDialog.showError(error.response!.data['message']!);
          }
          return handler.next(error);
        },
      ),
    );
  }
}
