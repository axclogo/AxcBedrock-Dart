part of axc_bedrock;

class AxcMapSpace<Key, Value> {
  AxcMapSpace(Map<Key, Value> map) {
    // 构造方法
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
  /// 返回与给定[predicate]或数字匹配的条目数
  int count([bool Function(MapEntry<Key, Value>)? predicate]) {
    if (predicate == null) {
      return base.length;
    }
    var count = 0;
    final i = base.entries.iterator;
    while (i.moveNext()) {
      if (predicate(i.current)) {
        count++;
      }
    }
    return count;
  }

  /// 返回给定键值[key]对应的值，如果[key]不在，则返回' null '
  Value? valueFor(Key key) {
    if (base[key] != null) {
      return base[key];
    }
    return null;
  }

  /// 返回一个包含所有匹配给定[predicate]的键值对的新映射。
  /// 返回的map表保留原map表的表项迭代顺序。
  Map<Key, Value> filter(bool Function(MapEntry<Key, Value> entry) predicate) {
    final result = <Key, Value>{};
    for (final entry in base.entries) {
      if (predicate(entry)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

/// 决策判断
extension MapToGuard<Key, Value> on AxcMapSpace<Key, Value> {}
