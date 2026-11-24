/// 布尔值的命名空间。
extension type AxcBoolSpace(bool base) {
  /// true 对应 1，false 对应 0。
  int get intValue => base ? 1 : 0;

  /// 返回 true 或 false 的小写字符串。
  String get string => base.toString();

  /// 返回取反结果，不修改原值。
  bool get toggled => !base;
}

/// 布尔值的唯一命名空间入口。
extension AxcBoolNamespace on bool {
  /// 布尔命名空间。
  AxcBoolSpace get axc => AxcBoolSpace(this);
}

/// 布尔静态创建入口，对应 Swift 的 Bool.Axc.Create 系列。
abstract final class AxcBool {
  /// 支持 bool、有限数值和 true/false、yes/no、1/0 字符串；其余返回 null。
  static bool? createOptional(Object? value) {
    if (value is bool) return value;
    if (value is num) return value.isFinite ? value != 0 : null;
    if (value is String) {
      return switch (value.trim().toLowerCase()) {
        'true' || 'yes' || '1' => true,
        'false' || 'no' || '0' => false,
        _ => null,
      };
    }
    return null;
  }

  /// 无法转换时使用显式默认值，默认为 false。
  static bool create(Object? value, {bool fallback = false}) =>
      createOptional(value) ?? fallback;
}
