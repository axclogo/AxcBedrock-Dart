part of axc_bedrock;

abstract class AxcRange<T extends Comparable> {
  const AxcRange();

  /// 起始索引（不包含）
  T get start;

  /// 终止索引（包含）
  T get endInclusive;

  /// 检查指定的[value]是否在范围内，等于
  /// [start]或[endInclusive]或介于两者之间
  bool isContains(T value) {
    if (start.compareTo(endInclusive) <= 0) {
      return start.compareTo(value) <= 0 && value.compareTo(endInclusive) <= 0;
    } else {
      return endInclusive.compareTo(value) <= 0 && value.compareTo(start) <= 0;
    }
  }

  /// 主要用于输出dayin
  @override
  String toString() {
    return '$start..$endInclusive';
  }

  /// 比较操作符
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AxcRange &&
            runtimeType == other.runtimeType &&
            start == other.start &&
            endInclusive == other.endInclusive;
  }

  /// 唯一值
  @override
  int get hashCode {
    return start.hashCode ^ endInclusive.hashCode;
  }
}
