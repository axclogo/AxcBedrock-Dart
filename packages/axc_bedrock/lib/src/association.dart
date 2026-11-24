/// 弱引用对象持有者；不保证垃圾回收或归零的具体时机。
final class AxcWeakObj<T extends Object> {
  /// 创建弱引用；目标不能是数值、字符串、布尔值或 record。
  AxcWeakObj(T object) : _reference = WeakReference<T>(_checkTarget(object));
  final WeakReference<T> _reference;

  /// 目标仍存活时返回对象，回收后返回 null。
  T? get object => _reference.target;
}

T _checkTarget<T extends Object>(T object) {
  if (object is num || object is String || object is bool || object is Record) {
    throw ArgumentError.value(object, 'object', '需要具有稳定身份的普通 Dart 对象');
  }
  return object;
}

/// 类型化关联键，以键实例和宿主身份区分，使用 Dart Expando 管理存储。
/// 键应保存为字段或静态字段；使用实例方法保持值类型，不通过静态泛型推断扩宽类型。
final class AxcAssociationKey<T extends Object> {
  /// 创建强持有关联值的键；宿主不可达后不再保留关联值。
  AxcAssociationKey() : _weak = false;

  /// 创建弱持有关联值的键；值必须是 WeakReference 支持的对象。
  AxcAssociationKey.weak() : _weak = true;
  final bool _weak;
  final Expando<Object> _storage = Expando<Object>();

  /// 写入关联值；null 仅移除此键。宿主须为 Expando 支持的普通 Dart 对象。
  void set(Object object, T? value) {
    _checkTarget(object);
    if (value == null) {
      _storage[object] = null;
    } else if (_weak) {
      _storage[object] = AxcWeakObj<T>(value);
    } else {
      _storage[object] = value;
    }
  }

  /// 获取关联值；不存在或弱引用已回收时返回 null。
  T? getObject(Object object) {
    final value = _storage[_checkTarget(object)];
    return _weak ? (value as AxcWeakObj<T>?)?.object : value as T?;
  }

  /// 仅移除此键对应的关联，不影响其他键。
  void remove(Object object) {
    _storage[_checkTarget(object)] = null;
  }
}
