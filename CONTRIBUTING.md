# 参与开发

- 对原生类型仅提供 `.axc` 入口；更多能力放在相应 Space 内。extension type 无可变内部状态。
- 使用 Dart lowerCamelCase 方法名、显式泛型和中文公开注释，不使用 dynamic/noSuchMethod 模拟动态派发。
- 两个 package 并列放在 `packages/`；核心公开导出放包内 `lib/axc_bedrock.dart`，实现放 `lib/src`。纯 Dart 核心不导入 Flutter 或 dart:io。
- Flutter 适配是独立标准 package，扩展已有 Space，避免定义第二个 String/Number `.axc`。
- 集合操作默认返回原生集合浅拷贝；错误、空值、Unicode、范围终点和并发语义必须写清。
- 优先委托 Dart SDK/维护良好的基础包。统一入口可以保留薄适配，但不复制系统算法和框架。
- 为行为添加有意义的边界测试；添加到 `doc/api-parity.md`。能共享的语义补入 `packages/axc_bedrock/test/fixtures/parity.json`。
- 运行 README 中的 format、analyze、test、编译期契约、Web 检查；修改 Flutter 包还需运行 flutter analyze/test。
- 不在真实业务代码中导入 `src`；添加 public API 时确保普通 package import 即可使用并保留类型。
- 版本遵循语义化版本，开发中的破坏性调整记录在 CHANGELOG 和迁移说明；本仓库不自动发布。
