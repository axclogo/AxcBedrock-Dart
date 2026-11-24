# AxcBedrock for Dart

![Language: Dart](./ReadmeSource/badges/language.svg)
[![License: MIT](./ReadmeSource/badges/license.svg)](./LICENSE)
[![SDK: Dart 3.3+ | Flutter 3.19+](./ReadmeSource/badges/platform.svg)](./packages/axc_bedrock/pubspec.yaml)
![Axc: Kit](./ReadmeSource/badges/axc.svg)

[CI / GitHub Actions](https://github.com/axclogo/AxcBedrock-Dart/actions/workflows/ci.yml)

# 语言

- en [English](./README.md)
- zh_CN [简体中文](./README.zh_CN.md)

# 介绍

![bedrock](./ReadmeSource/bedrock.png)

AxcBedrock 是一个基础工具库。像 Minecraft 中的基岩一样，希望给日常开发的小操作提供一层稳定的基础。

核心想法是打通不同语言中的调用习惯：在原生值后输入 `.axc`，找到常用操作，得到原生类型的结果。Dart 版保留集合和数值的泛型信息，字符串索引按字素簇处理，让这些小功能有明确的类型、边界和测试。

## Swift 与 Dart

[AxcBedrock-Swift](https://github.com/axclogo/AxcBedrock-Swift) 面向 iOS 和 macOS；本仓库提供纯 Dart 核心，以及独立的 Flutter 几何与绘制辅助包。

两者共用 `value.axc.operation` 的调用习惯，在语言允许的范围内对齐通用能力，保留原生类型与平台差异。Dart 版不会逐项复刻 Apple framework 扩展，具体范围见 [API 对照](doc/api-parity.md)。

当前为 **2.0.0-dev.1 开发版，尚未发布到 pub.dev**。本次不保留早期原型的全部 API，已有使用方请查看 [迁移说明](doc/migration.md)。

# 作者的话

终于有空，借助 Codex 给 AxcBedrock 的 Swift 和 Dart 两个版本做了一轮收尾，把这一阶段的小功能、示例、测试和文档整理成一个闭环，也算没有让当初的想法一直烂尾。

到了 AI 时代，我也不确定这样的基础工具库还剩下多少价值。先把自己想做的事情做完，给过去的投入一个交代；如果恰好还能帮到别人，就更好了。

目前主要精力放在 Agent 相关研究上，正在做 [AxcAgentEngine](https://github.com/axclogo/AxcAgentEngine)。这两个库暂时以当前范围收尾，不承诺持续更新；以后如果用的人多、出现明确需求，再考虑继续维护。

# 安装

| Package | 职责 | 最低要求 |
| --- | --- | --- |
| [axc_bedrock](packages/axc_bedrock) | 字符串、集合、数值、日期、URI、字节/摘要、关联值、once | Dart 3.3 |
| [axc_bedrock_flutter](packages/axc_bedrock_flutter) | 几何、Insets、颜色、字体、原生图片提供者 | Flutter 3.19 / Dart 3.3 |

两个标准 package 并列、分别测试和发布。仓库根目录不是 package；核心不依赖 Flutter、dart:ui 或 dart:io。

克隆仓库后，在使用方的 `pubspec.yaml` 中配置本地路径，再执行 `dart pub get`：

```yaml
dependencies:
  axc_bedrock:
    path: ../AxcBedrock-Dart/packages/axc_bedrock
```

路径需按本地目录调整。Flutter 使用方请按 [Flutter 包接入说明](packages/axc_bedrock_flutter/README.md) 配置依赖和本地 override。

# 用法

## 格式与规范

```dart
// 实例功能调用
value.axc.operation
// 静态工具使用独立类型，例如
AxcBool.createOptional('true')
```

`.axc` 使用 extension type，不产生额外包装对象；List、Map、int、double 保留类型。更多能力放在对应 Space 中，应用只导入公开入口。

## 调用示例

```dart
import 'package:axc_bedrock/axc_bedrock.dart';

void main() {
  final int? item = <int>[10, 20].axc.objectAt(1);
  final text = '你好👨‍👩‍👧‍👦'.axc.keepPrefix(count: 2, suffix: '…');
  final groups = [1, 2, 3, 4, 5].axc.chunked(by: 2);
  final int bounded = 12.axc.clamped(min: 0, max: 10);
  print([item, text, groups, bounded]);
}
```

集合操作返回浅拷贝。为对称 Swift，`list.axc.filter(by:)` 排除 true 项，保留匹配项用 `where`。`AxcOnce` 仅协调当前 isolate 内同一实例的同步闭包；关联值使用类型化 Key 和原生 Expando/WeakReference。Flutter 图片直接返回原生 ImageProvider。

完整行为约定和示例见 [核心包 README](packages/axc_bedrock/README.md) 与 [Flutter 包 README](packages/axc_bedrock_flutter/README.md)。

# 开发与验证

在 `packages/axc_bedrock` 中执行：

```sh
dart pub get
dart format --output=none --set-exit-if-changed lib test example tool
dart analyze --fatal-infos
dart test
dart run example/main.dart
dart run tool/check_types.dart
mkdir -p build
dart compile js tool/web_smoke.dart -o build/web_smoke.js
node build/web_smoke.js
dart pub publish --dry-run
```

在 `packages/axc_bedrock_flutter` 中执行：

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test example
flutter analyze --fatal-infos
flutter test
flutter pub publish --dry-run
```

CI 配置最低工具链与 stable 两组检查。核心测试包含编译期反例、Web 冒烟测试及 [Swift/Dart 共享行为样例](packages/axc_bedrock/test/fixtures/parity.json)。CI 的实际结果请查看 Actions。

正式发布前更新各包 CHANGELOG 并完成预检，先发布核心，再发布 Flutter 包。Flutter 的 `pubspec_overrides.yaml` 仅供仓库开发且不进入发布包；应用不会继承它，需要按接入说明配置。没有自动发布任务。

# 问题与贡献

欢迎提交带复现示例的 [Issue](https://github.com/axclogo/AxcBedrock-Dart/issues)、范围明确的修复和测试。新增能力遵循 [CONTRIBUTING.md](CONTRIBUTING.md)，并更新 API 对照。后续维护取决于实际使用情况和时间安排，不承诺固定响应或发版节奏。

# 联系

E-mail：axclogo@163.com

# 许可证

[MIT](LICENSE)。如果这个库帮到了你，欢迎留个 Star，也让我知道还有人在用。
