sealed class Result<S, F> {
  const Result();

  T when<T>({
    required T Function(S value) success,
    required T Function(F failure) failure,
  }) {
    final current = this;
    if (current is Success<S, F>) {
      return success(current.value);
    }
    return failure((current as Failure<S, F>).error);
  }
}

class Success<S, F> extends Result<S, F> {
  const Success(this.value);

  final S value;
}

class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);

  final F error;
}
