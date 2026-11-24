import 'dart:typed_data';
import 'package:axc_bedrock_flutter/axc_bedrock_flutter.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('核心与 Flutter 导入不产生 axc 歧义', () {
    final int? item = <int>[1].axc.objectAt(0);
    expect(item, 1);
    expect('abcdef'.axc.keepPrefix(count: 3), 'abc');
    expect('ff0000'.axc.color, const Color(0xffff0000));
    expect(16.axc.font().fontSize, 16);
    expect(16.axc.clamped(min: 10, max: 12), 12);
    expect(Uint8List.fromList([65]).axc.string, 'A');
  });
  test('点的有限性、距离与取整', () {
    expect(Offset.zero.axc.isFinite, isTrue);
    expect(const Offset(-1, 2).axc.isFinite, isTrue);
    expect(const Offset(double.nan, 0).axc.isFinite, isFalse);
    expect(const Offset(0, double.infinity).axc.isFinite, isFalse);
    expect(Offset.zero.axc.distance(to: const Offset(3, 4)), 5);
    expect(const Offset(1.2, -1.2).axc.ceilUp, const Offset(2, -1));
    expect(const Offset(1.2, -1.2).axc.floorDown, const Offset(1, -2));
    expect(const Offset(1, 2).axc.set(x: 3), const Offset(3, 2));
  });
  test('尺寸运算和等比布局', () {
    const size = Size(100, 50);
    expect(size.axc.aspectFit(const Size(50, 50)), const Size(50, 25));
    expect(size.axc.aspectFill(const Size(50, 50)), const Size(100, 50));
    expect(size.axc.aspectFit(Size.zero), Size.zero);
    expect(size.axc.add(size: const Size(1, 2)), const Size(101, 52));
    expect(size.axc.subtract(size: const Size(1, 2)), const Size(99, 48));
    expect(size.axc.scale(2), const Size(200, 100));
    expect(size.axc.addInsets(const EdgeInsets.all(1)), const Size(102, 52));
    expect(
        size.axc.subtractInsets(const EdgeInsets.all(1)), const Size(98, 48));
    expect(const Size(-1, 0).axc.isFinite, isTrue);
    expect(() => Size.zero.axc.aspectFit(size), throwsArgumentError);
    expect(() => size.axc.aspectFill(const Size(-1, 2)), throwsArgumentError);
    expect(() => const Size(double.nan, 2).axc.aspectFit(size),
        throwsArgumentError);
  });
  test('矩形有限性、非零原点居中和溢出', () {
    const rect = Rect.fromLTWH(0, 0, 100, 50);
    const bounds = Rect.fromLTWH(10, 20, 50, 50);
    expect(rect.axc.aspectFit(bounds), const Rect.fromLTWH(10, 32.5, 50, 25));
    expect(rect.axc.aspectFill(bounds), const Rect.fromLTWH(-15, 20, 100, 50));
    expect(rect.axc.scale(2), const Rect.fromLTWH(0, 0, 200, 100));
    expect(rect.axc.set(x: 2), const Rect.fromLTWH(2, 0, 100, 50));
    expect(Rect.zero.axc.isFinite, isTrue);
    expect(const Rect.fromLTWH(0, 0, -1, -1).axc.isFinite, isTrue);
    expect(const Rect.fromLTWH(double.nan, 0, 1, 1).axc.isFinite, isFalse);
    expect(
        const Rect.fromLTRB(-double.maxFinite, 0, double.maxFinite, 1)
            .axc
            .isFinite,
        isFalse);
  });
  test('方向性边距显式解析 LTR 和 RTL', () {
    const edge = EdgeInsetsDirectional.fromSTEB(1, 2, 3, 4);
    expect(edge.axc.horizontal, 4);
    expect(edge.axc.vertical, 6);
    expect(
        edge.axc.inset(
            rect: const Rect.fromLTWH(0, 0, 10, 20),
            direction: TextDirection.ltr),
        const Rect.fromLTWH(1, 2, 6, 14));
    expect(
        edge.axc.inset(
            rect: const Rect.fromLTWH(0, 0, 10, 20),
            direction: TextDirection.rtl),
        const Rect.fromLTWH(3, 2, 6, 14));
    expect(edge.axc.addHorizontal(2).horizontal, 8);
    expect(edge.axc.addVertical(2).vertical, 10);
    expect(edge.axc.scale(2).vertical, 12);
    expect(edge.axc.add(edge: const EdgeInsets.all(1)).vertical, 8);
    expect(edge.axc.subtract(edge: const EdgeInsets.all(1)).vertical, 4);
  });
  test('颜色解析、字体和原生图片提供者', () {
    expect('#f80'.axc.color, const Color(0xffff8800));
    expect('ff880080'.axc.color, const Color(0x80ff8800));
    for (final invalid in ['', '##fff', '12345', 'xyz']) {
      expect(invalid.axc.color, isNull);
    }
    expect(const Color(0xffffffff).axc.isLight(), isTrue);
    expect(const Color(0xff000000).axc.isLight(), isFalse);
    expect(() => const Color(0).axc.isLight(threshold: double.nan),
        throwsArgumentError);
    expect(() => (-1).axc.font(), throwsArgumentError);
    expect(() => double.infinity.axc.font(), throwsArgumentError);
    expect('logo.png'.axc.assetImage().assetName, 'logo.png');
    expect(AxcImage.asset('logo.png').assetName, 'logo.png');
    expect(AxcImage.network(Uri.parse('https://example.org/a.png')).url,
        'https://example.org/a.png');
    final bytes = Uint8List.fromList([1, 2]);
    expect(identical(AxcImage.memory(bytes).bytes, bytes), isTrue);
    expect(() => AxcImage.memory(bytes, scale: 0), throwsArgumentError);
  });
}
