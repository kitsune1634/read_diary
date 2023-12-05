class Quotes {
  late int id;
  String titleFromQuote = '';
  String authorQuote = '';
  String quote = '';

  Quotes(
      {this.id = 0,
        required this.titleFromQuote,
        required this.authorQuote,
        required this.quote,
      });

  factory Quotes.fromMap(Map<String, dynamic> json) => Quotes(
    id: json['id'],
    titleFromQuote: json['titleFromQuote'],
    authorQuote: json['authorQuote'],
    quote: json['quote'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "titleFromQuote": titleFromQuote,
    "authorQuote": authorQuote,
    "quote": quote,
  };
}