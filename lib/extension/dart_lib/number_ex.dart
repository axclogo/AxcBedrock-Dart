part of axc_bedrock;

class AxcNumberSpace {
  AxcNumberSpace(num obj) {
    //构造方法
    this.base = obj;
  }

  num base = 0;
}

extension NumberExtension on num {
  AxcNumberSpace get axc {
    return AxcNumberSpace(this);
  }
}

// MARK: - 数据转换
extension NumberToTransform on AxcNumberSpace {
  ///将此值转换为二进制形式
  Uint8List? toBytes({Endian endian = Endian.big}) {
    Uint8List? uint8List;
    final data = ByteData(8);
    if (base is int) {
      data.setInt64(0, base.toInt(), endian);
      uint8List = data.buffer.asUint8List();
    } else if (base is double) {
      data.setFloat64(0, base.toDouble(), endian);
      uint8List = data.buffer.asUint8List();
    }
    return uint8List;
  }
}

// MARK: - 属性 & Api
extension NumberToApi on AxcNumberSpace {
  /// 返回任何整数类型的序数字符串
  ///
  /// ```dart
  /// 101.axc.ordinal(); // 101st
  /// 999218.axc.ordinal(); // 999218th
  /// ```
  String ordinal() {
    int intValue = base.toInt();
    final onesPlace = intValue % 10;
    final tensPlace = ((intValue / 10).floor()) % 10;
    if (tensPlace == 1) {
      return '${intValue}th';
    } else {
      switch (onesPlace) {
        case 1:
          return '${intValue}st';
        case 2:
          return '${intValue}nd';
        case 3:
          return '${intValue}rd';
        default:
          return '${intValue}th';
      }
    }
  }

  /// 确保该值位于指定范围内
  /// [min]..[max]。
  ///
  /// 如果该值在范围内，则返回该值；如果该值小于[min]，则返回[min]；
  /// 如果该值大于[max]，则返回[max]。
  ///
  /// ```dart
  /// print(10.axc.limitThan(min: 1, max: 100)) // 10
  /// print(0.axc.limitThan(min: 1, max: 100)) // 1
  /// print(500.axc.limitThan(min: 1, max: 100)) // 100
  /// 10.axc.limitThan(min: 100, max: 0) // 参数错误，代码将无法执行
  /// ````
  num limitThan({num min = 0, num? max}) {
    if (max != null && min > max) {
      throw ArgumentError(
        '无法将值强制转换为空范围：',
        '最大值$max小于最小值$min。',
      );
    }
    if (base < min) return min;
    if (max != null && base > max) return max;
    return base;
  }
}

/// 决策判断
extension NumberToGuard on AxcNumberSpace {
  /// 返回是否在[range]内
  bool isInRange(AxcRange<num> range) {
    return range.isContains(base);
  }
}
