import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:tracer/models/transaction.dart';
import 'package:tracer/utils/env.dart';

Future<Transaction> scanForm(Uint8List imageBytes, {http.Client ? client}) async {
  final httpClient = client ?? http.Client();
  final String base64Image = base64Encode(imageBytes);
  Transaction transaction = Transaction();

  final response = await httpClient.post(
    Uri.parse(Env.docAiEndpointUrl),
    headers: {
      "Content-Type": "application/json",
      "X-Tracer-Key": Env.docAiKey,
    },
    body: jsonEncode({"imageBase64": base64Image}),
  );

  try {
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      transaction.stuFirstName = result['data']['FIRST NAME'];
      transaction.stuMiddleInitial = result['data']['MIDDLE INITIAL'];
      transaction.stuLastName = result['data']['LAST NAME'];
      transaction.stuNum = result['data']['STUDENT NUMBER'];
      transaction.receiptNum = result['data']['No.'];
      transaction.transactMonth = result['data']['MONTH'];
      transaction.transactDay = result['data']['DAY'];
      transaction.transactYear = result['data']['YEAR'];
      transaction.transactAmount = result['data']['AMOUNT (PHP)'];
      transaction.transactPurpose = result['data']['TRANSACTION DESCRIPTION'];
      transaction.foFirstName = result['data']['FO FIRST NAME'];
      transaction.foMiddleInitial = result['data']['FO MIDDLE INITIAL'];
      transaction.foLastName = result['data']['FO LAST NAME'];
    }
    else {
      throw Exception('Server returned ${response.statusCode}: ${response.body}');
    }
  }
  finally {
    if (client == null) httpClient.close();
  }

  return transaction;
}
