import 'package:axc_bedrock_flutter/axc_bedrock_flutter.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const Example());

/// 使用命名空间创建原生 Flutter 值的最小示例。
class Example extends StatelessWidget {
  /// 创建示例组件。
  const Example({super.key});

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text(
            'AxcBedrock 的统一入口'.axc.keepPrefix(count: 12),
            style: 20.axc.font().copyWith(color: '#ff8800'.axc.color),
          ),
        ),
      );
}
