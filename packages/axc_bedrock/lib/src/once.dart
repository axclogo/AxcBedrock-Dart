/// 每个实例在当前 isolate 内最多进入一次同步闭包。
/// 首次调用执行并返回 true；重入或后续调用返回 false，不提供重置。
/// 不协调多个 isolate；传入异步闭包不会等待其完成，应使用 async 包的 AsyncMemoizer。
final class AxcOnce {
  bool _hasStarted = false;

  /// 创建独立令牌；需要共享时将其保存在字段或静态字段中。
  AxcOnce();

  /// 执行前占用令牌；异常原样传播，异常后也不再次执行。
  bool run(void Function() body) {
    if (_hasStarted) return false;
    _hasStarted = true;
    body();
    return true;
  }
}
