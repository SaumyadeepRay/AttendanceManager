// This abstract class serves as the base class for all failure types.
// It holds an error message that describes the failure.
abstract class Failure {
  final String message; // Error message that describes the failure

  Failure(this.message);
}

// ServerFailure represents an error that occurs during API or network calls.
// It extends the Failure class and inherits the message property.
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

// CacheFailure represents an error that occurs while fetching or storing data locally.
// This could happen due to corrupted cache files or storage issues.
class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

// ValidationFailure represents an error that occurs due to invalid input provided by the user.
// This helps to ensure that correct data is processed by the app.
class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}