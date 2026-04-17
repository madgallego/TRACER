import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _client;

  DatabaseService(this._client);

  /// Uploads a transaction to tracer.transaction after validating the data.
  Future<void> uploadTransaction(Map<String, dynamic> data) async {
    // Required fields check
    final requiredFields = ['receiptNo', 'studentID', 'amount', 'amountWords', 'purpose', 'finance_FN', 'finance_MI', 'finance_LN', 'receiptDate'];
    for (var field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        throw ArgumentError('Missing required field: $field');
      }
    }

    // Number validation
    if (data['receiptNo'] is! int || data['receiptNo'] <= 0) throw ArgumentError('receiptNo must be > 0');
    if (data['studentID'] is! int || data['studentID'] <= 0) throw ArgumentError('studentID must be > 0');
    if (data['amount'] is! int || data['amount'] <= 0) throw ArgumentError('amount must be > 0');

    // String validation
    if ((data['amountWords'] as String).trim().isEmpty) throw ArgumentError('amountWords cannot be empty');
    if ((data['purpose'] as String).trim().isEmpty) throw ArgumentError('purpose cannot be empty');
    if ((data['finance_FN'] as String).trim().isEmpty) throw ArgumentError('finance_FN cannot be empty');
    if ((data['finance_MI'] as String).trim().isEmpty) throw ArgumentError('finance_MI cannot be empty');
    if ((data['finance_LN'] as String).trim().isEmpty) throw ArgumentError('finance_LN cannot be empty');

    // Date validation (YYYY-MM-DD)
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(data['receiptDate'])) {
      throw ArgumentError('receiptDate must be in YYYY-MM-DD format');
    }

    // Proceed to database insertion
    await _client.from('tracer.transaction').insert(data);
  }

  /// Uploads a student to tracer.students after validating the data.
  Future<void> uploadStudent(Map<String, dynamic> data) async {
    // Required fields check
    final requiredFields = ['studentID', 'stud_FN', 'stud_MI', 'stud_LN', 'course', 'yearLevel', 'stud_email'];
    for (var field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        throw ArgumentError('Missing required field: $field');
      }
    }

    // Number validation
    if (data['studentID'] is! int || data['studentID'] <= 0) throw ArgumentError('studentID must be > 0');
    if (data['yearLevel'] is! int || data['yearLevel'] < 1 || data['yearLevel'] > 4) {
      throw ArgumentError('yearLevel must be between 1 and 4');
    }

    // String validation
    if ((data['stud_FN'] as String).trim().isEmpty) throw ArgumentError('stud_FN cannot be empty');
    if ((data['stud_MI'] as String).trim().isEmpty) throw ArgumentError('stud_MI cannot be empty');
    if ((data['stud_LN'] as String).trim().isEmpty) throw ArgumentError('stud_LN cannot be empty');
    if ((data['course'] as String).trim().isEmpty) throw ArgumentError('course cannot be empty');

    // Email validation
    if (!(data['stud_email'] as String).contains('@')) {
      throw ArgumentError('stud_email must contain an "@" symbol');
    }

    // Proceed to database insertion
    await _client.from('tracer.students').insert(data);
  }
}