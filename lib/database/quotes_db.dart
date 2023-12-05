import 'dart:async';

import 'package:diary/database/database.dart';
import 'package:diary/navigationMenu/quotes.dart';

abstract class DbEvent {}

class AllQuotesEvent extends DbEvent {}

class NewQuotesEvent extends DbEvent {
  late Quotes _quotes;

  NewQuotesEvent(Quotes quotes) {
    _quotes = quotes;
  }
}

class DbQuotes {
  List<Quotes> _list = [];

  final _listQuotesStateController = StreamController<List<Quotes>>();

  StreamSink<List<Quotes>> get _inListQuotes => _listQuotesStateController.sink;

  Stream<List<Quotes>> get listQuotes => _listQuotesStateController.stream;

  final _dbEventController = StreamController<DbEvent>();

  Sink<DbEvent> get dbEventSink => _dbEventController.sink;

  DbBloc() {
    _dbEventController.stream.listen(_eventToState);
  }

  Future<void> _eventToState(DbEvent event) async {
    if (event is AllQuotesEvent) {
      _list = await DBProvider.db.getAllQuotes();
    } else if (event is NewQuotesEvent) {
      DBProvider.db.newQuotes(event._quotes);
    } else {
      throw Exception('Error');
    }
    _inListQuotes.add(_list);
  }

  void disponse() {
    _dbEventController.close();
    _listQuotesStateController.close();
  }
}
