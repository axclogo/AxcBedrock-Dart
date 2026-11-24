import 'dart:math' as math;
import 'package:flutter/painting.dart';

/// 点的命名空间，对应 Swift CGPoint 的常用操作。
extension type AxcOffsetSpace(Offset base) {
  /// 两个坐标是否有限。
  bool get isFinite => base.dx.isFinite && base.dy.isFinite;

  /// 两坐标中的较大值。
  double get bigger => math.max(base.dx, base.dy);

  /// 两坐标中的较小值。
  double get smaller => math.min(base.dx, base.dy);

  /// 两点的欧氏距离。
  double distance({required Offset to}) => (base - to).distance;

  /// 坐标分别向上取整，保留非有限值。
  Offset get ceilUp => Offset(base.dx.ceilToDouble(), base.dy.ceilToDouble());

  /// 坐标分别向下取整，保留非有限值。
  Offset get floorDown =>
      Offset(base.dx.floorToDouble(), base.dy.floorToDouble());

  /// 返回替换指定坐标的新点。
  Offset set({double? x, double? y}) => Offset(x ?? base.dx, y ?? base.dy);
}

/// Offset 的唯一入口。
extension AxcOffsetNamespace on Offset {
  /// 点命名空间。
  AxcOffsetSpace get axc => AxcOffsetSpace(this);
}

/// 尺寸命名空间，对应 Swift CGSize 的常用操作。
extension type AxcSizeSpace(Size base) {
  /// 宽高是否有限，允许零和负数，不代表可作为布局尺寸或除数。
  bool get isFinite => base.width.isFinite && base.height.isFinite;

  /// 位于原点的矩形。
  Rect get rect => Offset.zero & base;

  /// 两尺寸相加。
  Size add({required Size size}) =>
      Size(base.width + size.width, base.height + size.height);

  /// 两尺寸相减。
  Size subtract({required Size size}) =>
      Size(base.width - size.width, base.height - size.height);

  /// 加上 Insets 的水平与垂直总量。
  Size addInsets(EdgeInsetsGeometry edge) => edge.inflateSize(base);

  /// 减去 Insets 的水平与垂直总量。
  Size subtractInsets(EdgeInsetsGeometry edge) => edge.deflateSize(base);

  /// 整体缩放。
  Size scale(double factor) => Size(base.width * factor, base.height * factor);

  /// 宽高中的较大值。
  double get bigger => math.max(base.width, base.height);

  /// 宽高中的较小值。
  double get smaller => math.min(base.width, base.height);

  /// 宽高分别向上取整。
  Size get ceilUp =>
      Size(base.width.ceilToDouble(), base.height.ceilToDouble());

  /// 宽高分别向下取整。
  Size get floorDown =>
      Size(base.width.floorToDouble(), base.height.floorToDouble());

  /// 等比放入边界；源尺寸必须有限且为正，边界必须有限且非负。
  Size aspectFit(Size bounds) => _aspect(bounds, false);

  /// 等比覆盖边界，尺寸要求同 aspectFit。
  Size aspectFill(Size bounds) => _aspect(bounds, true);
  Size _aspect(Size bounds, bool fill) {
    if (!isFinite ||
        base.width <= 0 ||
        base.height <= 0 ||
        !bounds.axc.isFinite ||
        bounds.width < 0 ||
        bounds.height < 0) {
      throw ArgumentError('源尺寸必须有限且为正，边界必须有限且非负');
    }
    final x = bounds.width / base.width;
    final y = bounds.height / base.height;
    final factor = fill ? math.max(x, y) : math.min(x, y);
    final result = scale(factor);
    if (!result.axc.isFinite) throw ArgumentError('缩放结果超出有限范围');
    return result;
  }
}

/// Size 的唯一入口。
extension AxcSizeNamespace on Size {
  /// 尺寸命名空间。
  AxcSizeSpace get axc => AxcSizeSpace(this);
}

/// 矩形命名空间，对应 Swift CGRect 的常用操作。
extension type AxcRectSpace(Rect base) {
  /// 坐标及尺寸是否有限；允许负尺寸，布局是否为空请使用系统 isEmpty。
  bool get isFinite =>
      base.isFinite && base.width.isFinite && base.height.isFinite;

  /// 矩形中心。
  Offset get center => base.center;

  /// 返回替换指定分量的矩形。
  Rect set({double? x, double? y, double? width, double? height}) =>
      Rect.fromLTWH(x ?? base.left, y ?? base.top, width ?? base.width,
          height ?? base.height);

  /// 保持左上角，缩放宽高。
  Rect scale(double factor) => scaleAxes(width: factor, height: factor);

  /// 保持左上角，分别缩放宽高。
  Rect scaleAxes({required double width, required double height}) =>
      set(width: base.width * width, height: base.height * height);

  /// 等比放入目标矩形并居中，尺寸要求见 Size.axc.aspectFit。
  Rect aspectFit(Rect bounds) => _aspect(bounds, false);

  /// 等比覆盖目标矩形并居中，尺寸要求见 Size.axc.aspectFill。
  Rect aspectFill(Rect bounds) => _aspect(bounds, true);
  Rect _aspect(Rect bounds, bool fill) {
    if (!isFinite || !bounds.axc.isFinite) throw ArgumentError('矩形必须有限');
    final size = fill
        ? base.size.axc.aspectFill(bounds.size)
        : base.size.axc.aspectFit(bounds.size);
    final result = Rect.fromCenter(
        center: bounds.center, width: size.width, height: size.height);
    if (!result.axc.isFinite) throw ArgumentError('结果边界溢出');
    return result;
  }
}

/// Rect 的唯一入口。
extension AxcRectNamespace on Rect {
  /// 矩形命名空间。
  AxcRectSpace get axc => AxcRectSpace(this);
}

/// Insets 命名空间，同时支持绝对边距与方向性边距。
extension type AxcEdgeInsetsSpace(EdgeInsetsGeometry base) {
  /// 左右方向的总量。
  double get horizontal => base.horizontal;

  /// 上下方向的总量。
  double get vertical => base.vertical;

  /// 逐边相加，保留方向性。
  EdgeInsetsGeometry add({required EdgeInsetsGeometry edge}) => base.add(edge);

  /// 逐边相减，保留方向性。
  EdgeInsetsGeometry subtract({required EdgeInsetsGeometry edge}) =>
      base.subtract(edge);

  /// 同时增加左右边距。
  EdgeInsetsGeometry addHorizontal(double value) =>
      base.add(EdgeInsets.symmetric(horizontal: value));

  /// 同时增加上下边距。
  EdgeInsetsGeometry addVertical(double value) =>
      base.add(EdgeInsets.symmetric(vertical: value));

  /// 逐边缩放。
  EdgeInsetsGeometry scale(double factor) => base * factor;

  /// 交换相对的边。
  EdgeInsetsGeometry get flipped => base.flipped;

  /// 向内计算矩形；方向必须显式指定，过大边距遵循 Flutter 的负尺寸语义。
  Rect inset({required Rect rect, required TextDirection direction}) =>
      base.resolve(direction).deflateRect(rect);
}

/// 所有 Insets 共用的唯一入口，不重复定义方向性类型入口。
extension AxcEdgeInsetsNamespace on EdgeInsetsGeometry {
  /// 边距命名空间。
  AxcEdgeInsetsSpace get axc => AxcEdgeInsetsSpace(this);
}
