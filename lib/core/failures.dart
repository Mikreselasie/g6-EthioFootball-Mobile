sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String m) : super(m);
}

class ParseFailure extends Failure {
  const ParseFailure(String m) : super(m);
}
