import 'dart:math';

/// List 的命名空间；集合操作返回浅拷贝，不修改原集合。
extension type AxcListSpace<T>(List<T> base) {
  /// 原集合的可增长浅拷贝。
  List<T> get copy => List<T>.of(base);

  /// 索引越界时返回 null。
  T? objectAt(int index) => isCrossing(index) ? null : base[index];

  /// 索引是否超出已有元素范围。
  bool isCrossing(int index) => index < 0 || index >= base.length;

  /// 第一项，空集合返回 null。
  T? get first => objectAt(0);

  /// 第二项。
  T? get second => objectAt(1);

  /// 第三项。
  T? get third => objectAt(2);

  /// 第四项。
  T? get fourth => objectAt(3);

  /// 第五项。
  T? get fifth => objectAt(4);

  /// 最后一项。
  T? get last => objectAt(base.length - 1);

  /// 倒数第二项。
  T? get lastSecond => objectAt(base.length - 2);

  /// 倒数第三项。
  T? get lastThird => objectAt(base.length - 3);

  /// 倒数第四项。
  T? get lastFourth => objectAt(base.length - 4);

  /// 倒数第五项。
  T? get lastFifth => objectAt(base.length - 5);

  /// 随机取一项；可注入随机源，空集合返回 null。
  T? random({Random? random}) =>
      base.isEmpty ? null : base[(random ?? Random()).nextInt(base.length)];

  /// 拼接元素，返回新集合。
  List<T> append(Iterable<T> values) => [...base, ...values];

  /// 插入元素；索引限制到 0 到集合长度之间。
  List<T> insert(T value, {required int at}) =>
      copy..insert(at.clamp(0, base.length), value);

  /// 删除指定位置；越界返回原集合的拷贝。
  List<T> remove({required int at}) {
    final result = copy;
    if (!isCrossing(at)) result.removeAt(at);
    return result;
  }

  /// 删除首个匹配项。
  List<T> removeFirst(bool Function(T) where) =>
      remove(at: base.indexWhere(where));

  /// 删除最后一个匹配项。
  List<T> removeLast(bool Function(T) where) =>
      remove(at: base.lastIndexWhere(where));

  /// 替换指定位置；越界返回原集合的拷贝。
  List<T> replace(T value, {required int at}) {
    final result = copy;
    if (!isCrossing(at)) result[at] = value;
    return result;
  }

  /// 移动元素；任一索引越界时返回原集合的拷贝。
  List<T> move({required int from, required int to}) {
    final result = copy;
    if (isCrossing(from) || isCrossing(to)) return result;
    result.insert(to, result.removeAt(from));
    return result;
  }

  /// 移动指定元素到末尾。
  List<T> moveToLast({required int from}) =>
      move(from: from, to: base.length - 1);

  /// 按 Swift 的 filter(by:) 约定排除匹配项；true 表示移除。
  List<T> filter({required bool Function(T) by}) =>
      base.where((value) => !by(value)).toList();

  /// 保留匹配项，对应 Dart 的 where 语义。
  List<T> where(bool Function(T) predicate) => base.where(predicate).toList();

  /// 查找匹配项，找不到返回 null；可从末尾查找。
  T? object({required bool Function(T) by, bool reversed = false}) {
    for (final value in reversed ? base.reversed : base) {
      if (by(value)) return value;
    }
    return null;
  }

  /// 首个匹配项的索引，找不到返回 null。
  int? index({required bool Function(T) of}) {
    final found = base.indexWhere(of);
    return found < 0 ? null : found;
  }

  /// 匹配项的数量。
  int count({required bool Function(T) where}) => base.where(where).length;

  /// 是否至少有一项匹配。
  bool isContent({required bool Function(T) by}) => base.any(by);

  /// 是否包含所有给定值；不比较重复次数。
  bool contains(Iterable<T> values) => values.every(base.contains);

  /// 按相等性稳定去重，保留首次出现顺序。
  List<T> removeRepeat() => base.toSet().toList();

  /// 每个重复值仅返回一次，按首次发现重复的顺序排列。
  List<T> duplicates() {
    final seen = <T>{};
    final repeated = <T>{};
    for (final value in base) {
      if (!seen.add(value)) repeated.add(value);
    }
    return repeated.toList();
  }

  /// 是否存在重复值。
  bool containsDuplicates() => base.toSet().length != base.length;

  /// 截取半开区间 [start, end)；越界抛出 RangeError。
  List<T> subArray({required int start, int? end}) => base.sublist(start, end);

  /// 从头部最多取 count 项；负数抛出 ArgumentError。
  List<T> prefix(int count) {
    RangeError.checkNotNegative(count, 'count');
    return base.take(count).toList();
  }

  /// 从尾部最多取 count 项；负数抛出 ArgumentError。
  List<T> suffix(int count) {
    RangeError.checkNotNegative(count, 'count');
    return base.skip(max(0, base.length - count)).toList();
  }

  /// 按正整数大小分块，最后一块可以不足。
  List<List<T>> chunked({required int by}) {
    if (by <= 0) throw ArgumentError.value(by, 'by', '分块大小必须大于零');
    return [
      for (var i = 0; i < base.length; i += by)
        base.sublist(i, min(i + by, base.length))
    ];
  }

  /// 倒序遍历，不修改集合。
  void forEachReversed(void Function(T) body) => base.reversed.forEach(body);

  /// 按索引和值遍历，不允许回调修改集合长度。
  void forEachEnumerated(void Function(int, T) body) {
    for (var i = 0; i < base.length; i++) {
      body(i, base[i]);
    }
  }

  /// 按给定字段稳定升序排序。
  List<T> sortByAscend<K extends Comparable<Object?>>(K Function(T) key) =>
      _sorted(key, false);

  /// 按给定字段稳定降序排序。
  List<T> sortByDescend<K extends Comparable<Object?>>(K Function(T) key) =>
      _sorted(key, true);
  List<T> _sorted<K extends Comparable<Object?>>(
      K Function(T) key, bool descending) {
    final entries = [
      for (var i = 0; i < base.length; i++)
        (index: i, value: base[i], key: key(base[i]))
    ];
    entries.sort((a, b) {
      final order =
          descending ? b.key.compareTo(a.key) : a.key.compareTo(b.key);
      return order == 0 ? a.index.compareTo(b.index) : order;
    });
    return [for (final entry in entries) entry.value];
  }
}

/// 为列表提供保留元素类型的唯一命名空间入口。
extension AxcListNamespace<T> on List<T> {
  /// 列表命名空间。
  AxcListSpace<T> get axc => AxcListSpace<T>(this);
}

/// 字符串列表的专用能力。
extension AxcStringListOperations on AxcListSpace<String> {
  /// 直接拼接所有字符串。
  String get jointString => base.join();

  /// 使用分隔符拼接所有字符串。
  String joint([String separator = '']) => base.join(separator);

  /// 去掉空字符串，空白字符串保留。
  List<String> filterEmpty() =>
      base.where((value) => value.isNotEmpty).toList();

  /// 按不区分大小写的字典顺序稳定排列。
  List<String> sortByLexicographical() =>
      sortByAscend((value) => value.toLowerCase());
}

/// 整数列表的专用能力。
extension AxcIntListOperations on AxcListSpace<int> {
  /// 返回整数总和，空集合返回 0。
  int sum() => base.fold(0, (sum, value) => sum + value);
}

/// 浮点列表的专用能力。
extension AxcDoubleListOperations on AxcListSpace<double> {
  /// 返回浮点总和，空集合返回 0.0。
  double sum() => base.fold(0.0, (sum, value) => sum + value);
}
