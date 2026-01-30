import 'package:dio/dio.dart';

class TicketService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api-kamu.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>?> fetchTicket(String code) async {
    try {
      final response = await _dio.get(
        '/ticket',
        queryParameters: {
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        return response.data; // dio auto decode JSON
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
    }

    return null;
  }
}
