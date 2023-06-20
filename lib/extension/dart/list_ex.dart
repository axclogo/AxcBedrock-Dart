part of axc_bedrock;

class AxcListSpace<Element> {
  AxcListSpace(List<Element> list) {
    //构造方法
    this.base = list;
  }
  List<Element> base = [];
}

extension ListExtension<Element> on List<Element> {
  AxcListSpace get axc {
    return AxcListSpace(this);
  }
}

/// 数据转换
extension ListToTransform<Element> on AxcListSpace<Element> {}

/// 属性 & Api
extension ListToApi<Element> on AxcListSpace<Element> {
  ///返回给定[index]处的元素，如果[index]不在，则返回' null '
  Element? objectAt(int index) {
    if (index < 0) return null;
    if (index >= base.length) return null;
    return base[index];
  }
}

/// 决策判断
extension ListToGuard<Element> on AxcListSpace<Element> {
  /// 判断索引是否越界 越界为真
  bool isCrossing(int idx) {
    return !((idx >= 0) && (base.length > idx));
  }
}
