import 'package:dio/dio.dart';
import 'package:my_profile/models/more_info.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:my_profile/models/user_info.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MyAPI {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://myprofilebe-cbx3omuocq-uc.a.run.app',
    connectTimeout: const Duration(seconds: 120),
    sendTimeout: const Duration(seconds: 120),
  ));
  MyAPI() {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
  }
  Future<UserInfo> getUserInfo() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/user/thangpn0207',
      );
      return UserInfo.fromJson(response.data?["data"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MoreInfo>> getMoreInfo() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/info',
      );
      return MoreInfo.listFromJson(response.data?["data"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MyProject>> getProject() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/project',
      );
      return MyProject.listFromJson(response.data?["data"]);
    } catch (e) {
      rethrow;
    }
  }
}
