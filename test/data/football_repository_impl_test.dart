import 'package:flutter_test/flutter_test.dart';
import 'package:football_livehub/features/football/data/football_repository_impl.dart';
import 'package:football_livehub/features/football/data/football_api_client.dart';
import 'package:football_livehub/features/football/data/models.dart';
import 'package:football_livehub/core/http_client.dart';

class FakeApi extends FootballApiClient {
  FakeApi() : super(HttpClient('http://localhost:0'));

  @override
  Future<List<StandingDto>> getStandings(String league) async =>
      [StandingDto(position: 1, team: 'Arsenal', points: 45)];
}

void main() {
  test('repository maps DTO -> entity', () async {
    final repo = FootballRepositoryImpl(FakeApi());
    final s = await repo.standings('EPL');
    expect(s.first.points, 45);
  });
}
