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


//for generating mocks
@GenerateMocks([SupabaseClient, SupabaseQueryBuilder])
import 'database_service_test.mocks.dart';


//main unit testing for database
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late DatabaseService databaseService;

  setUp(() {
    // Arrange: Initialize mocks and service before each test
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    databaseService = DatabaseService(mockSupabaseClient);

    // Setup mock behavior: when client.from() is called, return the query builder.
    // When insert() is called on the builder, return a future (simulate success).
    when(mockSupabaseClient.from(any)).thenReturn(mockQueryBuilder);
    when(mockQueryBuilder.insert(any)).thenAnswer((_) async => []);
  });

  group('Transaction Validation Tests', () {
    test('should upload successfully when transaction data is completely valid', () async {
      // Arrange
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

      // Act
      await databaseService.uploadTransaction(validData);

      // Assert
      verify(mockSupabaseClient.from('tracer.transaction')).called(1);
      verify(mockQueryBuilder.insert(validData)).called(1);
    });

    test('should reject transaction with zero or negative amount', () async {
      // Arrange
      final invalidData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': -500, // Invalid
        'amountWords': "Minus Five Hundred Pesos",
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "2024-08-15"
      };

      // Act & Assert
      expect(
        () => databaseService.uploadTransaction(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'amount must be > 0')),
      );
      verifyNever(mockSupabaseClient.from(any)); // Ensure DB is not called
    });

    test('should reject transaction with empty string fields', () async {
      // Arrange
      final invalidData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': 1600,
        'amountWords': " ", // Invalid: empty/whitespace
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "2024-08-15"
      };

      // Act & Assert
      expect(
        () => databaseService.uploadTransaction(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'amountWords cannot be empty')),
      );
    });

    test('should reject transaction with invalid date format', () async {
      // Arrange
      final invalidData = {
        'receiptNo': 500000090,
        'studentID': 2023947212217,
        'amount': 1600,
        'amountWords': "One Thousand",
        'purpose': "Merch bundle",
        'finance_FN': "Shana",
        'finance_MI': "K",
        'finance_LN': "Urakot",
        'receiptDate': "15/08/2024" // Invalid format
      };

      // Act & Assert
      expect(
        () => databaseService.uploadTransaction(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'receiptDate must be in YYYY-MM-DD format')),
      );
    });
  });

  group('Student Validation Tests', () {
    test('should upload successfully when student data is completely valid', () async {
      // Arrange
      final validData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_MI': "X",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 3,
        'stud_email': "mharc.alex@gmail.com"
      };

      // Act
      await databaseService.uploadStudent(validData);

      // Assert
      verify(mockSupabaseClient.from('tracer.students')).called(1);
      verify(mockQueryBuilder.insert(validData)).called(1);
    });

    test('should reject student missing required fields', () async {
      // Arrange
      final invalidData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        // 'stud_MI' is missing
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 3,
        'stud_email': "mharc.alex@gmail.com"
      };

      // Act & Assert
      expect(
        () => databaseService.uploadStudent(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'Missing required field: stud_MI')),
      );
    });

    test('should reject student with year level out of bounds', () async {
      // Arrange
      final invalidData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_MI': "X",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 5, // Invalid: > 4
        'stud_email': "mharc.alex@gmail.com"
      };

      // Act & Assert
      expect(
        () => databaseService.uploadStudent(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'yearLevel must be between 1 and 4')),
      );
    });

    test('should reject student with invalid email format', () async {
      // Arrange
      final invalidData = {
        'studentID': 2099969082936,
        'stud_FN': "Lex",
        'stud_MI': "X",
        'stud_LN': "Test",
        'course': "BSCS",
        'yearLevel': 3,
        'stud_email': "mharc.alex.gmail.com" // Invalid: missing @
      };

      // Act & Assert
      expect(
        () => databaseService.uploadStudent(invalidData),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'stud_email must contain an "@" symbol')),
      );
    });
  });
}