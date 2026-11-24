# AxcBedrock for Dart

![Language: Dart](./ReadmeSource/badges/language.svg)
[![License: MIT](./ReadmeSource/badges/license.svg)](./LICENSE)
[![SDK: Dart 3.3+ | Flutter 3.19+](./ReadmeSource/badges/platform.svg)](./packages/axc_bedrock/pubspec.yaml)
![Axc: Kit](./ReadmeSource/badges/axc.svg)

[CI / GitHub Actions](https://github.com/axclogo/AxcBedrock-Dart/actions/workflows/ci.yml)

# Language

- en [English](./README.md)
- zh_CN [简体中文](./README.zh_CN.md)

# Introduction

![bedrock](./ReadmeSource/bedrock.png)

AxcBedrock is a library of everyday helpers. Like bedrock in Minecraft, it aims to provide a dependable foundation for small operations in application code.

The idea is to carry familiar calling conventions across languages: type `.axc` after a native value, find an operation, and get a native result. The Dart version preserves collection and numeric types and uses grapheme clusters for string indexing, with explicit behavior and tests for these small helpers.

## Swift and Dart

[AxcBedrock-Swift](https://github.com/axclogo/AxcBedrock-Swift) provides helpers for iOS and macOS. This repository provides a pure Dart core and a separate Flutter package for geometry and painting helpers.

Both share the `value.axc.operation` approach and align common capabilities where the languages allow it. They use native types and keep platform differences explicit; the Dart version does not reproduce every Apple framework extension. See the [API comparison](doc/api-parity.md).

The current version is **2.0.0-dev.1, not yet published to pub.dev**. Some prototype APIs have changed; existing users should read the [migration guide](doc/migration.md).

# A note from the author

I finally found some time to use Codex to wrap up this stage of both the Swift and Dart projects: bringing the small helpers, examples, tests, and documentation together, rather than leaving the original idea unfinished indefinitely.

In the AI era, I honestly do not know how much value libraries like these still have. Finishing what I set out to do gives me some closure. If it helps someone else along the way, even better.

My focus is now on Agent research and [AxcAgentEngine](https://github.com/axclogo/AxcAgentEngine). These two libraries will stay within their current scope for now, with no commitment to regular updates. If more people use them and clear needs emerge, I will consider continuing maintenance.

# Installation

| Package | Scope | Minimum requirements |
| --- | --- | --- |
| [axc_bedrock](packages/axc_bedrock) | Strings, collections, numbers, dates, URI, bytes/digests, associated values, once | Dart 3.3 |
| [axc_bedrock_flutter](packages/axc_bedrock_flutter) | Geometry, Insets, colors, fonts, native image providers | Flutter 3.19 / Dart 3.3 |

These are two independent standard packages, tested and published separately. The repository root is not a package. The core does not depend on Flutter, dart:ui, or dart:io.

Clone the repository, add a local path to your application's `pubspec.yaml`, and run `dart pub get`:

```yaml
dependencies:
  axc_bedrock:
    path: ../AxcBedrock-Dart/packages/axc_bedrock
```

Adjust the path to match your directories. Flutter users should follow the [Flutter package instructions](packages/axc_bedrock_flutter/README.md), including the local dependency override.

# Usage

## Calling conventions

```dart
// Instance operations
value.axc.operation
// Static helpers use separate types, for example
AxcBool.createOptional('true')
```

The `.axc` namespace uses extension types without allocating wrapper objects. List, Map, int, and double retain their types. Helpers live in the corresponding Space, and applications import only the public entry point.

## Example

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

Collection operations return shallow copies. To match Swift, `list.axc.filter(by:)` removes items for which the predicate returns true; use `where` to retain matches. `AxcOnce` coordinates synchronous callbacks on the same instance within one isolate. Associated values use typed keys and native Expando/WeakReference support. Flutter image helpers return native ImageProvider types.

See the [core README](packages/axc_bedrock/README.md) and [Flutter README](packages/axc_bedrock_flutter/README.md) for detailed contracts and examples. Package documentation and public API comments are currently in Chinese.

# Development and validation

Run inside `packages/axc_bedrock`:

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

Run inside `packages/axc_bedrock_flutter`:

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test example
flutter analyze --fatal-infos
flutter test
flutter pub publish --dry-run
```

CI is configured for the minimum toolchains and stable releases. Core checks include rejected type errors, a Web smoke test, and [shared Swift/Dart behavior fixtures](packages/axc_bedrock/test/fixtures/parity.json). Check Actions for actual CI results.

Before publishing, update each package's CHANGELOG and complete validation. Publish the core first, then Flutter. The Flutter package's `pubspec_overrides.yaml` is for repository development and is excluded from publication; applications do not inherit it. There is no automatic publishing workflow.

# Issues and contributions

[Issues](https://github.com/axclogo/AxcBedrock-Dart/issues) with reproducible examples, focused fixes, and tests are welcome. Follow [CONTRIBUTING.md](CONTRIBUTING.md) for new APIs and update the API comparison. Future maintenance will depend on actual usage and available time; there is no promised response or release schedule.

# Contact

E-mail: axclogo@163.com

# License

[MIT](LICENSE). If this library helps you, a Star is a welcome way to let me know someone is using it.
