import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class Commit {
  final String author;
  final String email;
  final String date;
  final String message;

  Commit(this.author, this.email, this.date, this.message);

  static Future<Commit> getLastestCommit(name) async {
    final uri =
        Uri.parse("https://api.github.com/repos/freeCodeCamp/$name/commits");
    var response = await http.get(uri);
    var jsonResponse = convert.jsonDecode(response.body) as List;
    var lastestCommit = jsonResponse[0];
    return Commit(
        lastestCommit['commit']['author']['name'],
        lastestCommit['commit']['author']['email'],
        lastestCommit['commit']['author']['date'],
        lastestCommit['commit']['message']);
  }
}
