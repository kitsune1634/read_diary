import 'dart:collection';

import 'package:diary/navigationMenu/quotes.dart';
import 'package:flutter/material.dart';

List<Quotes> quotes = [];

class AllQuotes extends StatefulWidget {
  @override
  State<AllQuotes> createState() => _AllQuotesState();
}

class _AllQuotesState extends State<AllQuotes> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: DialogExample(),
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: quotes.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return (index == quotes.length)? SizedBox(height: 50,)
                    : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.only(top: 20, bottom: 15, left: 10, right: 10),
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                quotes[index].titleFromQuote,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                quotes[index].quote,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                quotes[index].authorQuote,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],

                      ),
                    );
                  }),
            ),
          ],
        ),

    );
  }
}

class DialogExample extends StatefulWidget {
  const DialogExample({super.key});

  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  late final titleController = TextEditingController();
  late final quoteController = TextEditingController();
  late final authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Добавть цитату'),
            actions: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Название книги'),
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Автор цитаты'),
                controller: quoteController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Цитата'),
                controller: authorController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      quotes.add(Quotes(titleFromQuote: titleController.text, authorQuote: authorController.text, quote: quoteController.text));
                      setState(() {});
                      titleController.clear();quoteController.clear();authorController.clear();
                    },
                    child: const Text('Добавить'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ],
          ),
      ),
      child: const Icon(Icons.add),
    );
  }
}
