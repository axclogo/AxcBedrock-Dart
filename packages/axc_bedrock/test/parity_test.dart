@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';
import 'package:axc_bedrock/axc_bedrock.dart';
import 'package:test/test.dart';

void main() {
  final fixture =
      jsonDecode(File('test/fixtures/parity.json').readAsStringSync())
          as Map<String, Object?>;
  Iterable<Map<String, Object?>> cases(String name) =>
      (fixture[name]! as List<Object?>).cast<Map<String, Object?>>();
  for (final entry in cases('stringPrefix').indexed) {
    test('Swift 对称：前缀 ${entry.$1}', () {
      final value = entry.$2;
      expect(
          (value['value']! as String).axc.keepPrefix(
              count: value['count']! as int,
              suffix: value['suffix']! as String),
          value['expected']);
    });
  }
  for (final entry in cases('stringSuffix').indexed) {
    test('Swift 对称：后缀 ${entry.$1}', () {
      final value = entry.$2;
      expect(
          (value['value']! as String)
              .axc
              .keepSuffix(count: value['count']! as int),
          value['expected']);
    });
  }
  for (final entry in cases('listObject').indexed) {
    test('Swift 对称：索引 ${entry.$1}', () {
      final value = entry.$2;
      expect(
          (value['values']! as List<Object?>)
              .cast<int>()
              .axc
              .objectAt(value['index']! as int),
          value['expected']);
    });
  }
  for (final entry in cases('listChunked').indexed) {
    test('Swift 对称：分块 ${entry.$1}', () {
      final value = entry.$2;
      expect(
          (value['values']! as List<Object?>)
              .cast<int>()
              .axc
              .chunked(by: value['size']! as int),
          value['expected']);
    });
  }
  for (final entry in cases('clamped').indexed) {
    test('Swift 对称：数值 ${entry.$1}', () {
      final value = entry.$2;
      final input = switch (value['kind']) {
        'nan' => double.nan,
        'infinity' => double.infinity,
        'negativeInfinity' => -double.infinity,
        _ => (value['value']! as num).toDouble(),
      };
      final result = input.axc.clamped(
          min: (value['min']! as num).toDouble(),
          max: (value['max']! as num).toDouble());
      expect(value['kind'] == 'nan' ? result.isNaN : result,
          value['kind'] == 'nan' ? true : value['expected']);
    });
  }
}
