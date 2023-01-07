import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class Repository {
  final String htmlUrl;
  final String description;
  final int watchersCount;
  final int forks;
  final String name;
  final String owner;

  Repository(this.htmlUrl, this.description, this.watchersCount, this.forks,
      this.name, this.owner);

  static Future<List<Repository>> getRepos() async {
    final uri = Uri.parse("https://api.github.com/users/freeCodeCamp/repos");
    var response = await http.get(uri);
    var jsonResponse = convert.jsonDecode(response.body) as List;
    return jsonResponse
        .map((r) => Repository(
            r['html_url'],
            r['description'] ?? 'No Description',
            r['watchers_count'] ?? 0,
            r['forks_count'],
            r['name'],
            r['owner']['login']))
        .toList();
  }
}
