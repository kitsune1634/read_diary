import 'package:diary/navigationMenu/quotes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProviderQuotes {
  static final DBProviderQuotes db = DBProviderQuotes._instance();

  DBProviderQuotes._instance();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
 //   _database = await initDBQuotes();
    return _database;
  }

  Future<List<Quotes>> getAllQuotes() async {
    final db = await database;
    var result = await db?.rawQuery("SELECT * FROM quotes");
    List<Quotes>? list = (result?.isNotEmpty ?? false)
        ? result?.map((e) => Quotes.fromMap(e)).toList() ?? []
        : [];
    return list;
  }

  newQuote(Quotes quotes) async {
    final db = await database;
    var query = await db?.rawQuery('SELECT MAX(id) as id FROM quotes');
    int id = int.parse((query?.first['id'] ?? "0").toString());
    id += 1;
    var raw = await db?.rawInsert(
        " INSERT into book(id, titleFromQuote, authorQuote, quote)"
        " VALUES(?,?,?,?) ",
        [id ,quotes.titleFromQuote, quotes.authorQuote, quotes.quote]);
    return raw;
  }
  deleteQuotes(int id) async {
    final db = await database;
    return db?.delete('quotes', where: "id = ?", whereArgs: [id]);
  }


  everythingQuotes(Quotes quotes) async {
    final db = await database;
    Quotes allQuotes = Quotes(
      titleFromQuote: quotes.titleFromQuote,
      authorQuote: quotes.authorQuote,
      quote: quotes.quote,
    );
    var resultQuotes = await db?.update('quotes', allQuotes.toMap(),
        where: "id = ?", whereArgs: [allQuotes.id]);
  }
}
