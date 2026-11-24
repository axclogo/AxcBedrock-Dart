import 'dart:async';
import 'dart:typed_data';
import 'package:axc_bedrock/axc_bedrock.dart';
import 'package:test/test.dart';

class Host {}

Type typeOf<T>(T value) => T;

void main() {
  group('数值和区间', () {
    test('区间限制保留类型并处理 NaN', () {
      final integer = 12.axc.clamped(min: 0, max: 10);
      final decimal = 0.5.axc.clamped(min: 0.0, max: 1.0);
      expect(typeOf(integer), int);
      expect(typeOf(decimal), double);
      expect(integer, 10);
      expect(decimal, 0.5);
      expect((-2).axc.clamped(min: 0, max: 10), 0);
      expect(double.nan.axc.clamped(min: 0.0, max: 1.0).isNaN, isTrue);
      expect(double.infinity.axc.clamped(min: 0.0, max: 1.0), 1);
      expect((-double.infinity).axc.clamped(min: 0.0, max: 1.0), 0);
      expect(() => 1.axc.clamped(min: 2, max: 1), throwsArgumentError);
      expect(() => 1.0.axc.clamped(min: double.nan, max: 1.0),
          throwsArgumentError);
    });
    test('闭区间拒绝反向边界，包含两端', () {
      final range = AxcIntRange(1, 3);
      expect(range.contains(1), isTrue);
      expect(range.contains(3), isTrue);
      expect(range.contains(4), isFalse);
      expect(range.clamped(0), 1);
      expect(range, AxcIntRange(1, 3));
      expect(range.hashCode, AxcIntRange(1, 3).hashCode);
      expect(() => AxcIntRange(3, 1), throwsArgumentError);
      expect(() => AxcDoubleRange(double.nan, 1.0), throwsArgumentError);
      expect(AxcDoubleRange(0.0, 1.0).contains(double.nan), isFalse);
      expect(AxcDoubleRange(0.0, 1.0).clamped(double.nan).isNaN, isTrue);
      expect(2.axc.isInRange(range), isTrue);
    });
    test('舍入、角度、有限性和二进制转换', () {
      expect(1.235.axc.rounded(numPlaces: 2), closeTo(1.24, 1e-12));
      expect((-1.235).axc.rounded(numPlaces: 2), closeTo(-1.24, 1e-12));
      expect(1250.axc.rounded(numPlaces: -2), 1300);
      expect(double.nan.axc.rounded().isNaN, isTrue);
      expect(double.infinity.axc.asInt(), isNull);
      expect(1.9.axc.asInt(), 1);
      expect(() => 1.axc.rounded(numPlaces: 309), throwsRangeError);
      expect(180.axc.angleToRadian.axc.radianToAngle, closeTo(180, 1e-12));
      final bytes =
          ByteData.sublistView(1.5.axc.toBytes(endian: Endian.little));
      expect(bytes.getFloat64(0, Endian.little), 1.5);
      expect(1.axc.toBytes(), [0, 0, 0, 0, 0, 0, 0, 1]);
      expect(11.axc.ordinal(), '11th');
      expect(21.axc.ordinal(), '21st');
      expect((-22).axc.ordinal(), '-22nd');
    });
    test('布尔和固定时长', () {
      expect(true.axc.intValue, 1);
      expect(false.axc.toggled, isTrue);
      expect(AxcBool.createOptional(' YES '), isTrue);
      expect(AxcBool.createOptional(double.nan), isNull);
      expect(AxcBool.createOptional(Object()), isNull);
      expect(AxcBool.create('unknown', fallback: true), isTrue);
      expect(2.axc.day, const Duration(hours: 48));
      expect(1.axc.week, const Duration(days: 7));
      expect(const Duration(milliseconds: 1500).axc.seconds, 1.5);
    });
  });

  group('日期和 URI', () {
    test('月末、闰年和 UTC 日历加减', () {
      final date = DateTime.utc(2024, 2, 29, 12, 30);
      expect(date.axc.monthDayNum, 29);
      expect(date.axc.tomorrow, DateTime.utc(2024, 3, 1, 12, 30));
      expect(date.axc.yesterday, DateTime.utc(2024, 2, 28, 12, 30));
      expect(date.axc.tomorrow.isUtc, isTrue);
      expect(date.axc.isToday(now: DateTime.utc(2024, 2, 29)), isTrue);
      expect(date.axc.isYesterday(now: DateTime.utc(2024, 3, 1)), isTrue);
      expect(date.axc.isTomorrow(now: DateTime.utc(2024, 2, 28)), isTrue);
      expect(date.axc.intervalHours(date.subtract(const Duration(minutes: 90))),
          1.5);
      expect(DateTime.utc(2024, 3, 2).axc.isWeekend, isTrue);
    });
    test('格式化和严格解析', () {
      final date = DateTime.utc(2024, 2, 29);
      expect(date.axc.string(), '2024-02-29');
      expect(AxcDate.createOptional('2024-02-29'), date);
      expect(AxcDate.createOptional('2023-02-29'), isNull);
      expect(AxcDate.createOptional('not a date'), isNull);
      expect(date.axc.iso8601String.endsWith('Z'), isTrue);
    });
    test('URI 多值参数、编码、片段与空路径', () {
      final uri = Uri.parse('https://example.com/a/b?q=old&q=second#part');
      expect(uri.axc.parametersValue(forKey: 'q'), 'old');
      expect(uri.axc.parametersValue(forKey: 'missing'), isNull);
      final added = uri.axc.append(parameters: {'q': 'a&b +中'});
      expect(added.queryParametersAll['q'], ['old', 'second', 'a&b +中']);
      expect(added.fragment, 'part');
      expect(added.path, '/a/b');
      expect(uri.axc.removeAllPath().toString(),
          'https://example.com/?q=old&q=second#part');
      expect(uri.axc.append(parameters: {}), uri);
      expect(Uri.parse('/relative?flag').axc.parameters['flag'], '');
    });
  });

  group('关联对象和 once', () {
    test('关联类型、宿主和键隔离，单键移除', () {
      final a = Host();
      final b = Host();
      final key = AxcAssociationKey<int>();
      final other = AxcAssociationKey<int>();
      key.set(a, 1);
      other.set(a, 2);
      key.set(b, 3);
      final value = key.getObject(a);
      expect(typeOf(value), typeOf<int?>(null));
      expect(value, 1);
      key.remove(a);
      expect(key.getObject(a), isNull);
      expect(other.getObject(a), 2);
      expect(key.getObject(b), 3);
      key.set(b, null);
      expect(key.getObject(b), isNull);
    });
    test('弱值读取及无效宿主被明确拒绝', () {
      final host = Host();
      final value = Host();
      final key = AxcAssociationKey<Host>.weak();
      key.set(host, value);
      expect(identical(key.getObject(host), value), isTrue);
      expect(AxcWeakObj(value).object, same(value));
      key.remove(host);
      expect(key.getObject(host), isNull);
      for (final invalid in <Object>[1, 'text', true, (1, 2)]) {
        expect(() => key.getObject(invalid), throwsArgumentError);
      }
      expect(() => AxcAssociationKey<int>.weak().set(host, 1),
          throwsArgumentError);
    });
    test('同步执行、重入、独立实例', () {
      final once = AxcOnce();
      var count = 0;
      expect(once.run(() {
        count++;
        expect(once.run(() => count++), isFalse);
      }), isTrue);
      expect(count, 1);
      expect(once.run(() => count++), isFalse);
      expect(AxcOnce().run(() => count++), isTrue);
      expect(count, 2);
    });
    test('异常传播，失败后令牌仍已占用', () {
      final once = AxcOnce();
      expect(
          () => once.run(() => throw StateError('failure')), throwsStateError);
      expect(once.run(() {}), isFalse);
    });
    test('同一 isolate 中排队的多个调用只有一个执行', () async {
      final once = AxcOnce();
      var count = 0;
      final winners = await Future.wait(
          List.generate(100, (_) => Future(() => once.run(() => count++))));
      expect(count, 1);
      expect(winners.where((v) => v).length, 1);
    });
  });
}
