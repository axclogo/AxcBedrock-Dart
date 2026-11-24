# axc_bedrock_flutter

AxcBedrock 的独立 Flutter 适配包，通过 `.axc` 使用原生几何、边距、颜色、字体和图片能力，同时导出纯 Dart 核心 API。

要求 Flutter >= 3.19 / Dart >= 3.3。当前为未发布的 2.0.0-dev.1。

本包随 Swift/Dart 两个项目完成这一阶段的整理，后续维护视实际使用情况而定。作者目前专注 [AxcAgentEngine](https://github.com/axclogo/AxcAgentEngine)；完整说明见 [作者的话](https://github.com/axclogo/AxcBedrock-Dart/blob/master/README.zh_CN.md#作者的话)。

## 本地接入

在应用的 pubspec.yaml 配置两个本地路径（依赖包自身的 overrides 不会被应用继承）：

```yaml
dependencies:
  axc_bedrock_flutter:
    path: ../AxcBedrock-Dart/packages/axc_bedrock_flutter
dependency_overrides:
  axc_bedrock:
    path: ../AxcBedrock-Dart/packages/axc_bedrock
```

```dart
import 'package:axc_bedrock_flutter/axc_bedrock_flutter.dart';
import 'package:flutter/painting.dart';

final size = const Size(100, 50).axc.aspectFit(const Size(50, 50));
final rect = const EdgeInsetsDirectional.only(start: 2, end: 3).axc.inset(
  rect: const Rect.fromLTWH(0, 0, 100, 50),
  direction: TextDirection.rtl,
);
final color = '#ff880080'.axc.color; // RRGGBBAA
final font = 16.axc.font(weight: FontWeight.bold);
final image = AxcImage.asset('assets/logo.png'); // 原生 AssetImage
```

几何有限性不等于布局有效性：允许负数和零；比例缩放明确要求源尺寸为正，防止除零和非有限结果。方向性 Insets 的内缩要求显式指定方向，不默认假设 LTR。

图片入口只创建原生 ImageProvider，不提前解码、不另建图片模型，也不掩盖平台的网络、解码和资源配置限制。MemoryImage 的输入字节由调用方保持不变。

`String.axc` 和数值 `.axc` 来自核心包；本包只给这些 Space 增加能力。可以同时导入核心包与 Flutter 包，不产生重复入口。

## 验证

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test example
flutter analyze --fatal-infos
flutter test
flutter pub publish --dry-run
```

本仓库开发使用 pubspec_overrides.yaml 指向同级的 axc_bedrock 包；发布包排除该文件并声明 hosted 核心依赖。正式发布必须先发布对应的 axc_bedrock 版本。

[MIT](LICENSE)。
