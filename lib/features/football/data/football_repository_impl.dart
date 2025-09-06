import '../domain/entities.dart';
import '../domain/football_repository.dart';
import 'football_api_client.dart';
import '../../../core/database_helper.dart';

class FootballRepositoryImpl implements FootballRepository {
  final FootballApiClient api;
  final DatabaseHelper _db = DatabaseHelper();
  
  FootballRepositoryImpl(this.api);

  @override
  Future<List<Standing>> standings(String league) async {
    try {
      // Try to get fresh data from API
      final response = await api.getStandings(league);
      
      // Cache the data in SQLite
      final standingsData = response.standings.map((d) => {
        'position': d.position,
        'team': d.team,
        'points': d.points,
        'matchPlayed': d.matchPlayed,
        'wins': d.wins,
        'lose': d.lose,
        'draw': d.draw,
        'gd': d.gd,
      }).toList();
      
      await _db.insertStandings(league, standingsData);
      
      return response.standings.map((d) => Standing(
        position: d.position, 
        team: d.team, 
        points: d.points,
        matchPlayed: d.matchPlayed,
        wins: d.wins,
        lose: d.lose,
        draw: d.draw,
        gd: d.gd,
      )).toList();
    } catch (e) {
      // If API fails, try to get cached data
      final cachedData = await _db.getStandings(league);
      if (cachedData.isNotEmpty) {
        return cachedData.map((data) => Standing(
          position: data['position'] as int,
          team: data['team'] as String,
          points: data['points'] as int,
          matchPlayed: data['matchPlayed'] as int,
          wins: data['wins'] as int,
          lose: data['lose'] as int,
          draw: data['draw'] as int,
          gd: data['gd'] as int,
        )).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<Fixture>> fixtures({required String league, String? team, DateTime? from, DateTime? to}) async {
    try {
      // Try to get fresh data from API
      final response = await api.getFixtures(
        league: league,
        team: team,
        from: from?.toUtc().toIso8601String(),
        to: to?.toUtc().toIso8601String(),
      );
      
      // Cache the data in SQLite
      final fixturesData = response.fixtures.map((d) => {
        'id': d.id,
        'league': d.league,
        'homeTeam': d.homeTeam,
        'awayTeam': d.awayTeam,
        'kickoff': d.kickoff.toIso8601String(),
        'status': d.status,
        'score': d.score,
      }).toList();
      
      await _db.insertFixtures(fixturesData);
      
      return response.fixtures
          .map((d) => Fixture(
                id: d.id,
                homeTeam: d.homeTeam,
                awayTeam: d.awayTeam,
                league: d.league,
                kickoff: d.kickoff,
                status: d.status,
                score: d.score,
              ))
          .toList();
    } catch (e) {
      // If API fails, try to get cached data
      final cachedData = await _db.getFixtures(league: league);
      if (cachedData.isNotEmpty) {
        return cachedData.map((data) => Fixture(
          id: data['id'] as String,
          homeTeam: data['homeTeam'] as String,
          awayTeam: data['awayTeam'] as String,
          league: data['league'] as String,
          kickoff: DateTime.parse(data['kickoff'] as String),
          status: data['status'] as String,
          score: data['score'] as String?,
        )).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<LiveScore>> liveScores() async {
    try {
      // Try to get fresh data from API
      final response = await api.getLiveScores();
      
      // Cache the data in SQLite
      final liveScoresData = response.liveScores.map((d) => {
        'id': d.id,
        'league': d.league,
        'homeTeam': d.homeTeam,
        'awayTeam': d.awayTeam,
        'kickoff': d.kickoff.toIso8601String(),
        'status': d.status,
        'score': d.score,
      }).toList();
      
      await _db.insertLiveScores(liveScoresData);
      
      return response.liveScores
          .map((d) => LiveScore(
                id: d.id,
                homeTeam: d.homeTeam,
                awayTeam: d.awayTeam,
                league: d.league,
                kickoff: d.kickoff,
                status: d.status,
                score: d.score,
              ))
          .toList();
    } catch (e) {
      // If API fails, try to get cached data
      final cachedData = await _db.getLiveScores();
      if (cachedData.isNotEmpty) {
        return cachedData.map((data) => LiveScore(
          id: data['id'] as String,
          homeTeam: data['homeTeam'] as String,
          awayTeam: data['awayTeam'] as String,
          league: data['league'] as String,
          kickoff: DateTime.parse(data['kickoff'] as String),
          status: data['status'] as String,
          score: data['score'] as String,
        )).toList();
      }
      rethrow;
    }
  }
}
