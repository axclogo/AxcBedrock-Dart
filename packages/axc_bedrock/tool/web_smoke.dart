import 'package:axc_bedrock/axc_bedrock.dart';

void check(bool condition, String label) {
  if (!condition) throw StateError(label);
}

/// 经 dart compile js 后可由 Node 执行，确认核心包无 dart:io/Flutter 依赖。
void main() {
  check(
      'A👨‍👩‍👧‍👦B'.axc.keepPrefix(count: 2) == 'A👨‍👩‍👧‍👦', 'graphemes');
  check([1, 2, 3].axc.objectAt(-1) == null, 'bounds');
  check([1, 2, 3].axc.sum() == 6, 'typed sum');
  check(double.nan.axc.clamped(min: 0.0, max: 1.0).isNaN, 'NaN');
  check(
      'abc'.axc.hashStr(AxcDigest.sha256) ==
          'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      'hash');
  final host = <int>[];
  final key = AxcAssociationKey<String>();
  key.set(host, 'ok');
  check(key.getObject(host) == 'ok', 'association');
  key.remove(host);
  check(key.getObject(host) == null, 'removal');
  final once = AxcOnce();
  check(once.run(() {}) && !once.run(() {}), 'once');
  check(
      Uri.parse('https://example.org')
              .axc
              .append(parameters: {'q': 'a&b'}).queryParameters['q'] ==
          'a&b',
      'URI');
  print('PASS: web core smoke');
}
