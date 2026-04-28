import 'dart:async'; 
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// MUST be at the top with the other imports!
import 'database_service_test.mocks.dart';

// -----------------------------------------------------------------------------
// DATABASE SERVICE CLASS
// -----------------------------------------------------------------------------

class DatabaseService {
  final SupabaseClient _client;

  DatabaseService(this._client);

  Future<void> uploadTransaction(Map<String, dynamic> data) async {
    final requiredFields = ['receiptNo', 'studentID', 'amount', 'amountWords', 'purpose', 'finance_FN', 'finance_MI', 'finance_LN', 'receiptDate'];
    for (var field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        throw ArgumentError('Missing required field: $field');
      }
    }

    if (data['receiptNo'] is! int || data['receiptNo'] <= 0) throw ArgumentError('receiptNo must be > 0');
    if (data['studentID'] is! int || data['studentID'] <= 0) throw ArgumentError('studentID must be > 0');
    if (data['amount'] is! int || data['amount'] <= 0) throw ArgumentError('amount must be > 0');

    if ((data['amountWords'] as String).trim().isEmpty) throw ArgumentError('amountWords cannot be empty');
    if ((data['purpose'] as String).trim().isEmpty) throw ArgumentError('purpose cannot be empty');
    if ((data['finance_FN'] as String).trim().isEmpty) throw ArgumentError('finance_FN cannot be empty');
    if ((data['finance_MI'] as String).trim().isEmpty) throw ArgumentError('finance_MI cannot be empty');
    if ((data['finance_LN'] as String).trim().isEmpty) throw ArgumentError('finance_LN cannot be empty');

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(data['receiptDate'])) {
      throw ArgumentError('receiptDate must be in YYYY-MM-DD format');
    }

    await _client.from('tracer.transaction').insert(data);
  }

  Future<void> uploadStudent(Map<String, dynamic> data) async {
    final requiredFields = ['studentID', 'stud_FN', 'stud_MI', 'stud_LN', 'course', 'yearLevel', 'stud_email'];
    for (var field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        throw ArgumentError('Missing required field: $field');
      }
    }

    if (data['studentID'] is! int || data['studentID'] <= 0) throw ArgumentError('studentID must be > 0');
    if (data['yearLevel'] is! int || data['yearLevel'] < 1 || data['yearLevel'] > 4) {
      throw ArgumentError('yearLevel must be between 1 and 4');
    }

    if ((data['stud_FN'] as String).trim().isEmpty) throw ArgumentError('stud_FN cannot be empty');
    if ((data['stud_MI'] as String).trim().isEmpty) throw ArgumentError('stud_MI cannot be empty');
    if ((data['stud_LN'] as String).trim().isEmpty) throw ArgumentError('stud_LN cannot be empty');
    if ((data['course'] as String).trim().isEmpty) throw ArgumentError('course cannot be empty');

    if (!(data['stud_email'] as String).contains('@')) {
      throw ArgumentError('stud_email must contain an "@" symbol');
    }

    await _client.from('tracer.students').insert(data);
  }
}

// -----------------------------------------------------------------------------
// FAKES
// -----------------------------------------------------------------------------

// This Fake replaces the TransformBuilder and uses the correct PostgrestFilterBuilder type.
class FakeFilterBuilder extends Fake implements PostgrestFilterBuilder<dynamic> {
  @override
  Future<R> then<R>(
    FutureOr<R> Function(dynamic value) onValue, {
    Function? onError,
  }) {
    // Simulates a successful database return
    return Future.value([]).then(onValue, onError: onError);
  }
}

// -----------------------------------------------------------------------------
// UNIT TESTS
// -----------------------------------------------------------------------------

// Generate the mocks by attaching the annotation directly to main()
@GenerateMocks([SupabaseClient, SupabaseQueryBuilder])
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late DatabaseService databaseService;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    databaseService = DatabaseService(mockSupabaseClient);

    // Return our FakeFilterBuilder when insert() is called.
    when(mockSupabaseClient.from(any)).thenAnswer((_) => mockQueryBuilder);
    when(mockQueryBuilder.insert(any)).thenAnswer((_) => FakeFilterBuilder());
  });

  group('Transaction Validation Tests', () {
    test('should upload successfully when transaction data is completely valid', () async {
      final validData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': 1600,
        'amountWords': "One Thousand and Six Hundred Pesos",
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "2024-08-15"
      };

      await databaseService.uploadTransaction(validData);

      verify(mockSupabaseClient.from('tracer.transaction')).called(1);
      verify(mockQueryBuilder.insert(validData)).called(1);
    });

    test('should reject transaction with zero or negative amount', () async {
      final invalidData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': -500,
        'amountWords': "Minus Five Hundred Pesos",
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "2024-08-15"
      };

      expect(
        () => databaseService.uploadTransaction(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'amount must be > 0')),
      );
      verifyNever(mockSupabaseClient.from(any)); 
    });

    test('should reject transaction with empty string fields', () async {
      final invalidData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': 1600,
        'amountWords': " ", 
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "2024-08-15"
      };

      expect(
        () => databaseService.uploadTransaction(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'amountWords cannot be empty')),
      );
    });

    test('should reject transaction with invalid date format', () async {
      final invalidData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': 1600,
        'amountWords': "One Thousand",
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "15/08/2024" 
      };

      expect(
        () => databaseService.uploadTransaction(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'receiptDate must be in YYYY-MM-DD format')),
      );
    });
  });

  group('Student Validation Tests', () {
    test('should upload successfully when student data is completely valid', () async {
      final validData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_MI': "X",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 3,
        'stud_email': "mharc.alex@gmail.com"
      };

      await databaseService.uploadStudent(validData);

      verify(mockSupabaseClient.from('tracer.students')).called(1);
      verify(mockQueryBuilder.insert(validData)).called(1);
    });

    test('should reject student missing required fields', () async {
      final invalidData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 3,
        'stud_email': "mharc.alex@gmail.com"
      };

      expect(
        () => databaseService.uploadStudent(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'Missing required field: stud_MI')),
      );
    });

    test('should reject student with year level out of bounds', () async {
      final invalidData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_MI': "X",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 5, 
        'stud_email': "mharc.alex@gmail.com"
      };

      expect(
        () => databaseService.uploadStudent(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'yearLevel must be between 1 and 4')),
      );
    });

    test('should reject student with invalid email format', () async {
      final invalidData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_MI': "X",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 3,
        'stud_email': "mharc.alex.gmail.com" 
      };

      expect(
        () => databaseService.uploadStudent(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'stud_email must contain an "@" symbol')),
      );
    });
  });
}