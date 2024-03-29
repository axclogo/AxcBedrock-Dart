import 'package:axc_bedrock/axc_bedrock.dart';

void main() {
  // stringToApi();
  // listToApi();
  // mapToApi();
  intToApi();
}

void intToApi() {
  print(1.axc.toString());
  print(1.toString());

  num i = 10;
  i.axc.limitThan(min: 1, max: 2);

  10.0.axc.limitThan(min: 1, max: 2);

  print(10.axc.limitThan(min: 10)); // 10
}

void mapToApi() {
  Map map = {"1": "2"};
  print(map.axc.valueFor("2"));
}

void listToApi() {
  List<String> list = ["1", "2", "3", "4", "5"];
  print(list.axc.objectAt(5));
}

void stringToApi() {
  print("123123".axc.appendPrefix("123"));
  print("123123".axc.appendPrefix("asd"));

  print("AxcLogo".axc.keepPrefix(3));
  print("AxcLogo".axc.keepPrefix(3, suffix: "..."));

  print("AxcLogo".axc.removePrefix(count: 1));
  print("AxcLogo".axc.removePrefix(count: 0));
  print("AxcLogo".axc.removePrefixWithString("Axc"));
  print("AxcLogo".axc.removePrefixWithString("B"));

  print("123123".axc.appendSuffix("123"));
  print("123123".axc.appendSuffix("asd"));

  print("AxcLogo".axc.keepSuffix(3));
  print("AxcLogo".axc.keepSuffix(3, prefix: "..."));

  print("AxcLogo".axc.removeSuffixWithCount(3));
  print("AxcLogo".axc.removeSuffixWithCount(0));
  print("AxcLogo".axc.removeSuffixWithString("ogo"));
  print("AxcLogo".axc.removeSuffixWithString("B"));

  print("a[asd]1[qwe]c[12345]".axc.splitStartToEnd("[", "]"));
  print("a,asd,1,qwe,c,12345".axc.splitWithSeparator(","));
  print("a,asd 1.qwe.c 12345".axc.splitWithCharStrs(", ."));

  print("123_asd_qwe_cvb"
      .axc
      .replaceWithStrings(["123", "qwe"], withString: "11"));

  var str = "123456123qwe123qwe890qwe";
  var ranges = str.axc.matchString("qwe");
  ranges.forEach((range) {
    print(str.axc.substringWithRange(range));
  });
}
