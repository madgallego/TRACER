import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:tracer/services/doc_ai_service.dart';

// Generate a mock client
@GenerateMocks([http.Client])
import 'scan_form_test.mocks.dart';

void main() {
  late MockClient mockClient;
  final fakeBytes = Uint8List.fromList([1, 2, 3, 4]);

  setUp(() {
    mockClient = MockClient();
  });

  group('scanForm Tests', () {

    test('returns data when the cloud call is successful (200)', () async {
      // Setup the mock to return a success response
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({
                  "success": true,
                  "data": {
                    "First name": "John Doe",
                    "Amount (Php)": "500",
                  }
                }), 200));

      // Call the function (passing the mock client)
      final result = await scanForm(fakeBytes, client: mockClient);

      // Verify the results
      expect(result.stuFirstName, 'John Doe');
      expect(result.transactAmount, '500');
    });

    test('throws an exception when the server returns a 500 error', () async {
      // Arrange
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));

      // Act and assert
      expect(() => scanForm(fakeBytes, client: mockClient), throwsException);
    });
  });
}
