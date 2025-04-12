class AppError implements Exception {
  final String message;
  final String code;

  AppError(this.message, {this.code = ''});

  @override
  String toString() => 'AppError: $message (code: $code)';
}

class ErrorHandler {
  static AppError handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AppError('You don\'t have permission to perform this action', code: e.code);
      case 'not-found':
        return AppError('The requested document was not found', code: e.code);
      case 'already-exists':
        return AppError('The document already exists', code: e.code);
      default:
        return AppError('A database error occurred', code: e.code);
    }
  }

  static AppError handleStorageError(FirebaseException e) {
    switch (e.code) {
      case 'object-not-found':
        return AppError('The file was not found', code: e.code);
      case 'unauthorized':
        return AppError('You don\'t have permission to access this file', code: e.code);
      default:
        return AppError('A storage error occurred', code: e.code);
    }
  }
}
