import 'axc_range.dart';

class AxcDoubleRange extends AxcRange<double> {
  AxcDoubleRange(this.start, this.endInclusive);
  @override
  final double endInclusive;

  @override
  final double start;

  @override
  bool contains(covariant num value) {
    if (start <= endInclusive) {
      return start <= value && value <= endInclusive;
    } else {
      return endInclusive <= value && value <= start;
    }
  }
}
