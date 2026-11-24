import 'dart:math';
import 'package:axc_bedrock/axc_bedrock.dart';
import 'package:test/test.dart';

Type typeOf<T>(T value) => T;

void main() {
  group('列表类型和边界', () {
    test('入口保留 int 可选返回类型', () {
      final value = <int>[1, 2].axc.objectAt(0);
      expect(typeOf(value), typeOf<int?>(null));
      expect(value, 1);
    });
    test('空值、越界及快捷访问', () {
      expect(<int>[].axc.first, isNull);
      expect(<int>[].axc.last, isNull);
      expect([1, 2].axc.objectAt(-1), isNull);
      expect([1, 2].axc.objectAt(2), isNull);
      expect([1, 2].axc.second, 2);
      expect([1, 2].axc.lastSecond, 1);
      expect([1, 2].axc.third, isNull);
      expect([1].axc.isCrossing(1), isTrue);
      expect([1].axc.random(random: Random(1)), 1);
      expect(<int>[].axc.random(), isNull);
    });
    test('操作不修改原集合，支持不可修改的宿主', () {
      final original = List<int>.unmodifiable([1, 2, 3]);
      expect(original.axc.append([4]), [1, 2, 3, 4]);
      expect(original.axc.insert(0, at: -3), [0, 1, 2, 3]);
      expect(original.axc.insert(4, at: 99), [1, 2, 3, 4]);
      expect(original.axc.remove(at: -1), original);
      expect(original.axc.remove(at: 1), [1, 3]);
      expect(original.axc.replace(9, at: 1), [1, 9, 3]);
      expect(original.axc.replace(9, at: 99), original);
      expect(original.axc.move(from: 0, to: 2), [2, 3, 1]);
      expect(original.axc.move(from: 2, to: 0), [3, 1, 2]);
      expect(original.axc.move(from: -1, to: 0), original);
      expect(original.axc.moveToLast(from: 1), [1, 3, 2]);
      final copy = original.axc.copy..add(4);
      expect(copy, [1, 2, 3, 4]);
      expect(original, [1, 2, 3]);
    });
    test('保留和排除是明确的不同 API', () {
      final list = [1, 2, 3, 4];
      expect(list.axc.filter(by: (v) => v.isEven), [1, 3]);
      expect(list.axc.where((v) => v.isEven), [2, 4]);
      expect(list.axc.object(by: (v) => v.isEven), 2);
      expect(list.axc.object(by: (v) => v.isEven, reversed: true), 4);
      expect(list.axc.index(of: (v) => v == 9), isNull);
      expect(list.axc.index(of: (v) => v == 3), 2);
      expect(list.axc.count(where: (v) => v.isEven), 2);
      expect(list.axc.isContent(by: (v) => v == 2), isTrue);
      expect(list.axc.removeFirst((v) => v.isEven), [1, 3, 4]);
      expect(list.axc.removeLast((v) => v.isEven), [1, 2, 3]);
    });
    test('重复元素、null 和顺序', () {
      final list = <int?>[null, 2, 1, 2, null, 1];
      expect(list.axc.duplicates(), [2, null, 1]);
      expect(list.axc.removeRepeat(), [null, 2, 1]);
      expect(list.axc.containsDuplicates(), isTrue);
      expect(list.axc.contains([null, 1]), isTrue);
      expect(list.axc.contains([3]), isFalse);
    });
    test('切片、分块和负数', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.axc.prefix(99), list);
      expect(list.axc.suffix(2), [4, 5]);
      expect(list.axc.suffix(0), isEmpty);
      expect(list.axc.chunked(by: 2), [
        [1, 2],
        [3, 4],
        [5]
      ]);
      expect(<int>[].axc.chunked(by: 2), isEmpty);
      expect(() => list.axc.chunked(by: 0), throwsArgumentError);
      expect(() => list.axc.prefix(-1), throwsArgumentError);
      expect(() => list.axc.suffix(-1), throwsArgumentError);
      expect(list.axc.subArray(start: 1, end: 3), [2, 3]);
      expect(() => list.axc.subArray(start: -1), throwsRangeError);
    });
    test('排序稳定并保留复杂元素类型', () {
      final list = [(id: 'a', rank: 2), (id: 'b', rank: 1), (id: 'c', rank: 2)];
      final sorted = list.axc.sortByAscend((v) => v.rank);
      expect(sorted.map((v) => v.id), ['b', 'a', 'c']);
      expect(list.axc.sortByDescend((v) => v.rank).map((v) => v.id),
          ['a', 'c', 'b']);
      expect(list.first.id, 'a');
    });
    test('专用集合扩展保留结果类型', () {
      final integer = [1, 2, 3].axc.sum();
      final decimal = [1.5, 2.5].axc.sum();
      expect(typeOf(integer), int);
      expect(typeOf(decimal), double);
      expect(integer, 6);
      expect(decimal, 4.0);
      expect(<int>[].axc.sum(), 0);
      expect(['', ' ', 'a'].axc.filterEmpty(), [' ', 'a']);
      expect(['a', 'b'].axc.joint('-'), 'a-b');
      expect(['b', 'A', 'a'].axc.sortByLexicographical(), ['A', 'a', 'b']);
    });
    test('遍历的方向和索引', () {
      final values = <int>[];
      [1, 2].axc.forEachReversed(values.add);
      expect(values, [2, 1]);
      final pairs = <(int, int)>[];
      [4, 5].axc.forEachEnumerated((i, v) => pairs.add((i, v)));
      expect(pairs, [(0, 4), (1, 5)]);
    });
  });

  group('字典', () {
    test('泛型、空值和键存在性', () {
      final map = <String, int?>{'a': 1, 'b': null};
      final value = map.axc.valueFor('a');
      expect(typeOf(value), typeOf<int?>(null));
      expect(map.axc.hasKey('b'), isTrue);
      expect(map.axc.hasKey('c'), isFalse);
      expect(map.axc.valueFor('b'), isNull);
      final filtered = map.axc.filter((k, v) => v != null);
      expect(typeOf(filtered), typeOf(<String, int?>{}));
      expect(filtered, {'a': 1});
    });
    test('合并、计数和大小写键冲突', () {
      final map = {'A': 1, 'a': 2, 'B': 3};
      expect(map.axc.lowercaseAllKeys(), {'a': 2, 'b': 3});
      expect(map.axc.append({'A': 9}), {'A': 9, 'a': 2, 'B': 3});
      expect(map['A'], 1);
      expect(map.axc.count(), 3);
      expect(map.axc.count((entry) => entry.value > 1), 2);
      expect(map.axc.removeRandomKey(random: Random(1)).length, 2);
      expect(<String, int>{}.axc.random(), isNull);
      expect(<String, int>{}.axc.removeRandomKey(), isEmpty);
    });
  });
}
