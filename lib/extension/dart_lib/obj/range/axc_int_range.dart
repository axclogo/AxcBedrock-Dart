import 'axc_range.dart';

class AxcIntRange extends AxcRange<int> {
  AxcIntRange(this.start, this.endInclusive);

  @override
  final int endInclusive;

  @override
  final int start;

  @override
  bool contains(covariant num value) {
    if (start <= endInclusive) {
      return start <= value && value <= endInclusive;
    } else {
      return endInclusive <= value && value <= start;
    }
  }
}
