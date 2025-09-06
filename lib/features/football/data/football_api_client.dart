import 'package:football_livehub/core/http_client.dart';
import 'models.dart';

class FootballApiClient {
  FootballApiClient(this._http);

  final HttpClient _http;

  // GET /standings?league=EPL|ETH
  Future<StandingsResponseDto> getStandings(String league) async {
    final json = await _http.getJson('/standings', params: {'league': league});
    return StandingsResponseDto.fromJson(json);
  }

  // GET /fixtures?league=EPL|ETH&team=&from=&to=
  Future<FixturesResponseDto> getFixtures({
    required String league, 
    String? team, 
    String? from, 
    String? to
  }) async {
    final params = <String, String>{
      'league': league,
      if (team != null && team.isNotEmpty) 'team': team,
      if (from != null && from.isNotEmpty) 'from': from,
      if (to != null && to.isNotEmpty) 'to': to,
    };
    final json = await _http.getJson('/fixtures', params: params);
    return FixturesResponseDto.fromJson(json);
  }

  // GET /news/liveScores
  Future<LiveScoresResponseDto> getLiveScores() async {
    final json = await _http.getJson('/news/liveScores');
    return LiveScoresResponseDto.fromJson(json);
  }
}
