part of axc_bedrock;

class AxcStringSpace {
  AxcStringSpace(String str) {
    //构造方法
    this.base = str;
  }
  String base = "";
}

extension StringExtension on String {
  AxcStringSpace get axc {
    return AxcStringSpace(this);
  }
}

/// 数据转换
extension StringToTransform on AxcStringSpace {
  /// 转换为int类型，[radix]为进制，默认为10
  int toInt({int? radix}) {
    return int.parse(base, radix: radix);
  }

  /// 转换为int可选类型，[radix]为进制，默认为10
  int? toInt_optional({int? radix}) {
    return int.tryParse(base, radix: radix);
  }

  /// 转换为Double类型
  double toDouble() {
    return double.parse(base);
  }

  /// 转换为Double可选类型
  double? toDouble_optional() {
    return double.tryParse(base);
  }

  /// 转换成Bool类型
  bool toBool() {
    return toBool_optional() ?? false;
  }

  /// 转换成Bool可选类型
  bool? toBool_optional() {
    switch (base) {
      case "true":
        return true;
      case "false":
        return false;
      default:
        return null;
    }
  }

  /// 转换成UTF-8编码
  List<int> toUtf8() {
    return utf8.encode(base);
  }

  /// 转换成UTF-16编码
  List<int> toUtf16() {
    return base.codeUnits;
  }

  /// 获取这个字符串UrlEncoded编码字符
  String urlEncode() {
    return Uri.encodeFull(base);
  }

  /// 获取这个字符串UrlDecode解码字符
  String urlDecode() {
    return Uri.decodeFull(base);
  }
}

/// 属性 & Api
extension StringToApi on AxcStringSpace {
  // MARK: ================================头部操作================================

  /// 头部附加[string]，如果本串自带，则不附加
  String appendPrefix(String string) {
    if (base.startsWith(string)) {
      return base;
    }
    return "$string$base";
  }

  /// 保留头部多少数量的字符
  ///
  ///     "AxcLogo".axc.keepPrefix(count: 3) = "Axc"
  ///     "AxcLogo".axc.keepPrefix(count: 3, suffix: "...") = "Axc..."
  ///
  String keepPrefix(int count, {String suffix = ""}) {
    if (base.length > count) {
      String newStr = base.substring(0, count);
      newStr += suffix;
      return newStr;
    } else {
      return base;
    }
  }

  /// 去掉头部多少位字符
  String removePrefixWithCount(int count) {
    if ((count <= base.length) || (count > 0)) {
      return base.substring(count);
    }
    return base;
  }

  /// 去掉头部某种符合的前缀
  String removePrefixWithString(String prefix) {
    if (base.startsWith(prefix)) {
      return base.substring(prefix.length);
    }
    return base;
  }

  // MARK: ================================尾部操作================================

  /// 尾部附加某段字符，如果本串自带，则不附加
  String appendSuffix(String string) {
    if (!base.endsWith(string)) {
      return "$base$string";
    }
    return base;
  }

  /// 保留尾部多少数量的字符
  ///
  ///     "12345".axc.keepSuffix(count: 3) = 345
  ///
  String keepSuffix(int count, {String prefix = ""}) {
    if (base.length > count) {
      String newStr = base.substring(base.length - count);
      newStr = "$prefix$newStr";
      return newStr;
    }
    return base;
  }

  /// 去掉尾部多少位字符串
  String removeSuffixWithCount(int count) {
    if ((base.length - count >= 0) || (count > 0)) {
      return base.substring(0, base.length - count);
    }
    return base;
  }

  /// 去掉尾部某种符合的后缀
  String removeSuffixWithString(String string) {
    if (base.endsWith(string)) {
      return base.substring(0, base.length - string.length);
    }
    return base;
  }

  // MARK: ================================分隔操作================================

  /// 通过AxcIntRange来获取一段子串
  String substringWithRange(AxcIntRange range) {
    return base.substring(range.start, range.endInclusive);
  }

  /// 切割获取从某个开始到某个结束中间的字符
  List<String> splitStartToEnd(String start, String end) {
    List<String> result = [];
    int startIndex = 0;
    while (true) {
      startIndex = base.indexOf(start, startIndex);
      if (startIndex == -1) break;
      int endIndex = base.indexOf(end, startIndex);
      if (endIndex == -1) break;
      String bracketedString = base.substring(startIndex, endIndex + 1);
      result.add(bracketedString);
      startIndex = endIndex;
    }
    return result;
  }

  /// 使用传入的字符进行分隔字符串
  List<String> splitWithSeparator(String separator) {
    List<String> newStrs = base.split(separator)
      ..removeWhere((str) => str.trim().isEmpty);
    return newStrs;
  }

  /// 使用传入的多字符进行分隔字符串
  List<String> splitWithCharStrs(String charStrs) {
    List<String> result = base.split(new RegExp("[$charStrs]"));
    return result;
  }

  // MARK: ================================尾部操作================================

  /// 替换字符串
  /// 将多个字符串全部替换成指定的字符串
  String replaceWithStrings(List<String> strings, {String withString = ""}) {
    String newString = base;
    for (String string in strings) {
      newString = newString.replaceAll(string, withString);
    }
    return newString;
  }

  /// 替换字符串
  String replaceWithString(String str, {String withString = ""}) {
    return str.replaceAll(RegExp(str), withString);
  }

  // MARK: ================================匹配操作================================

  /// 匹配字符串出现的位置
  List<AxcIntRange> matchString(String substring) {
    List<AxcIntRange> ranges = [];
    int start = 0;
    while (start != -1) {
      start = base.indexOf(substring, start);
      if (start != -1) {
        int end = start + substring.length;
        ranges.add(AxcIntRange(start, end));
        start = end;
      }
    }
    return ranges;
  }
}
