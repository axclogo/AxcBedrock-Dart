# Swift / Dart 能力对照

目标是稳定的 `value.axc.operation` 入口、对称的公共能力和明确的行为。各语言使用自己的类型系统与命名规则，不逐行翻译 Swift 实现。

以下对照以 AxcBedrock-Swift `8a8e1c5` 为基准。此版本覆盖下列通用能力，不宣称覆盖 Swift 仓库全部 framework 扩展。

## 通用核心

| Swift 能力 | Dart 入口 | 状态/约定 |
| --- | --- | --- |
| `.axc` / `Type.Axc` | `.axc`；静态工具使用 `AxcBool`、`AxcDate` 等 | 实例入口对称；Dart 不能通过普通 extension 添加原生类型静态成员 |
| Array 安全访问、前后五项 | `list.axc.objectAt`、`first/second/.../lastFifth` | 已实现，越界 null |
| append / insert / remove / replace / move | `list.axc` 同名操作 | 已实现；返回浅拷贝，insert 限制边界，replace/move 无效时保持原值 |
| 条件查找、计数、反向/带索引遍历 | `object`、`index`、`count`、`isContent`、`forEachReversed`、`forEachEnumerated` | 已实现 |
| Array filter(by:) | `list.axc.filter(by:)` | 已实现，true 表示移除；另有 where 提供 Dart 的保留语义 |
| 截取、前后缀、分块 | `subArray`、`prefix`、`suffix`、`chunked` | 已实现，切片半开；不复刻 Swift 非法范围可能崩溃的行为 |
| 去重、重复项、包含检查 | `removeRepeat`、`duplicates`、`containsDuplicates`、`contains` | 已实现；去重保留顺序，依赖 Dart 相等性/hashCode 契约 |
| 求和、字符串拼接和排空 | `sum`、`joint`、`jointString`、`filterEmpty` | 已实现；int/double 求和保留结果类型 |
| 按字段升降序与字典序 | `sortByAscend`、`sortByDescend`、`sortByLexicographical` | 已实现；用选择器替代 Swift KeyPath，排序稳定 |
| Dictionary 查询、合并、过滤、小写键、随机项 | `map.axc.valueFor/hasKey/append/filter/lowercaseAllKeys/random/removeRandomKey` | 已实现；重复小写键取最后值，null 值用 hasKey 区分 |
| String 字符访问、前后缀、大小写、修剪 | `stringAt`、`substring`、`keep/remove/appendPrefix/Suffix`、`uppercased`、`camelCased`、`trimmed` | 已实现，字素簇单位；文字删除用 removePrefixString/removeSuffixString |
| 字符串分隔、替换、计数、正则判断 | `split`、`splitBetween`、`replacing`、`replacingStrings`、`count`、`regexEscaped`、`isConform` | 已实现；文字替换不隐式解释为正则 |
| 字符串转换、UTF-8、Base64、hex、URL 组件 | `asInt/asDouble/asBool`、`data`、`base64Data`、`hexData` 等 | 已实现，非法编码返回 null；URL 组件不等同完整 URL |
| 路径分量、扩展名、拼接 | `lastPathComponent/pathExtension/appendPathComponent` | 已实现，显式使用 POSIX 路径规则，不访问文件系统 |
| Data 字节、编码、摘要、HMAC | `Uint8List.axc`、`String.axc.hashStr/hashData/hashBase64/hmacStr` | 已实现；委托 crypto，HMAC 修正 Swift 中的 hamc 拼写 |
| 数值范围、舍入、角度转换、字节表示 | `number.axc.clamped/rounded/angleToRadian/radianToAngle/toBytes` | 已实现；int/double 入口类型保留，整数精度遵循 Dart VM/Web |
| Range | `AxcRange<T>`、`AxcIntRange`、`AxcDoubleRange` | 已实现，有序闭区间；不模拟 Swift 的范围语法 |
| Bool 转换 | `AxcBool.create/createOptional`、`bool.axc` | 已实现，非有限数值拒绝转换 |
| Date 分量、日历天数、时间差、常用判断 | `DateTime.axc` | 已实现；星期采用 Dart 周一=1，固定时长与日历加减明确区分 |
| Date 格式化/解析 | `date.axc.string`、`AxcDate.createOptional` | 已实现；委托 intl，地区数据由应用初始化；不保证 Apple 全格式符等价 |
| URL 参数与移除路径 | `Uri.axc.parameters/parametersValue/append/removeAllPath` | 已实现；追加保留重复键，单值读取第一项 |
| 关联值、弱引用 | `AxcAssociationKey<T>`、`AxcWeakObj<T>` | 原生适配 Expando/WeakReference；键实例提供读写，宿主限原生机制支持的对象 |
| 一次性执行 | `AxcOnce.run` | 当前 isolate 内实例级一次进入；不提供跨 isolate 共享锁 |

## Flutter 适配

| Swift 能力 | Flutter 入口 | 状态/约定 |
| --- | --- | --- |
| CGPoint 距离、坐标、取整与有限性 | `Offset.axc` | 已实现 |
| CGSize 加减、缩放、Insets、等比布局 | `Size.axc` | 已实现；源比例尺寸必须有限且为正，不生成 NaN |
| CGRect 修改、中心、缩放、等比布局 | `Rect.axc` | 已实现；目标原点参与居中计算；有限性不代表非空 |
| Insets 总量、运算和矩形内缩 | `EdgeInsetsGeometry.axc` | 已实现；支持 directional，内缩必须显式传入 TextDirection |
| 颜色输入 | `String.axc.color`、`AxcColor.createOptional` | 已实现 RGB/RRGGBB/RRGGBBAA；非法值返回 null |
| 数字字号输入 | `number.axc.font` | 已实现，返回原生 TextStyle |
| 跨平台图片输入 | `AxcImage.asset/network/memory`、`String.axc.assetImage` | 返回 Flutter 原生 ImageProvider，不建立第二套图片对象 |

## 有意不迁移或未扩大的部分

- Objective-C 方法交换、类枚举、Selector、CF/NS 对象桥接：没有合适的 Dart 对等物，不提供伪实现。
- UIKit/AppKit 的控件事件代理、CALayer/CAAnimation、CoreImage 滤镜、MapKit/WebKit/AVFoundation：遵循 Flutter 组件和对应插件体系，不包装为虚假的一比一 API。
- GCD/线程锁和 Swift 属性包装器：Dart isolate、Future、Stream 与语言类型系统语义不同，不通过外观统一掩盖差异。
- 任意命名时区、非公历日历、系统本地化资源、拼音、完整 emoji 判定、RTF/HTML 富文本：尚未提供；需要专门的数据或平台能力，不用简化正则冒充完整实现。
- 文件、设备、应用生命周期、持久化缓存：本轮未迁移；应以实际平台需求独立适配，不能给纯 Dart/Web 核心引入 dart:io。
- 自定义权重排序、完整时间分量 builder、数百个 UI 便利方法：未承诺逐项对齐；本轮提供可自然对应的核心操作。

Swift 侧已有的 appendPrefix 方向、部分无效索引处理、aspectFill 目标原点等问题不复制到 Dart，且本次不修改 Swift 仓库。区分“业务能力对称”和“复刻实现缺陷”。

## 对称性验证

`packages/axc_bedrock/test/fixtures/parity.json` 是两端可读取的共享行为用例：Unicode 前后缀、列表安全访问/分块、NaN 和无穷区间限制。Dart 测试自动读取；`packages/axc_bedrock/tool/verify_swift_parity.swift` 可链接 Swift 仓库构建产物读取同一份文件。它验证这些用例，不代表全量 API 等价。

新增对应 API 时，应补充此表，并优先扩充共享用例。语言或平台导致差异时先写清契约，不靠方法名暗示不存在的保证。
