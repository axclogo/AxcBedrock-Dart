part of axc_bedrock;

class AxcMapSpace<Key, Value> {
  AxcMapSpace(Map<Key, Value> map) {
    //构造方法
    this.base = map;
  }
  Map<Key, Value> base = {};
}

extension MapExtension<Key, Value> on Map<Key, Value> {
  AxcMapSpace get axc {
    return AxcMapSpace(this);
  }
}

/// 数据转换
extension MapToTransform<Key, Value> on AxcMapSpace<Key, Value> {}

/// 属性 & Api
extension MapToApi<Key, Value> on AxcMapSpace<Key, Value> {
  ///返回给定键值[key]对应的值，如果[key]不在，则返回' null '
  Value? valueFor(Key key) {
    if (base[key] != null) {
      return base[key];
    }
    return null;
  }
}

/// 决策判断
extension MapToGuard<Key, Value> on AxcMapSpace<Key, Value> {}
