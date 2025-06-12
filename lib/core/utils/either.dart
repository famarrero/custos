// Base class Either
abstract class Either<L, R> {
  const Either();

  // Method to map the value depending on whether it's Left or Right
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

// Class representing the "Left" case (usually for errors)
// ignore: camel_case_types
class left<L, R> extends Either<L, R> {
  final L value;

  const left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }
}

// Class representing the "Right" case (usually for successful results)
// ignore: camel_case_types
class right<L, R> extends Either<L, R> {
  final R value;

  const right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }
}
