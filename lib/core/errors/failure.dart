class Failure {
  final String message;
  const Failure(this.message);

  factory Failure.fromFirebaseAuth(String code) {
    switch (code) {
      case 'user-not-found':
        return const Failure('No account found with this email.');
      case 'wrong-password':
        return const Failure('Incorrect password.');
      case 'email-already-in-use':
        return const Failure('An account already exists with this email.');
      case 'weak-password':
        return const Failure('Password should be at least 6 characters.');
      case 'invalid-email':
        return const Failure('Please enter a valid email address.');
      case 'network-request-failed':
        return const Failure('Network error. Check your connection.');
      default:
        return const Failure('Something went wrong. Please try again.');
    }
  }
}