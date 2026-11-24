import 'dart:math';

/// Map 的命名空间；保留键值类型，操作返回浅拷贝。
extension type AxcMapSpace<K, V>(Map<K, V> base) {
  /// 读取值；键不存在或存储 null 时均返回 null，需区分时使用 hasKey。
  V? valueFor(K key) => base[key];

  /// 判断键是否存在，包括值为 null 的键。
  bool hasKey(K key) => base.containsKey(key);

  /// 总项数，或符合条件的项数。
  int count([bool Function(MapEntry<K, V>)? where]) =>
      where == null ? base.length : base.entries.where(where).length;

  /// 保留符合条件的键值对及原迭代顺序。
  Map<K, V> filter(bool Function(K, V) predicate) => {
        for (final entry in base.entries)
          if (predicate(entry.key, entry.value)) entry.key: entry.value,
      };

  /// 合并字典，重复键使用新字典的值。
  Map<K, V> append(Map<K, V> values) => {...base, ...values};

  /// 随机返回一个值，空字典返回 null。
  V? random({Random? random}) => base.isEmpty
      ? null
      : base.values.elementAt((random ?? Random()).nextInt(base.length));

  /// 删除随机键后的新字典；不修改原字典。
  Map<K, V> removeRandomKey({Random? random}) {
    final result = Map<K, V>.of(base);
    if (base.isNotEmpty) {
      result.remove(
          base.keys.elementAt((random ?? Random()).nextInt(base.length)));
    }
    return result;
  }
}

/// 为字典提供保留键值类型的唯一命名空间入口。
extension AxcMapNamespace<K, V> on Map<K, V> {
  /// 字典命名空间。
  AxcMapSpace<K, V> get axc => AxcMapSpace<K, V>(this);
}

/// 字符串键字典的专用能力。
extension AxcStringMapOperations<V> on AxcMapSpace<String, V> {
  /// 将所有键转为小写；转换后的重复键取迭代顺序中最后的值。
  Map<String, V> lowercaseAllKeys() =>
      {for (final entry in base.entries) entry.key.toLowerCase(): entry.value};
}
