import 'package:flutter_test/flutter_test.dart';
import 'package:qr_attend/register_number_parser.dart';

void main() {
  group('RegisterNumberParser', () {
    test('accepts a plain register number', () {
      final RegisterNumberParseResult result =
          RegisterNumberParser.parse('2026123456');

      expect(result.isSuccess, isTrue);
      expect(result.registerNumber, '2026123456');
    });

    test('extracts a labeled register number', () {
      final RegisterNumberParseResult result =
          RegisterNumberParser.parse('Register Number: 2026123456');

      expect(result.registerNumber, '2026123456');
    });

    test('extracts register_number from JSON', () {
      final RegisterNumberParseResult result = RegisterNumberParser.parse(
        '{"register_number":"2026123456"}',
      );

      expect(result.registerNumber, '2026123456');
    });

    test('extracts roll_no from JSON', () {
      final RegisterNumberParseResult result = RegisterNumberParser.parse(
        '{"roll_no":"2026123456"}',
      );

      expect(result.registerNumber, '2026123456');
    });

    test('extracts a register number from a nested JSON field', () {
      final RegisterNumberParseResult result = RegisterNumberParser.parse(
        '{"student":{"Register Number":"2026123456"}}',
      );

      expect(result.registerNumber, '2026123456');
    });

    test('does not treat an unrelated URL as a register number', () {
      final RegisterNumberParseResult result =
          RegisterNumberParser.parse('https://college.example.edu/student');

      expect(result.isSuccess, isFalse);
      expect(result.failure, RegisterNumberFailure.notFound);
    });

    test('rejects a malformed register number in a recognized JSON field', () {
      final RegisterNumberParseResult result = RegisterNumberParser.parse(
        '{"register_number":"not-a-number"}',
      );

      expect(result.failure, RegisterNumberFailure.invalidFormat);
    });

    test('reports malformed JSON separately', () {
      final RegisterNumberParseResult result =
          RegisterNumberParser.parse('{"register_number":');

      expect(result.failure, RegisterNumberFailure.invalidFormat);
    });

    test('reports an empty payload as unreadable', () {
      final RegisterNumberParseResult result = RegisterNumberParser.parse(' ');

      expect(result.failure, RegisterNumberFailure.unreadable);
    });
  });
}
