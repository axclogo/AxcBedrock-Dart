import 'dart:typed_data';
import 'package:axc_bedrock/axc_bedrock.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show AssetBundle;

/// 颜色静态创建入口；8 位颜色按 RRGGBBAA 解释。
abstract final class AxcColor {
  /// 接受带可选 # 的 RGB、RRGGBB、RRGGBBAA，非法输入返回 null。
  static Color? createOptional(String hex) {
    var value = hex.startsWith('#') ? hex.substring(1) : hex;
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(value)) return null;
    if (value.length == 3) value = value.split('').map((c) => '$c$c').join();
    if (value.length == 6) {
      return Color(0xff000000 | int.parse(value, radix: 16));
    }
    if (value.length == 8) {
      final rgba = int.parse(value, radix: 16);
      return Color(((rgba & 0xff) << 24) | (rgba >> 8));
    }
    return null;
  }
}

/// 颜色命名空间。
extension type AxcColorSpace(Color base) {
  /// 根据相对亮度判断是否偏亮，阈值必须在 0 到 1 之间。
  bool isLight({double threshold = 0.5}) {
    if (!threshold.isFinite || threshold < 0 || threshold > 1) {
      throw ArgumentError.value(threshold, 'threshold');
    }
    return base.computeLuminance() > threshold;
  }
}

/// Color 的唯一入口。
extension AxcColorNamespace on Color {
  /// 颜色命名空间。
  AxcColorSpace get axc => AxcColorSpace(this);
}

/// 在已有字符串 Space 上添加 Flutter 能力，不重新定义 String.axc。
extension AxcStringPainting on AxcStringSpace {
  /// 将字符串视为十六进制颜色，非法时返回 null。
  Color? get color => AxcColor.createOptional(base);

  /// 将字符串视为资源名称，返回原生图片提供者，不立即解码。
  AssetImage assetImage({AssetBundle? bundle, String? package}) =>
      AssetImage(base, bundle: bundle, package: package);
}

/// 在已有数值 Space 上添加 Flutter 字体配置。
extension AxcNumberPainting<T extends num> on AxcNumberSpace<T> {
  /// 创建指定字号的原生 TextStyle；字号必须有限且非负。
  TextStyle font({FontWeight weight = FontWeight.normal, String? family}) {
    if (!base.isFinite || base < 0) throw ArgumentError.value(base, 'fontSize');
    return TextStyle(
        fontSize: base.toDouble(), fontWeight: weight, fontFamily: family);
  }
}

/// 图片静态入口，直接返回 Flutter 原生提供者，不新增统一图片包装类型。
abstract final class AxcImage {
  /// 从资源名称创建图片提供者。
  static AssetImage asset(String name, {String? package}) =>
      AssetImage(name, package: package);

  /// 从 URI 创建网络图片提供者，不在此处发起请求。
  static NetworkImage network(Uri uri, {Map<String, String>? headers}) =>
      NetworkImage(uri.toString(), headers: headers);

  /// 从编码后的图片字节创建提供者；调用方不得再修改这些字节。
  static MemoryImage memory(Uint8List bytes, {double scale = 1}) {
    if (!scale.isFinite || scale <= 0) {
      throw ArgumentError.value(scale, 'scale');
    }
    return MemoryImage(bytes, scale: scale);
  }
}
