part of axc_bedrock;

class AxcDoubleRange extends AxcRange<double> {
  AxcDoubleRange(this.start, this.endInclusive);

  @override
  final double endInclusive;

  @override
  final double start;

  @override
  bool isContains(covariant num value) {
    if (start <= endInclusive) {
      return start <= value && value <= endInclusive;
    } else {
      return endInclusive <= value && value <= start;
    }
  }
}
