import 'package:diary/navigationMenu/book.dart';
import 'package:diary/navigationMenu/quotes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider db = DBProvider._instance();

  DBProvider._instance();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var documentDirectory = await getDatabasesPath();
    String path = join(documentDirectory, 'TestDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE book ("
          " id INTEGER PRIMARY KEY,"
          " nameBook TEXT,"
          " author TEXT,"
          " year INTEGER,"
          " status INTEGER)");
      await db.execute("CREATE TABLE quotes ("
          " id INTEGER PRIMARY KEY,"
          " titleFromQuote TEXT,"
          " authorQuote TEXT,"
          " quote TEXT)");
    });
  }

  //Book

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    var result = await db?.rawQuery("SELECT * FROM book");
    List<Book>? list = (result?.isNotEmpty ?? false)
        ? result?.map((e) => Book.fromMap(e)).toList() ?? []
        : [];
    return list;
  }

  Future<List<Book>> getReadingBooksEvent() async {
    final db = await database;
    var result = await db?.rawQuery("SELECT * FROM book WHERE status = 0");
    List<Book>? list = (result?.isNotEmpty ?? false)
        ? result?.map((e) => Book.fromMap(e)).toList() ?? []
        : [];
    return list;
  }

  Future<List<Book>> getPlansBooksEvent() async {
    final db = await database;
    var result = await db?.rawQuery("SELECT * FROM book WHERE status = 1");
    List<Book>? list = (result?.isNotEmpty ?? false)
        ? result?.map((e) => Book.fromMap(e)).toList() ?? []
        : [];
    return list;
  }

  Future<List<Book>> getReadBooksEvent() async {
    final db = await database;
    var result = await db?.rawQuery("SELECT * FROM book WHERE status = 2");
    List<Book>? list = (result?.isNotEmpty ?? false)
        ? result?.map((e) => Book.fromMap(e)).toList() ?? []
        : [];
    return list;
  }

  newBook(Book book) async {
    final db = await database;
    var query = await db?.rawQuery('SELECT MAX(id) as id FROM book');
    int id = int.parse((query?.first['id'] ?? "0").toString());
    id += 1;
    var raw = await db?.rawInsert(
        " INSERT into book(id, nameBook, author, year, status)"
        " VALUES(?,?,?,?,?) ",
        [id, book.nameBook, book.author, book.year, book.status]);
    return raw;
  }

  deleteBook(int id) async {
    final db = await database;
    return db?.delete('book', where: "id = ?", whereArgs: [id]);
  }

  everythingBook(Book book) async {
    final db = await database;
    Book allBook = Book(
      nameBook: book.nameBook,
      author: book.author,
      year: book.year,
      status: book.status,
    );
    var result = await db?.update('book', allBook.toMap(),
        where: "id = ?", whereArgs: [allBook.id]);
  }

  //Quotes

  Future<List<Quotes>> getAllQuotes() async {
    final db = await database;
    var result = await db?.rawQuery("SELECT * FROM quotes");
    List<Quotes>? list = (result?.isNotEmpty ?? false)
        ? result?.map((e) => Quotes.fromMap(e)).toList() ?? []
        : [];
    return list;
  }

  newQuotes(Quotes quotes) async {
    final db = await database;
    var query = await db?.rawQuery('SELECT MAX(id) as id FROM quotes');
    int id = int.parse((query?.first['id'] ?? "0").toString());
    id += 1;
    var raw = await db?.rawInsert(
        " INSERT into quotes(id, titleFromQuote, authorQuote, quote)"
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
