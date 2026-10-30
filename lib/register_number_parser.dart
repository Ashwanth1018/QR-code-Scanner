import 'dart:convert';

enum RegisterNumberFailure {
  unreadable,
  invalidFormat,
  notFound,
}

class RegisterNumberParseResult {
  const RegisterNumberParseResult.success(this.registerNumber)
      : failure = null;

  const RegisterNumberParseResult.failure(this.failure) : registerNumber = null;

  final String? registerNumber;
  final RegisterNumberFailure? failure;

  bool get isSuccess => registerNumber != null;
}

abstract final class RegisterNumberParser {
  // Adjust these accepted keys and the candidate pattern to match the college ID.
  static const Set<String> _fieldNames = {
    'registernumber',
    'registerno',
    'registrationnumber',
    'registrationno',
    'rollnumber',
    'rollno',
    'regno',
  };

  static final RegExp _candidatePattern =
      RegExp(r'^[A-Za-z0-9][A-Za-z0-9/-]{4,19}$');
  static final RegExp _labelPattern = RegExp(
    r'(?:register(?:\s*(?:number|no\.?))?|roll(?:\s*(?:number|no\.?))?|reg(?:istration)?\s*(?:number|no\.?))\s*[:=#-]\s*([A-Za-z0-9][A-Za-z0-9/-]{4,19})(?![A-Za-z0-9/-])',
    caseSensitive: false,
  );

  static RegisterNumberParseResult parse(String? payload) {
    final String value = payload?.trim() ?? '';
    if (value.isEmpty) {
      return const RegisterNumberParseResult.failure(
        RegisterNumberFailure.unreadable,
      );
    }

    final bool looksLikeJson = value.startsWith('{') || value.startsWith('[');
    if (looksLikeJson) {
      Object? decoded;
      try {
        decoded = jsonDecode(value);
      } on FormatException {
        return const RegisterNumberParseResult.failure(
          RegisterNumberFailure.invalidFormat,
        );
      }

      final String? jsonValue = _findRegisterNumber(decoded);
      if (jsonValue != null) {
        return _resultForCandidate(jsonValue);
      }
      if (_containsRegisterField(decoded)) {
        return const RegisterNumberParseResult.failure(
          RegisterNumberFailure.invalidFormat,
        );
      }
    }

    final RegExpMatch? labelMatch = _labelPattern.firstMatch(value);
    if (labelMatch != null) {
      return _resultForCandidate(labelMatch.group(1));
    }

    if (_isRegisterNumber(value)) {
      return RegisterNumberParseResult.success(value);
    }

    return const RegisterNumberParseResult.failure(
      RegisterNumberFailure.notFound,
    );
  }

  static String? _findRegisterNumber(Object? value) {
    if (value is Map) {
      for (final MapEntry<Object?, Object?> entry in value.entries) {
        final String key = entry.key.toString().toLowerCase().replaceAll(
              RegExp(r'[^a-z0-9]'),
              '',
            );
        if (_fieldNames.contains(key)) {
          final String? candidate = _asCandidate(entry.value);
          if (candidate != null) {
            return candidate;
          }
        }
      }

      for (final Object? nestedValue in value.values) {
        final String? candidate = _findRegisterNumber(nestedValue);
        if (candidate != null) {
          return candidate;
        }
      }
    } else if (value is List) {
      for (final Object? item in value) {
        final String? candidate = _findRegisterNumber(item);
        if (candidate != null) {
          return candidate;
        }
      }
    }
    return null;
  }

  static bool _containsRegisterField(Object? value) {
    if (value is Map) {
      for (final MapEntry<Object?, Object?> entry in value.entries) {
        final String key = entry.key.toString().toLowerCase().replaceAll(
              RegExp(r'[^a-z0-9]'),
              '',
            );
        if (_fieldNames.contains(key) ||
            _containsRegisterField(entry.value)) {
          return true;
        }
      }
    } else if (value is List) {
      return value.any(_containsRegisterField);
    }
    return false;
  }

  static String? _asCandidate(Object? value) {
    if (value is String) {
      return value.trim();
    }
    if (value is num) {
      return value.toString();
    }
    return null;
  }

  static RegisterNumberParseResult _resultForCandidate(String? value) {
    if (value != null && _isRegisterNumber(value)) {
      return RegisterNumberParseResult.success(value);
    }
    return const RegisterNumberParseResult.failure(
      RegisterNumberFailure.invalidFormat,
    );
  }

  static bool _isRegisterNumber(String value) =>
      _candidatePattern.hasMatch(value) && RegExp(r'\d').hasMatch(value);
}
