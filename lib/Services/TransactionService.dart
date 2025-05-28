import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/TransactionModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:dio/dio.dart' as dio;
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class TransactionService {
  Future<void> purchaseListing({required dio.FormData formData}) async {
    try {
      print('server: ${formData.fields}');

      final response = await Api.dio.post('/add-transaction', data: formData);
      print('response: ${response.data}');

      AppDialog.showSuccess(response.data['message']);
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
    }
  }

  Future<List<DateTime>> getBookedDays({required int listingId}) async {
    try {
      final response = await Api.dio.get('/booked-dates/$listingId');

      final List<dynamic> bookedDatesJson = response.data['bookedDates'] ?? [];

      List<DateTime> bookedDates =
          bookedDatesJson.map<DateTime>((dateString) {
            return DateTime.parse(dateString);
          }).toList();

      return bookedDates;
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
      return [];
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
      return [];
    }
  }

  Future<List<TransactionModel>> getUserTransactions() async {
    try {
      final response = await Api.dio.get('/transactions');

      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> getSingleTransaction(int id) async {
    try {
      final response = await Api.dio.get('/single-transaction/$id');
      print('Full Response Data: ${response.data}');
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch transaction');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsPaid({required int transactionId}) async {
    try {
      final response = await Api.dio.post('/mark-as-paid/$transactionId');

      if (response.statusCode == 200) {
        AppDialog.showSuccess(response.data['message']);
      } else {
        throw Exception('Failed to mark transaction as paid');
      }
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
    }
  }
}
