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
      final response = await _client
      .from('transaction')
      .insert(transaction.toJson())
      .select()
      .single();

      return Transaction.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw DuplicateReceiptException();
      }

      throw Exception("Database Error: ${e.message}");
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
          .select()
          .eq('organization_id', orgId)
          .order('receiptdate', ascending: false);

      return (response as List)
          .map((item) => Transaction.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch records: $e");
    }
  }
}


// Custom exceptions
class DuplicateReceiptException implements Exception {}
