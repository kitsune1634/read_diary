import 'dart:async';

import 'package:diary/navigationMenu/book.dart';
import 'package:diary/database/database.dart';

abstract class DbEvent {}

class AllBooksEvent extends DbEvent {}

class ReadingBooksEvent extends DbEvent {}

class PlansBooksEvent extends DbEvent {}

class ReadBooksEvent extends DbEvent {}

class NewBookEvent extends DbEvent {
  late Book _book;

  NewBookEvent(Book book) {
    _book = book;
  }
}

class DbBook {
  List<Book> _list = [];

  final _listBookStateController = StreamController<List<Book>>();

  StreamSink<List<Book>> get _inListBook => _listBookStateController.sink;

  Stream<List<Book>> get listBook => _listBookStateController.stream;

  final _dbEventController = StreamController<DbEvent>();

  Sink<DbEvent> get dbEventSink => _dbEventController.sink;

  DbBloc() {
    _dbEventController.stream.listen(_eventToState);
  }

  Future<void> _eventToState(DbEvent event) async {
    if (event is AllBooksEvent) {
      _list = await DBProvider.db.getAllBooks();
    } else if (event is NewBookEvent) {
      DBProvider.db.newBook(event._book);
    } else {
      throw Exception('Error');
    }
    _inListBook.add(_list);
  }

  void disponse() {
    _dbEventController.close();
    _listBookStateController.close();
  }
}
