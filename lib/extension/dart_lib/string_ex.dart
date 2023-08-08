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

// MARK: 数据转换
extension StringToTransform on AxcStringSpace {
  /// 转换为int类型，[radix]为进制，默认为10
  int toInt({int? radix}) {
    return int.parse(base, radix: radix);
  }

  /// 转换为int可选类型，[radix]为进制，默认为10
  int? asInt({int? radix}) {
    return int.tryParse(base, radix: radix);
  }

  /// 转换为Double类型
  double toDouble() {
    return double.parse(base);
  }

  /// 转换为Double可选类型
  double? asDouble() {
    return double.tryParse(base);
  }

  /// 转换成Bool类型
  bool toBool() {
    return asBool() ?? false;
  }

  /// 转换成Bool可选类型
  bool? asBool() {
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

// MARK: - 属性 & Api
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
  String removePrefix({int count = 0}) {
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
  /// 返回一个新的子字符串，包含从[start]（包括）到[end]（包括）之间的所有字符。
  /// 如果省略[end]，则会设置为`lastIndex`。
  ///
  /// ```dart
  /// print('awesomeString'.axc.substring(0,6)); // awesome
  /// print('awesomeString'.axc.substring(7)); // String
  /// ```
  String substring(int start, [int end = -1]) {
    final _start = start < 0 ? start + base.length : start;
    final _end = end < 0 ? end + base.length : end;
    RangeError.checkValidRange(_start, _end, base.length);
    return substring(_start, _end + 1);
  }

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

/// 决策判断
extension StringToGuard on AxcStringSpace {
  /// 是否不为空
  bool isNotEmpty() {
    return !isEmpty();
  }

  /// 是否为空
  bool isEmpty() {
    return base.isEmpty;
  }

  /// 如果字符串是ASCII编码则返回' true '
  bool get isAscii {
    const _ascii = 0x007f;
    for (final codeUnit in base.codeUnits) {
      if (codeUnit > _ascii) {
        return false;
      }
    }
    return true;
  }

  /// 判断是否包含Emoji表情
  bool hasEmoji(String text) {
    /**
     [\u{1F300}-\u{1F64F}]: This range matches emoji characters from the Miscellaneous Symbols and Pictographs block, which includes various symbols and pictographs.
[\u{2702}-\u{27B0}]: This range matches emoji characters from the Dingbats block, which includes symbols and icons.
[\u{1F680}-\u{1F6FF}]: This range matches emoji characters from the Transport and Map Symbols block, which includes symbols related to transportation, maps, and vehicles.
[\u{2600}-\u{26FF}]: This range matches emoji characters from the Miscellaneous Symbols block, which includes various symbols and icons.
[\u{1F1E6}-\u{1F1FF}]: This range matches emoji characters from the Regional Indicator Symbols block, which are used to represent country flags.
[\u{1F900}-\u{1F9FF}]: This range matches emoji characters from the Supplemental Symbols and Pictographs block, which includes additional symbols and pictographs.
[\u{1F170}-\u{1F251}]: This range matches emoji characters from the Enclosed Characters block, which includes characters enclosed in various shapes (such as circles and squares).
[\u{1F600}-\u{1F636}]: This range matches emoji characters from the Emoticons block, which includes emoticons and smiley faces.
[\u{1F681}-\u{1F6C5}]: This range matches emoji characters from the Additional Transport and Map Symbols block, which includes additional symbols related to transportation and maps.
[\u{1F30D}-\u{1F567}]: This range matches emoji characters from the Miscellaneous Symbols and Arrows block, which includes various symbols and arrows.

     [\u{1F300}-\u{1F64F}]:此范围匹配来自杂项符号和象形文字块的表情符号字符，其中包括各种符号和象形文字。
     [\u{2702}-\u{27B0}]:此范围匹配Dingbats块中的表情符号字符，其中包括符号和图标。
     [\u{1F680}-\u{1F6FF}]:此范围匹配来自交通和地图符号块的表情符号字符，其中包括与交通、地图和车辆相关的符号。
     [\u{2600}-\u{26FF}]:此范围匹配杂项符号块中的表情符号字符，其中包括各种符号和图标。
     [\u{1F1E6}-\u{1F1FF}]:此范围与区域指示符号块中的表情符号字符相匹配，用于表示国旗。
     [\u{1F900}-\u{1F9FF}]:此范围匹配来自补充符号和象形文字块的表情符号字符，其中包括额外的符号和象形文字。
     [\u{1F170}-\u{1F251}]:此范围匹配封闭字符块中的表情符号字符，其中包括以各种形状(如圆形和正方形)封闭的字符。
     [\u{1F600}-\u{1F636}]:此范围匹配emoticon块中的表情符号字符，其中包括表情符号和笑脸。
     [\u{1F681}-\u{1F6C5}]:此范围匹配来自附加交通和地图符号块的表情符号字符，其中包括与交通和地图相关的附加符号。
     [\u{1F30D}-\u{1F567}]:此范围匹配来自杂项符号和箭头块的表情符号字符，其中包括各种符号和箭头。
    */
    RegExp regex = RegExp(
      r"""([\u{1F300}-\u{1F64F}] 
      |[\u{2702}-\u{27B0}]
      |[\u{1F680}-\u{1F6FF}]
      |[\u{2600}-\u{26FF}]
      |[\u{1F1E6}-\u{1F1FF}]
      |[\u{1F900}-\u{1F9FF}]
      |[\u{1F170}-\u{1F251}]
      |[\u{1F600}-\u{1F636}]
      |[\u{1F681}-\u{1F6C5}]
      |[\u{1F30D}-\u{1F567}])""",
      unicode: true,
    );
    return regex.hasMatch(text);
  }
}
