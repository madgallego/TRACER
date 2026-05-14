import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';
import '../utils/env.dart';

class DbService {
  DbService._internal();

  late final SupabaseClient _client;

  static Future<DbService> initialize() async {
    await Supabase.initialize(
      anonKey: Env.supabaseKey,
      url: Env.supabaseUrl,
    );

    final service = DbService._internal();
    service._client = Supabase.instance.client;

    return service;
  }

  Future<Transaction> insertTransaction(Transaction transaction) async {
    try {
      // NOTE: Change to defensive, maybe raise unauthenticated error and
      // bring user back to login page
      final uuid = _client.auth.currentUser!.id;

      final orgID = await getFinanceOfficerOrgId();

      // Build json to be inserted to db
      Map<String, dynamic> insertJson = {
        'finance_id': uuid,
        'organization_id': orgID,
        ...transaction.toJson()
      };

      final response = await _client
      .from('transaction')
      .insert(insertJson)
      .select()
      .single()
      .timeout(Duration(seconds: 15));

      return Transaction.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw DuplicateReceiptException();
      }
      else if (e.code == '23503') {
        throw NonExistentStudentException();
      }
      else if (e.code == '504') {
        throw ServerTimeoutException();
      }

      throw Exception("Error Code: ${e.code}\nMessage: ${e.message}");
    } on TimeoutException {
      throw UploadTimeoutException();
    }
  }

  Future<String?> getFinanceOfficerOrgId() async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null) return null;

    final response = await _client
        .from('finance_officers')
        .select('organization_id')
        .eq('user_id', userId)
        .maybeSingle();

    return response?['organization_id'] as String?;
  }

  Future<List<Transaction>> fetchTransactions(String orgId) async {
    try {
      final response = await _client
          .from('transaction')
          .select('''
            *,
            students_for_functions(stud_fn, stud_mi, stud_ln, yearlevel, bloc),
            uploader:finance_officers(
              uploaderDetails:students_for_functions(stud_fn, stud_mi, stud_ln)
            )
          ''')
          .eq('organization_id', orgId)
          .order('receiptdate', ascending: false);

      print('RAW DATABASE RESPONSE: $response');

      return (response as List)
          .map((item) => Transaction.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch records: $e");
    }
  }
}


// Custom exceptions
class DuplicateReceiptException implements Exception {
  final String message;
  const DuplicateReceiptException([
    this.message = 'The receipt number of the transaction already exists on the database',
  ]);
}

class NonExistentStudentException implements Exception {
  final String message;
  const NonExistentStudentException([
    this.message = 'The student id does not belong to a valid student',
  ]);
}

class UploadTimeoutException implements Exception {
 final String message;
 const UploadTimeoutException ([
  this.message = 'Upload request timed out',
 ]);
}

class ServerTimeoutException implements Exception {
 final String message;
 const ServerTimeoutException ([
  this.message = 'Server timed out while handling the request',
 ]);
}
