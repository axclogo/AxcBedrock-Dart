import 'package:axc_bedrock/axc_bedrock.dart';

void main() {
  // 原生值只增加 .axc 入口，操作返回原生结果。
  print('你好👨‍👩‍👧‍👦'.axc.keepPrefix(count: 2, suffix: '…'));
  print([1, 2, 3, 4, 5].axc.chunked(by: 2));
  final int? value = <int>[10, 20].axc.objectAt(1);
  print(value);
  print(1.5.axc.clamped(min: 0.0, max: 1.0));
  print(Uri.parse('https://example.org')
      .axc
      .append(parameters: {'q': 'Dart & Swift'}));
  print('abc'.axc.hashStr(AxcDigest.sha256));

  final owner = Object();
  final title = AxcAssociationKey<String>();
  title.set(owner, 'AxcBedrock');
  print(title.getObject(owner));
  title.remove(owner);

  final once = AxcOnce();
  once.run(() => print('当前 isolate 内执行一次'));
  once.run(() => print('不会执行'));
}
