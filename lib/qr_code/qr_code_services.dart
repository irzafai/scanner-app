import 'package:dio/dio.dart';

class QrCodeServices {
  static final _baseUrl = 'https://event-ticketing-ruddy.vercel.app/api';

  final _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<bool> scanTicket(String qrData) async {
    final response = await _dio.post('/scan', data: {'qr_data': qrData});

    final data = response.data;
    final status = data['status'] ?? data['message'] ?? null;

    return status != null;
  }
}
