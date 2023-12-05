import 'package:diary/database/database.dart';
import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:diary/navigationMenu/book.dart';

class AddBook extends StatefulWidget {
  final void Function() callback;

  const AddBook({super.key, required this.callback});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  List<String> list = <String>['Читаю', 'В планах', 'Прочитано'];

  int _counterBook = 0;

  String dropdownValue = 'Читаю';

  final Book _book = Book(nameBook: '', author: '', year: 0, status: read);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _incrementBook() {
    setState(() {
      _counterBook++;
      if (_counterBook > 2) _counterBook = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            getForm(),
          ],
        ),
      ),
    );
  }

  Widget getForm() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextFormField(
                validator: (String? value) {
                  if ((value?.length ?? 0) < 3) {
                    return 'Необходимо добавить больше двух элементов';
                  }
                  return null;
                    },
                decoration: InputDecoration(
                  labelText: 'Название книги:',
                  labelStyle: MaterialStateTextStyle.resolveWith(
                    (Set<MaterialState> states) {
                      return TextStyle(fontSize: 18);
                    },
                  ),
                ),
                onSaved: (String? value) {
                  _book.nameBook = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Автор:',
                  labelStyle: MaterialStateTextStyle.resolveWith(
                    (Set<MaterialState> states) {
                      return TextStyle(fontSize: 18);
                    },
                  ),
                ),
                onSaved: (String? value) {
                  _book.author = value ?? '';
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Год:',
                  labelStyle: MaterialStateTextStyle.resolveWith(
                    (Set<MaterialState> states) {
                      return TextStyle(fontSize: 18);
                    },
                  ),
                ),
                validator: (String? value) {
                  if ((value?.length ?? 0) < 1) {
                    return 'Год не введен';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _book.year = int.parse(value ?? '0');
                },
              ),
              getDropdownButtonExample(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      _book.status = list.indexOf(dropdownValue);
                      DBProvider.db.newBook(_book);
                      widget.callback;

                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    }

                  },
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Widget getDropdownButtonExample() {
    return DropdownButton<String>(
      itemHeight: 70,
      isExpanded: true,
      value: dropdownValue,
      icon: const Icon(Icons.turned_in_not),
      elevation: 16,
      style: const TextStyle(color: Colors.black87, fontFamily: 'Finlandica'),
      underline: Container(
        height: 1,
        color: Colors.black87,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }).toList(),
    );
  }
}
