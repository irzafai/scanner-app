import 'dart:developer';

import 'package:dio/dio.dart';

class HomeServices {
  static final _baseUrl = 'https://event-ticketing-ruddy.vercel.app/api';

  final _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<List> getTickets() async {
    final response = await _dio.get('/tickets');
    final List<dynamic> data = response.data;
    log('Fetched tickets: $data');
    return data;
  }

   Future<void> deleteTicket(String id) async {
    await _dio.delete('/tickets', queryParameters: {'id': id});
  }

   Future<void> addTicket(String name) async {
    await _dio.post('/tickets', data: {'name': name});
  }

}
