import 'dart:convert';
import 'dart:typed_data';
import 'package:characters/characters.dart';
import 'package:path/path.dart' as path;
import 'bool.dart';
import 'data.dart';
import 'range.dart';

/// 字符串命名空间；位置和长度按 Unicode 字素簇计算，不拆分组合字符。
extension type AxcStringSpace(String base) {
  /// 用户可见字符数，不是 UTF-16 长度。
  int get length => base.characters.length;

  /// 用户可见字符列表。
  List<String> get charsArray => base.characters.toList();

  /// 按索引取字符；越界返回 null。
  String? stringAt(int index) {
    if (index < 0) return null;
    final values = base.characters.skip(index);
    return values.isEmpty ? null : values.first;
  }

  /// 第一字符。
  String? get first => stringAt(0);

  /// 第二字符。
  String? get second => stringAt(1);

  /// 最后一字符。
  String? get last => base.isEmpty ? null : base.characters.last;

  /// 倒数第二字符。
  String? get lastSecond => stringAt(length - 2);

  /// 半开区间截取 [start, end)；无效范围返回 null。
  String? substring({required int start, int? end}) {
    final count = length;
    final limit = end ?? count;
    if (start < 0 || limit < start || limit > count) return null;
    return base.characters.skip(start).take(limit - start).join();
  }

  /// 使用闭区间截取；明确包含 endInclusive。
  String? substringWithRange(AxcIntRange range) =>
      substring(start: range.start, end: range.endInclusive + 1);

  /// 前缀不存在时添加前缀。
  String appendPrefix({required String string}) =>
      base.startsWith(string) ? base : '$string$base';

  /// 后缀不存在时添加后缀。
  String appendSuffix({required String string}) =>
      base.endsWith(string) ? base : '$base$string';

  /// 最多保留 count 个头部字符；仅截断时添加 suffix，负数抛出 ArgumentError。
  String keepPrefix({required int count, String suffix = ''}) {
    RangeError.checkNotNegative(count, 'count');
    return length > count
        ? '${base.characters.take(count).join()}$suffix'
        : base;
  }

  /// 最多保留 count 个尾部字符，负数抛出 ArgumentError。
  String keepSuffix({required int count}) {
    RangeError.checkNotNegative(count, 'count');
    final size = length;
    return size > count ? base.characters.skip(size - count).join() : base;
  }

  /// 移除 count 个头部字符；数量无效时返回 null。
  String? removePrefix({required int count}) => substring(start: count);

  /// 移除 count 个尾部字符；数量无效时返回 null。
  String? removeSuffix({required int count}) =>
      count < 0 ? null : substring(start: 0, end: length - count);

  /// 移除匹配的文字前缀，不匹配时原样返回。
  String removePrefixString(String prefix) =>
      base.startsWith(prefix) ? base.substring(prefix.length) : base;

  /// 移除匹配的文字后缀，不匹配时原样返回。
  String removeSuffixString(String suffix) => base.endsWith(suffix)
      ? base.substring(0, base.length - suffix.length)
      : base;

  /// 去掉两端空白。
  String get trimmed => base.trim();

  /// 将指定字符转为大写；索引无效时原样返回。
  String uppercased(int index) {
    final values = charsArray;
    if (index < 0 || index >= values.length) return base;
    values[index] = values[index].toUpperCase();
    return values.join();
  }

  /// 将空白分隔的单词转为小驼峰，不做语言学分词。
  String get camelCased {
    final words = base.trim().toLowerCase().split(RegExp(r'\s+'));
    return words.first +
        words.skip(1).map((word) => AxcStringSpace(word).uppercased(0)).join();
  }

  /// 按文字分隔符切割，移除仅含空白的片段。
  List<String> split({required String separator}) =>
      base.split(separator).where((value) => value.trim().isNotEmpty).toList();

  /// 获取非重叠的起止标记片段，包含完整标记；空标记抛出 ArgumentError。
  List<String> splitBetween({required String start, required String end}) {
    if (start.isEmpty || end.isEmpty) throw ArgumentError('起止标记不能为空');
    final result = <String>[];
    var cursor = 0;
    while (cursor < base.length) {
      final begin = base.indexOf(start, cursor);
      if (begin < 0) break;
      final finish = base.indexOf(end, begin + start.length);
      if (finish < 0) break;
      cursor = finish + end.length;
      result.add(base.substring(begin, cursor));
    }
    return result;
  }

  /// 按字面值替换全部匹配，不把输入解释为正则表达式。
  String replacing(String string, {String withString = ''}) =>
      base.replaceAll(string, withString);

  /// 按顺序替换多个字面值。
  String replacingStrings(Iterable<String> strings, {String withString = ''}) =>
      strings.fold(
          base, (result, value) => result.replaceAll(value, withString));

  /// 非重叠匹配的数量；空目标返回 0。
  int count({required String of, bool caseSensitive = true}) {
    if (of.isEmpty) return 0;
    final source = caseSensitive ? base : base.toLowerCase();
    final target = caseSensitive ? of : of.toLowerCase();
    return target.allMatches(source).length;
  }

  /// 转义正则元字符。
  String get regexEscaped => RegExp.escape(base);

  /// 正则是否有匹配；非法表达式返回 false。
  bool isConform({required String pattern}) {
    try {
      return RegExp(pattern, unicode: true).hasMatch(base);
    } on FormatException {
      return false;
    }
  }

  /// 是否为 ASCII 文本。
  bool get isAscii => base.codeUnits.every((unit) => unit <= 0x7f);

  /// 是否为有效 JSON；允许 JSON 标量。
  bool get isJsonString {
    try {
      jsonDecode(base);
      return true;
    } on FormatException {
      return false;
    }
  }

  /// 解析整数，失败返回 null；进制遵循 int.tryParse。
  int? asInt({int? radix}) => int.tryParse(base, radix: radix);

  /// 解析浮点数，失败返回 null；允许 Dart 的 NaN 和 Infinity 表示。
  double? asDouble() => double.tryParse(base);

  /// 解析布尔值，支持 true/false、yes/no、1/0，忽略大小写和两端空白。
  bool? asBool() => AxcBool.createOptional(base);

  /// UTF-8 字节。
  Uint8List get data => Uint8List.fromList(utf8.encode(base));

  /// Base64 编码 UTF-8 文本。
  String get base64EncodedString => base64.encode(utf8.encode(base));

  /// 解码 Base64 字节，格式错误时返回 null。
  Uint8List? get base64Data {
    try {
      return base64.decode(base);
    } on FormatException {
      return null;
    }
  }

  /// 解码 Base64 和 UTF-8，任一步非法均返回 null。
  String? get base64DecodedString {
    final bytes = base64Data;
    return bytes == null ? null : AxcDataSpace(bytes).string;
  }

  /// 将偶数长度的十六进制文本解码为字节；不接受前缀或空白。
  Uint8List? get hexData {
    if (base.length.isOdd || !RegExp(r'^[0-9a-fA-F]*$').hasMatch(base)) {
      return null;
    }
    return Uint8List.fromList([
      for (var i = 0; i < base.length; i += 2)
        int.parse(base.substring(i, i + 2), radix: 16)
    ]);
  }

  /// 编码 URL 组件；与完整 URL 编码不同，保留分隔符应使用 Uri。
  String get urlEncodedString => Uri.encodeComponent(base);

  /// 解码 URL 组件，非法编码返回 null。
  String? get urlDecodedString {
    try {
      return Uri.decodeComponent(base);
    } on ArgumentError {
      return null;
    } on FormatException {
      return null;
    }
  }

  /// 解析 URI；格式无效返回 null，允许相对 URI。
  Uri? get url => Uri.tryParse(base);

  /// 按 POSIX 路径规则拼接，不做文件访问。
  String appendPathComponent(String component) =>
      path.posix.join(base, component);

  /// POSIX 路径末尾分量。
  String get lastPathComponent => path.posix.basename(base);

  /// POSIX 扩展名，不包含开头的点。
  String get pathExtension {
    final extension = path.posix.extension(base);
    return extension.isEmpty ? '' : extension.substring(1);
  }

  /// 计算 UTF-8 文本的十六进制摘要。
  String hashStr(AxcDigest algorithm) => AxcDataSpace(data).hashStr(algorithm);

  /// 计算 UTF-8 文本的字节摘要。
  Uint8List hashData(AxcDigest algorithm) =>
      AxcDataSpace(data).hashData(algorithm);

  /// 计算 UTF-8 文本的 Base64 摘要。
  String hashBase64(AxcDigest algorithm) =>
      AxcDataSpace(data).hashBase64(algorithm);

  /// 使用 UTF-8 字符串密钥计算 HMAC。
  String hmacStr(AxcDigest algorithm, {required String key}) =>
      AxcDataSpace(data).hmacStr(algorithm, key: utf8.encode(key));
}

/// 字符串的唯一命名空间入口。
extension AxcStringNamespace on String {
  /// 字符串命名空间。
  AxcStringSpace get axc => AxcStringSpace(this);
}
