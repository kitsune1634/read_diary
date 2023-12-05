class Book {
  late int id;
  String nameBook = '';
  String author = '';
  int year;
  int status;

  Book(
      {this.id = 0,
        required this.nameBook,
        required this.author,
        required this.year,
        required this.status,
      });

  factory Book.fromMap(Map<String, dynamic> json) => Book(
      id: json['id'],
      nameBook: json['nameBook'],
      author: json['author'],
      year: json['year'],
     status: json['status'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nameBook": nameBook,
    "author": author,
    "year": year,
    "status": status,
  };
}

const int reading = 0;
const int plans = 1;
const int read = 2;