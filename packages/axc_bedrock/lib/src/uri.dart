/// URI 命名空间，操作保留未修改的路径、查询和片段。
extension type AxcUriSpace(Uri base) {
  /// 查询参数，多值时取第一项；无值参数返回空字符串。
  Map<String, String> get parameters => {
        for (final entry in base.queryParametersAll.entries)
          entry.key: entry.value.isEmpty ? '' : entry.value.first,
      };

  /// 获取某个查询参数的第一项，不存在时返回 null。
  String? parametersValue({required String forKey}) => parameters[forKey];

  /// 追加查询参数，保留原有同名参数；自动编码新增参数。
  Uri append({required Map<String, String> parameters}) {
    if (parameters.isEmpty) return base;
    final added = Uri(queryParameters: parameters).query;
    return base.replace(
        query: base.query.isEmpty ? added : '${base.query}&$added');
  }

  /// 移除全部路径，保留查询参数和片段。
  Uri removeAllPath() => base.replace(path: base.hasAuthority ? '/' : '');
}

/// Uri 的唯一命名空间入口。
extension AxcUriNamespace on Uri {
  /// URI 命名空间。
  AxcUriSpace get axc => AxcUriSpace(this);
}
