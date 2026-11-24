# 从 1.0.0 原型迁移

2.0.0-dev.1 是一次公开 API 整理，不保留仅用于旧原型的兼容层。

核心 package 移到 `packages/axc_bedrock`，Flutter 适配位于同级的 `packages/axc_bedrock_flutter`。本地或 Git 依赖需更新 package 路径；核心的公开 import 仍是 `package:axc_bedrock/axc_bedrock.dart`。

| 原型 API | 当前 API |
| --- | --- |
| `text.axc.keepPrefix(3)` | `text.axc.keepPrefix(count: 3)` |
| `text.axc.keepSuffix(3)` | `text.axc.keepSuffix(count: 3)` |
| `text.axc.appendPrefix('x')` | `text.axc.appendPrefix(string: 'x')` |
| `text.axc.appendSuffix('x')` | `text.axc.appendSuffix(string: 'x')` |
| `removePrefixWithString` / `removeSuffixWithString` | `removePrefixString` / `removeSuffixString` |
| `removeSuffixWithCount(n)` | `removeSuffix(count: n)` |
| `substring(start, inclusiveEnd)` | `substring(start: start, end: exclusiveEnd)`，终点改为不包含 |
| `substringWithRange(range)` | 仍使用闭区间，包含 `range.endInclusive` |
| `splitStartToEnd` | `splitBetween(start: ..., end: ...)` |
| `splitWithSeparator` | `split(separator: ...)` |
| `replaceWithString` / `replaceWithStrings` | `replacing` / `replacingStrings` |
| `toUtf8()` | `data`，返回 `Uint8List` |
| `urlEncode()` / `urlDecode()` | `urlEncodedString` / `urlDecodedString`，明确为 URL 组件编解码 |
| `limitThan(min: ..., max: ...)` | `clamped(min: ..., max: ...)`，要求两个有效边界 |
| `isJSONString` | `isJsonString`，遵循 Dart 缩写命名习惯 |
| `AxcRange.isContains` | `AxcRange.contains` |
| `map.axc.filter((entry) => ...)` | `map.axc.filter((key, value) => ...)` |

`asInt`、`asDouble`、`asBool` 提供可选转换；需要抛错的解析可以直接使用 Dart 原生 parse。
原型中存在错误或没有明确语义的 emoji 正则、字符集合正则拼接等方法未保留。

行为变化：

- String 的索引、截取长度按字素簇计算，避免拆开 emoji、旗帜与组合字符。
- List/Map 的返回值保留泛型；不再从 `.axc` 得到隐式 dynamic。
- `base` 只能读取，不能重新赋值；底层 List/Map 仍可能由其他引用修改。集合操作返回浅拷贝，不复制元素对象。
- 负的截取数量抛出 ArgumentError；位置读取越界返回 null；集合 replace/move 越界返回原集合拷贝。
- `List.axc.filter(by:)` 对称 Swift 的排除语义，true 表示移除；保留匹配项使用 `.axc.where(...)`。
- 区间构造拒绝反向边界和 NaN，闭区间包含两端。通用 Range 使用 Comparable.compareTo 的顺序。
- `.axc.clamped` 保留 NaN，区别于 Dart 原生 num.clamp 的 NaN 比较规则。
- once 只保证当前 isolate 内的一次进入，抛错后仍占用令牌；异步共享结果请使用 `package:async` 的 AsyncMemoizer。
- 关联值采用 `key.set(owner, value)`、`key.getObject(owner)`、`key.remove(owner)`，保持键自身的类型约束。
- `Uint8List.axc` 选择数据命名空间；需要列表能力时用 `AxcListSpace<int>(bytes)`，不依赖 dynamic 分派。

Flutter 已拆为独立 package。只使用 `axc_bedrock` 时，不需要 Flutter SDK，也不会导入 `dart:ui`。
