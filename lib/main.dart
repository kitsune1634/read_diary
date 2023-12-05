import 'package:diary/navigationMenu/allBook.dart';
import 'package:diary/navigationMenu/addQuotes.dart';
import 'package:diary/navigationMenu/bookmarks.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Читательский дневник',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Finlandica'),
      home: const MyHomePage(title: 'Читательский дневник'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      Bookmarks(),
      AddBook(callback: () => setState(() {})),
      AddQuotes(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,
            style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 25,
            )),
      ),
      body: IndexedStack(
        children: _pages,
        index: _counter,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _counter,
        onTap: (index) {
          setState(() {
            _counter = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.class_outlined), label: 'закладки'),
          BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts), label: 'добавить книгу'),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), label: 'цитаты'),
        ],
      ),
    );
  }
}
