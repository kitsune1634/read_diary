import 'package:diary/database/database.dart';
import 'package:diary/navigationMenu/quotes.dart';

import 'package:flutter/material.dart';

class AddQuotes extends StatefulWidget {
  const AddQuotes({super.key});

  @override
  State<AddQuotes> createState() => _AddQuotesState();
}

class _AddQuotesState extends State<AddQuotes> {
  List<Quotes> quotes = [];

  final Quotes _quotes = Quotes(titleFromQuote: '', authorQuote: '', quote: '');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final titleController = TextEditingController();
  late final quoteController = TextEditingController();
  late final authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Добавить цитату'),
                actions: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Название книги',
                      labelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                          return TextStyle(fontSize: 18);
                        },
                      ),
                    ),
                    onSaved: (String? value) {
                      _quotes.titleFromQuote = value ?? '';
                    },
                    controller: titleController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Автор цитаты',
                      labelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                          return TextStyle(fontSize: 18);
                        },
                      ),
                    ),
                    onSaved: (String? value) {
                      _quotes.authorQuote = value ?? '';
                    },
                    controller: authorController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Цитата',
                      labelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                          return TextStyle(fontSize: 18);
                        },
                      ),
                    ),
                    onSaved: (String? value) {
                      _quotes.quote = value ?? '';
                    },
                    controller: quoteController,
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            DBProvider.db.newQuotes(_quotes);
                            print('add quote');
                          } else {
                            print('not add quote');
                          }
                          setState(() {});
                          titleController.clear();
                          quoteController.clear();
                          authorController.clear();
                          Navigator.pop(context, 'Cancel');
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
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: allQuote(),
    );
  }

  allQuote() {
    return FutureBuilder<List<Quotes>>(
      future: DBProvider.db.getAllQuotes(),
      builder: (BuildContext context, AsyncSnapshot<List<Quotes>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Quotes item = snapshot.data![index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        DBProvider.db.deleteQuotes(item.id);
                      },
                      background: Container(color: Colors.black12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[45],
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                        padding:
                            EdgeInsets.only(top: 20, bottom: 15, left: 10, right: 10),
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    item.titleFromQuote,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 17,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    item.quote,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 17,
                                     // fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  item.authorQuote,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
