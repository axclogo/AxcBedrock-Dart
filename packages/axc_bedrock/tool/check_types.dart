import 'dart:io';

/// 验证正向类型契约，并确认错误调用确实被编译器拒绝。
Future<void> main() async {
  final config = File('.dart_tool/package_config.json').absolute.path;
  final temp = Directory.systemTemp.createTempSync('axc-type-contracts-');
  const snippets = <String, (bool, String)>{
    'typed_access': (
      true,
      '''
      final int? item = <int>[1].axc.objectAt(0);
      final Map<String, int> map = <String, int>{'a': 1}.axc.filter((k, v) => v > 0);
      final int bounded = 2.axc.clamped(min: 0, max: 1);
      final double decimal = 0.5.axc.clamped(min: 0.0, max: 1.0);
      final key = AxcAssociationKey<int>();
      key.set(Object(), null);
      print([item, map, bounded, decimal]);
    '''
    ),
    'wrong_element': (
      false,
      'final String? value = <int>[1].axc.objectAt(0); print(value);'
    ),
    'wrong_key': (false, "<String, int>{'a': 1}.axc.valueFor(1);"),
    'wrong_association': (
      false,
      "AxcAssociationKey<int>().set(Object(), 'wrong');"
    ),
    'wrong_numeric_bound': (false, '1.axc.clamped(min: 0.0, max: 2.0);'),
    'flutter_not_in_core': (false, "print('ff0000'.axc.color);"),
  };
  try {
    for (final entry in snippets.entries) {
      final file = File('${temp.path}/${entry.key}.dart')
        ..writeAsStringSync(
          "import 'package:axc_bedrock/axc_bedrock.dart';\nvoid main() { ${entry.value.$2} }\n",
        );
      final result = await Process.run(Platform.resolvedExecutable, [
        'compile',
        'kernel',
        '--packages=$config',
        file.path,
        '-o',
        '${temp.path}/${entry.key}.dill',
      ]);
      if ((result.exitCode == 0) != entry.value.$1) {
        throw StateError(
            '${entry.key}: unexpected compiler result\n${result.stdout}\n${result.stderr}');
      }
      stdout.writeln('PASS: ${entry.key}');
    }
  } finally {
    temp.deleteSync(recursive: true);
  }
}
