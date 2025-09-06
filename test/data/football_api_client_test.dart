import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:football_livehub/core/http_client.dart';
import 'package:football_livehub/features/football/data/football_api_client.dart';

class MockClient extends http.BaseClient {
  final Map<String, http.Response> routes;
  MockClient(this.routes);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final key = '${request.method} ${request.url.path}${request.url.query.isNotEmpty ? '?${request.url.query}' : ''}';
    final res = routes[key] ?? http.Response('Not Found', 404);
    return http.StreamedResponse(Stream.value(res.bodyBytes), res.statusCode, headers: res.headers);
  }
}

void main() {
  test('getStandings parses list', () async {
    final mock = MockClient({
      'GET /standings?league=EPL': http.Response(jsonEncode({
        'league': 'EPL',
        'standings': [
          {'position': 1, 'team': 'Arsenal', 'points': 45}
        ],
        'freshness': {'source': 'mock', 'retrieved': '2025-08-29T12:30:00Z'}
      }), 200)
    });

    final hc = HttpClient('http://localhost:3000', client: mock);
    final api = FootballApiClient(hc);
    final list = await api.getStandings('EPL');
    expect(list.first.team, 'Arsenal');
  });
}
