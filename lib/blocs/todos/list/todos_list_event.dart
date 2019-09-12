abstract class ToDosListEvent{}

class FetchToDos extends ToDosListEvent{
  final userId;
  FetchToDos({this.userId});

  @override
  String toString() {
    return 'ToDosListEvent: FetchToDos{userId: $userId}';
  }
}

class ResetAndFetchToDos extends ToDosListEvent{
  final userId;
  ResetAndFetchToDos({this.userId});

  @override
  String toString() {
    return 'ToDosListEvent: ResetAndFetchToDos{userId: $userId}';
  }
}