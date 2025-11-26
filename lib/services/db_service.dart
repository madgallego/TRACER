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

  Future<List<Map<String, dynamic>>> insertTransaction(Transaction transaction) async {
    final response = await _client.from('transaction').insert(
      {
        "receiptno": transaction.receiptNum,
        "studentid": transaction.stuNum,
        "amount": transaction.transactAmount,
        "amountwords": transaction.transactAmountWords,
        "purpose": transaction.transactPurpose,
        "finance_fn": transaction.foFirstName,
        "finance_mi": transaction.foMiddleInitial,
        "finance_ln": transaction.foLastName,
        "receipt_date": "${transaction.transactYear}-${transaction.transactDay}-${transaction.transactMonth}",
      }
    ).select();

    return response;
  }


}
