import 'dart:math' as math;
import 'dart:typed_data';
import 'range.dart';

/// 保留 int、double 或 num 静态类型的数值命名空间。
extension type AxcNumberSpace<T extends num>(T base) {
  /// 限制到闭区间；NaN 原样返回，边界不能为 NaN 或反向。
  T clamped({required T min, required T max}) {
    if (min.isNaN || max.isNaN || min > max) throw ArgumentError('无效的闭区间');
    if (base < min) return min;
    if (base > max) return max;
    return base;
  }

  /// 是否位于给定闭区间内。
  bool isInRange(AxcRange<T> range) => range.contains(base);

  /// 四舍五入到指定小数位；负数表示十位等，NaN 和无穷原样返回。
  double rounded({int numPlaces = 0}) {
    RangeError.checkValueInInterval(numPlaces, -308, 308, 'numPlaces');
    if (!base.isFinite) return base.toDouble();
    final factor = math.pow(10, numPlaces).toDouble();
    final scaled = base * factor;
    if (!scaled.isFinite) return base.toDouble();
    return scaled.roundToDouble() / factor;
  }

  /// 角度转弧度。
  double get angleToRadian => base * math.pi / 180;

  /// 弧度转角度。
  double get radianToAngle => base * 180 / math.pi;

  /// 转为 double，遵循 Dart 数值转换规则。
  double get doubleValue => base.toDouble();

  /// 有限值截断为 int；非有限值返回 null，范围遵循目标平台。
  int? asInt() => base.isFinite ? base.toInt() : null;

  /// 非零为 true，零为 false。
  bool get boolValue => base != 0;

  /// 十进制字符串。
  String get string => base.toString();

  /// 八字节整数或 IEEE 754 浮点表示；Web 整数精度遵循 Dart 限制。
  Uint8List toBytes({Endian endian = Endian.big}) {
    final data = ByteData(8);
    if (base is int) {
      data.setInt64(0, base.toInt(), endian);
    } else {
      data.setFloat64(0, base.toDouble(), endian);
    }
    return data.buffer.asUint8List();
  }
}

/// 所有数值共用一个入口，保留接收者的静态类型。
extension AxcNumberNamespace<T extends num> on T {
  /// 数值命名空间。
  AxcNumberSpace<T> get axc => AxcNumberSpace<T>(this);
}

/// 整数命名空间的附加能力。
extension AxcIntegerOperations on AxcNumberSpace<int> {
  /// 英文序数表示，例如 21st；负数保留符号。
  String ordinal() {
    final value = base.abs();
    final tail = value % 100;
    final suffix = tail >= 11 && tail <= 13
        ? 'th'
        : switch (value % 10) {
            1 => 'st',
            2 => 'nd',
            3 => 'rd',
            _ => 'th',
          };
    return '$base$suffix';
  }

  /// 固定秒数的时长，不表示日历分量。
  Duration get second => Duration(seconds: base);

  /// 固定分钟数的时长。
  Duration get minute => Duration(minutes: base);

  /// 固定小时数的时长。
  Duration get hour => Duration(hours: base);

  /// 固定 24 小时天数的时长；日历加减请使用 DateTime.axc.addDays。
  Duration get day => Duration(days: base);

  /// 固定七天一周的时长。
  Duration get week => Duration(days: base * 7);
}
