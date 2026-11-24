# AxcBedrock for Dart

通过 `value.axc.operation` 统一基础能力的调用入口，保留 Dart 的类型安全与原生返回值。
与 [Swift 版](https://github.com/axclogo/AxcBedrock-Swift) 在语言允许的范围内对齐通用能力，具体差异见 [API 对照](https://github.com/axclogo/AxcBedrock-Dart/blob/master/doc/api-parity.md)。

当前为 **2.0.0-dev.1 开发版本，尚未发布到 pub.dev**。它整理了早期 1.0.0 原型，不兼容部分旧 API，见 [迁移说明](https://github.com/axclogo/AxcBedrock-Dart/blob/master/doc/migration.md)。

本包随 Swift/Dart 两个项目完成这一阶段的整理，后续维护视实际使用情况而定。作者目前专注 [AxcAgentEngine](https://github.com/axclogo/AxcAgentEngine)；完整说明见 [作者的话](https://github.com/axclogo/AxcBedrock-Dart/blob/master/README.zh_CN.md#作者的话)。

## 包结构与要求

| Package | 内容 | 最低要求 |
| --- | --- | --- |
| `axc_bedrock` | 字符串、集合、数值、日期、URI、数据编码/摘要、关联值、once | Dart 3.3 |
| [`axc_bedrock_flutter`](https://github.com/axclogo/AxcBedrock-Dart/tree/master/packages/axc_bedrock_flutter) | 几何、Insets、颜色、字体、原生图片提供者 | Flutter 3.19 / Dart 3.3 |

核心包不依赖 Flutter、dart:ui 或 dart:io。使用 extension type 提供无额外包装对象的命名空间。
Flutter 包扩展同一套 String/Number Space，不重复定义 `.axc`。

## 本地接入

开发版可在使用方的 `pubspec.yaml` 中加入本地路径：

```yaml
dependencies:
  axc_bedrock:
    path: ../AxcBedrock-Dart/packages/axc_bedrock
```

然后执行 `dart pub get` 并导入公开入口，勿导入 `lib/src`：

```dart
import 'package:axc_bedrock/axc_bedrock.dart';

void main() {
  final text = '你好👨‍👩‍👧‍👦'.axc.keepPrefix(count: 2, suffix: '…');
  final int? item = <int>[10, 20].axc.objectAt(1);
  final groups = [1, 2, 3, 4, 5].axc.chunked(by: 2);
  final int bounded = 12.axc.clamped(min: 0, max: 10);
  final map = {'a': 1, 'b': 2}.axc.filter((key, value) => value > 1);
  print([text, item, groups, bounded, map]);
}
```

完整的可运行示例见 [example/main.dart](example/main.dart)。

## 行为约定

- **保留类型**：`List<T>`、`Map<K,V>`、`int`、`double` 通过 `.axc` 后保留类型信息；不使用 dynamic 转发。
- **无状态入口**：Space 是宿主值的静态视图，不存储缓存、执行记录或资源所有权。`base` 不可重新赋值，但底层集合不因此变成不可变对象。
- **返回原生值**：列表、字典操作返回浅拷贝；元素对象不深拷贝。操作结果可继续 `.axc`，也可直接使用 Dart API。
- **字符语义**：字符串位置、长度、截取使用 `characters` 的字素簇，避免拆分组合字符和 emoji。普通字面匹配/替换仍遵循 Dart String 的文本匹配规则。
- **范围语义**：`substring`/`subArray` 使用半开区间，`AxcRange` 是有序闭区间；负截取数量抛错，安全索引越界返回 null。
- **过滤语义**：为对称 Swift，`list.axc.filter(by:)` 的 true 表示排除；保留匹配项使用 `list.axc.where(...)`。Map 的 filter 保留 true 项。
- **数值边界**：`.axc.clamped` 保留 NaN，禁止 NaN/反向边界。大整数、字节转换和浮点精度遵循 Dart 目标平台，不能据此承诺 VM/Web 的任意 64 位整数完全等价。
- **日期语义**：区分日历天数和固定 Duration；星期按 Dart 周一=1。intl 格式化的地区数据由应用初始化，不隐式加载所有地区。
- **依赖策略**：字素簇、摘要、日期格式和路径规则分别委托 `characters`、`crypto`、`intl`、`path`，不自写替代算法。

## 关联值与一次性执行

```dart
final owner = Object();
final titleKey = AxcAssociationKey<String>();
titleKey.set(owner, 'AxcBedrock');
final String? title = titleKey.getObject(owner);
titleKey.remove(owner);

final delegateKey = AxcAssociationKey<Object>.weak();
// 弱键的值须是 WeakReference 支持的对象；GC 归零时机不确定。

final once = AxcOnce();
once.run(() => print('执行一次'));
once.run(() => print('不会执行'));
```

关联值使用 `Expando`。宿主须为支持该机制的普通 Dart 对象，不能是数值、字符串、布尔值、record 或 FFI 类型。无效宿主会抛错，不转成全局 Map 长期持有。关联键应保存为字段或静态字段。Key 的实例方法直接绑定值类型；不模拟 Swift Runtime 的所有方法。

`AxcOnce` 仅协调**当前 isolate 内同一实例**。闭包执行前即占用令牌，重入返回 false，异常原样传播且不重试。只用于同步闭包；Dart 允许将异步函数赋给 void 回调，但此 API 不等待 Future。需要异步一次执行并共享结果时使用 `package:async` 的 `AsyncMemoizer`。

`dynamic` 不支持静态扩展查找，应先恢复具体类型。`Uint8List.axc` 使用数据命名空间；要使用列表能力，可显式构造 `AxcListSpace<int>(bytes)`。

## Flutter

参见 [Flutter package 接入说明](https://github.com/axclogo/AxcBedrock-Dart/blob/master/packages/axc_bedrock_flutter/README.md)。几何与绘制适配保持原生类型，方向性边距必须显式指定文字方向。

```dart
import 'package:axc_bedrock_flutter/axc_bedrock_flutter.dart';
import 'package:flutter/painting.dart';

final fitted = const Size(100, 50).axc.aspectFit(const Size(50, 50));
final horizontal = const EdgeInsetsDirectional.only(start: 2, end: 3).axc.horizontal;
final color = '#ff8800'.axc.color;
final font = 16.axc.font(weight: FontWeight.bold);
```

## 开发与验证

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

Flutter 适配包单独验证：

```sh
cd ../axc_bedrock_flutter
flutter pub get
flutter analyze --fatal-infos
flutter test
```

CI 覆盖最低工具链和最新 stable；本地验证结果不会替代尚未运行的远端 CI。测试包含错误类型必须编译失败的反例，以及 [共享 Swift/Dart 用例](test/fixtures/parity.json)。

正式发布前，应更新版本和 CHANGELOG，完成测试与 dry-run，先发布核心包，再发布依赖它的 Flutter 包。Flutter 包通过 `pubspec_overrides.yaml` 在本仓库开发，该文件不进入发布包；普通使用方不会继承依赖包的 overrides。

## 参与开发

新增 API 应遵循 [CONTRIBUTING.md](https://github.com/axclogo/AxcBedrock-Dart/blob/master/CONTRIBUTING.md)，明确对应能力、类型、返回值、错误与边界语义，并更新能力对照表。原生机制不适合的能力不做伪适配。

## License

[MIT](LICENSE)。
