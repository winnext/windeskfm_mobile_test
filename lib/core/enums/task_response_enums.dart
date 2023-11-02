enum TaskResponseEnums { my, our, pending, end, error }

extension TaskResponseEnumsExtension on TaskResponseEnums {
  String get rawValue {
    switch (this) {
      case TaskResponseEnums.my:
        return 'my';
      case TaskResponseEnums.our:
        return 'our';
      case TaskResponseEnums.pending:
        return 'pending';
      case TaskResponseEnums.end:
        return 'finished';
      case TaskResponseEnums.error:
        return 'error';
      default:
        return 'error';
    }
  }
}
