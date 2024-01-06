/// Used to wrap around parameters in copyWith functions
/// to allow for copying with null values.
/// Solution from: https://stackoverflow.com/a/71732563/14804912
class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
