/// 起点和终点均包含的有序区间；按 compareTo 排序，不自动交换反向边界。
/// 数值区间因此区分 -0.0 与 0.0；仅需数值大小限制时使用 number.axc.clamped。
final class AxcRange<T extends Comparable<Object?>> {
  /// 创建闭区间；反向边界或 NaN 会抛出 ArgumentError。
  AxcRange(this.start, this.endInclusive) {
    if (_isNaN(start) ||
        _isNaN(endInclusive) ||
        start.compareTo(endInclusive) > 0) {
      throw ArgumentError('区间边界必须有序且不能为 NaN');
    }
  }

  /// 包含在区间内的起点。
  final T start;

  /// 包含在区间内的终点。
  final T endInclusive;

  /// 判断值是否在闭区间内；NaN 返回 false。
  bool contains(T value) =>
      !_isNaN(value) &&
      value.compareTo(start) >= 0 &&
      value.compareTo(endInclusive) <= 0;

  /// 将值限制到闭区间；NaN 原样返回。
  T clamped(T value) {
    if (_isNaN(value)) return value;
    if (value.compareTo(start) < 0) return start;
    if (value.compareTo(endInclusive) > 0) return endInclusive;
    return value;
  }

  @override
  bool operator ==(Object other) =>
      other is AxcRange<T> &&
      start == other.start &&
      endInclusive == other.endInclusive;
  @override
  int get hashCode => Object.hash(start, endInclusive);
  @override
  String toString() => '$start...$endInclusive';
}

bool _isNaN(Object value) => value is num && value.isNaN;

/// 整数闭区间。
typedef AxcIntRange = AxcRange<int>;

/// 浮点闭区间。
typedef AxcDoubleRange = AxcRange<double>;
