import 'package:diary/navigationMenu/book.dart';
import 'package:diary/database/database.dart';
import 'package:flutter/material.dart';

class Bookmarks extends StatefulWidget {
  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  int _counterBookmarks = 0;

  /* List<Book> book = [
    Book(
        nameBook: 'Зеленая миля',
        author: 'Стивен Кинг',
        year: 1996,
        status: read),
    Book(
        nameBook: 'Шерлок Хомс',
        author: 'Артур Конан Дойл',
        year: 2019,
        status: plans),
    Book(
        nameBook: 'Благословление небожиелей',
        author: 'Мосян Тунсю',
        year: 2020,
        status: reading),
  ];*/

  void _incrementBookmarks() {
    setState(() {
      _counterBookmarks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(tabs: [
                Tab(text: 'Все'),
                Tab(text: 'Читаю'),
                Tab(text: 'В планах'),
                Tab(text: 'Прочитано'),
              ]),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            allBook(null),
            allBook(0),
            allBook(1),
            allBook(2),
          ],
        ),
        /* floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await DBProvider.db.newBook(book[_counterBookmarks]);
            _counterBookmarks++;
            if (_counterBookmarks > 2) _counterBookmarks = 0;
            setState(() {});
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),*/
      ),
    );
  }

  allBook(int? status) {
    return FutureBuilder<List<Book>>(
      future: status == null
          ? DBProvider.db.getAllBooks()
          : status == 0
              ? DBProvider.db.getReadingBooksEvent()
              : status == 1
                  ? DBProvider.db.getPlansBooksEvent()
                  : DBProvider.db.getReadBooksEvent(),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.hasData) {
          return AbsorbPointer(
            child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  Book item = snapshot.data![index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      DBProvider.db.deleteBook(item.id);
                    },
                    background: Container(color: Colors.black12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[45],
                        border: Border.all(
                          color: Colors.black87,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: Text(
                          item.id.toString(),
                          style: TextStyle(fontSize: 13),
                        ),
                        title: (Text(
                          item.nameBook,
                          style: TextStyle(fontSize: 18),
                        )),
                        subtitle: Text(
                          item.author,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: Text(
                          item.year.toString(),
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  );
                },

            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
