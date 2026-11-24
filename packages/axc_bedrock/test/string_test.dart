import 'dart:typed_data';
import 'package:axc_bedrock/axc_bedrock.dart';
import 'package:test/test.dart';

void main() {
  test('截取按字素簇处理 emoji、旗帜和组合字符', () {
    const text = 'A👨‍👩‍👧‍👦🇨🇳e\u0301中';
    expect(text.axc.length, 5);
    expect(text.axc.keepPrefix(count: 2), 'A👨‍👩‍👧‍👦');
    expect(text.axc.keepSuffix(count: 2), 'e\u0301中');
    expect(text.axc.stringAt(2), '🇨🇳');
    expect(text.axc.substring(start: 1, end: 3), '👨‍👩‍👧‍👦🇨🇳');
    expect(text.axc.substringWithRange(AxcIntRange(1, 2)), '👨‍👩‍👧‍👦🇨🇳');
    expect(text.axc.lastSecond, 'e\u0301');
  });
  test('字符串的空输入、负数和越界', () {
    expect(''.axc.first, isNull);
    expect(''.axc.last, isNull);
    expect(''.axc.camelCased, '');
    expect('abc'.axc.stringAt(-1), isNull);
    expect('abc'.axc.substring(start: 3), '');
    expect('abc'.axc.substring(start: 4), isNull);
    expect('abc'.axc.substring(start: 2, end: 1), isNull);
    expect('abc'.axc.removePrefix(count: -1), isNull);
    expect('abc'.axc.removeSuffix(count: -1), isNull);
    expect('abc'.axc.removeSuffix(count: 4), isNull);
    expect('abc'.axc.removePrefix(count: 3), '');
    expect('abc'.axc.keepPrefix(count: 2, suffix: '…'), 'ab…');
    expect('abc'.axc.keepPrefix(count: 3, suffix: '…'), 'abc');
    expect('abc'.axc.keepSuffix(count: 0), '');
    expect(() => 'abc'.axc.keepPrefix(count: -1), throwsArgumentError);
    expect(() => 'abc'.axc.keepSuffix(count: -1), throwsArgumentError);
  });
  test('前后缀和替换操作作用于宿主', () {
    expect('abc'.axc.appendPrefix(string: 'x'), 'xabc');
    expect('abc'.axc.appendPrefix(string: 'a'), 'abc');
    expect('abc'.axc.appendSuffix(string: 'x'), 'abcx');
    expect('abc'.axc.removePrefixString('a'), 'bc');
    expect('abc'.axc.removeSuffixString('bc'), 'a');
    expect('abc'.axc.removeSuffixString(''), 'abc');
    expect('a.b.a'.axc.replacing('.', withString: '-'), 'a-b-a');
    expect(
        'abcabc'.axc.replacingStrings(['a', 'b'], withString: '_'), '__c__c');
    expect('hello world'.axc.camelCased, 'helloWorld');
    expect('abc'.axc.uppercased(1), 'aBc');
    expect('abc'.axc.uppercased(9), 'abc');
  });
  test('切割、查找及空标记不会死循环', () {
    expect('a, ,b,,'.axc.split(separator: ','), ['a', 'b']);
    expect('x<<a>>y<<b>>'.axc.splitBetween(start: '<<', end: '>>'),
        ['<<a>>', '<<b>>']);
    expect('<<a'.axc.splitBetween(start: '<<', end: '>>'), isEmpty);
    expect(
        () => 'abc'.axc.splitBetween(start: '', end: ']'), throwsArgumentError);
    expect('aaaa'.axc.count(of: 'aa'), 2);
    expect('Aa'.axc.count(of: 'a', caseSensitive: false), 2);
    expect('abc'.axc.count(of: ''), 0);
  });
  test('类型转换和有效性', () {
    expect('ff'.axc.asInt(radix: 16), 255);
    expect('x'.axc.asInt(), isNull);
    expect('1.5'.axc.asDouble(), 1.5);
    expect('NaN'.axc.asDouble()!.isNaN, isTrue);
    expect(' YES '.axc.asBool(), isTrue);
    expect('NO'.axc.asBool(), isFalse);
    expect('maybe'.axc.asBool(), isNull);
    expect('ascii'.axc.isAscii, isTrue);
    expect('中'.axc.isAscii, isFalse);
    expect('{"value":1}'.axc.isJsonString, isTrue);
    expect('null'.axc.isJsonString, isTrue);
    expect('{'.axc.isJsonString, isFalse);
    expect('abc'.axc.isConform(pattern: '['), isFalse);
    expect('abc'.axc.isConform(pattern: '^a'), isTrue);
  });
  test('UTF-8、Base64、十六进制和 URI 编解码', () {
    const text = '你好👋';
    expect(text.axc.data.axc.string, text);
    expect(text.axc.base64EncodedString.axc.base64DecodedString, text);
    expect('%%%'.axc.base64Data, isNull);
    expect('/w=='.axc.base64DecodedString, isNull);
    expect('00fF'.axc.hexData, [0, 255]);
    expect('abc'.axc.hexData, isNull);
    expect('0g'.axc.hexData, isNull);
    expect(''.axc.hexData, isEmpty);
    expect('a&b +中'.axc.urlEncodedString.axc.urlDecodedString, 'a&b +中');
    expect('%ZZ'.axc.urlDecodedString, isNull);
    expect('https://example.org/a'.axc.url!.host, 'example.org');
    expect(Uint8List.fromList([255]).axc.string, isNull);
  });
  test('路径操作和摘要已知向量', () {
    expect('/a'.axc.appendPathComponent('b.txt'), '/a/b.txt');
    expect('/a/b.txt'.axc.lastPathComponent, 'b.txt');
    expect('/a/b.txt'.axc.pathExtension, 'txt');
    expect('abc'.axc.hashStr(AxcDigest.sha256),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
    expect(
        'The quick brown fox jumps over the lazy dog'
            .axc
            .hmacStr(AxcDigest.sha256, key: 'key'),
        'f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8');
    final bytes = 'abc'.axc.data;
    final copy = bytes.axc.byteArray()..[0] = 0;
    expect(bytes[0], 97);
    expect(copy[0], 0);
  });
}
