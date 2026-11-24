import 'package:intl/intl.dart';

/// 日期命名空间；保留原值的 UTC/本地时区模式。
extension type AxcDateSpace(DateTime base) {
  /// 年份。
  int get year => base.year;

  /// 月份，范围 1 到 12。
  int get month => base.month;

  /// 月内日期。
  int get day => base.day;

  /// 小时。
  int get hour => base.hour;

  /// 分钟。
  int get minute => base.minute;

  /// 秒。
  int get second => base.second;

  /// 星期，周一为 1，周日为 7，遵循 Dart 约定。
  int get weekOfDay => base.weekday;

  /// 当前月的天数。
  int get monthDayNum => DateTime.utc(base.year, base.month + 1, 0).day;

  /// 昨天的同一本地时间，按日历计算，不固定减去 24 小时。
  DateTime get yesterday => addDays(-1);

  /// 明天的同一本地时间，按日历计算，不固定加上 24 小时。
  DateTime get tomorrow => addDays(1);

  /// 增减日历天数；本地不存在或重复的时刻遵循 Dart 平台规则。
  DateTime addDays(int days) => base.isUtc
      ? DateTime.utc(base.year, base.month, base.day + days, base.hour,
          base.minute, base.second, base.millisecond, base.microsecond)
      : DateTime(base.year, base.month, base.day + days, base.hour, base.minute,
          base.second, base.millisecond, base.microsecond);

  /// 固定时长的增减；与日历天数加减不同。
  DateTime add(Duration duration) => base.add(duration);

  /// 与另一日期的秒差，返回 base - other。
  double intervalSeconds(DateTime other) =>
      base.difference(other).inMicroseconds / Duration.microsecondsPerSecond;

  /// 与另一日期的分钟差。
  double intervalMinutes(DateTime other) => intervalSeconds(other) / 60;

  /// 与另一日期的小时差。
  double intervalHours(DateTime other) => intervalSeconds(other) / 3600;

  /// 与另一日期的固定 24 小时天数差，不是日历日期差。
  double intervalDays(DateTime other) => intervalSeconds(other) / 86400;

  /// 是否为周六或周日，不包含地区节假日规则。
  bool get isWeekend => base.weekday >= DateTime.saturday;

  /// 是否为周一至周五，不包含地区节假日规则。
  bool get isWorkday => !isWeekend;

  /// 是否晚于当前时间。
  bool get isFuture => base.isAfter(DateTime.now());

  /// 是否早于当前时间。
  bool get isPast => base.isBefore(DateTime.now());

  /// 是否同一天；另一日期先转为 base 的 UTC/本地模式。
  bool isSameDay(DateTime other) {
    final converted = base.isUtc ? other.toUtc() : other.toLocal();
    return base.year == converted.year &&
        base.month == converted.month &&
        base.day == converted.day;
  }

  /// 是否为今天；可传入时钟值以便测试。
  bool isToday({DateTime? now}) => isSameDay(now ?? DateTime.now());

  /// 是否为昨天；可传入时钟值以便测试。
  bool isYesterday({DateTime? now}) {
    final today = now ?? DateTime.now();
    final converted = base.isUtc ? today.toUtc() : today.toLocal();
    return isSameDay(AxcDateSpace(converted).yesterday);
  }

  /// 是否为明天；可传入时钟值以便测试。
  bool isTomorrow({DateTime? now}) {
    final today = now ?? DateTime.now();
    final converted = base.isUtc ? today.toUtc() : today.toLocal();
    return isSameDay(AxcDateSpace(converted).tomorrow);
  }

  /// ISO 8601 表示，UTC 包含 Z，本地时间不带偏移；遵循 DateTime。
  String get iso8601String => base.toIso8601String();

  /// 使用 intl 格式化；非默认地区需先加载相应的 intl 日期数据。
  /// 格式遵循 intl，不承诺兼容全部 Apple DateFormatter 格式符。
  String string({String format = 'yyyy-MM-dd', String locale = 'en_US'}) =>
      DateFormat(format, locale).format(base);
}

/// DateTime 的唯一命名空间入口。
extension AxcDateNamespace on DateTime {
  /// 日期命名空间。
  AxcDateSpace get axc => AxcDateSpace(this);
}

/// 日期静态创建入口。
abstract final class AxcDate {
  /// 严格解析指定格式；无效日期返回 null，默认使用 UTC。
  static DateTime? createOptional(String text,
      {String format = 'yyyy-MM-dd',
      String locale = 'en_US',
      bool utc = true}) {
    try {
      return DateFormat(format, locale).parseStrict(text, utc);
    } on FormatException {
      return null;
    }
  }
}

/// 固定时长的命名空间，避免整数除法丢失小数。
extension type AxcDurationSpace(Duration base) {
  /// 总秒数，包含小数。
  double get seconds => base.inMicroseconds / Duration.microsecondsPerSecond;

  /// 总分钟数，包含小数。
  double get minutes => seconds / 60;

  /// 总小时数，包含小数。
  double get hours => seconds / 3600;

  /// 固定 24 小时天数，包含小数。
  double get days => seconds / 86400;
}

/// Duration 的唯一命名空间入口。
extension AxcDurationNamespace on Duration {
  /// 时长命名空间。
  AxcDurationSpace get axc => AxcDurationSpace(this);
}
