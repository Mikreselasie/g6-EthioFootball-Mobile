import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'football_livehub.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Standings table
    await db.execute('''
      CREATE TABLE standings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        league TEXT NOT NULL,
        position INTEGER NOT NULL,
        team TEXT NOT NULL,
        points INTEGER NOT NULL,
        matchPlayed INTEGER NOT NULL,
        wins INTEGER NOT NULL,
        lose INTEGER NOT NULL,
        draw INTEGER NOT NULL,
        gd INTEGER NOT NULL,
        lastUpdated TEXT NOT NULL,
        UNIQUE(league, position)
      )
    ''');

    // Fixtures table
    await db.execute('''
      CREATE TABLE fixtures(
        id TEXT PRIMARY KEY,
        league TEXT NOT NULL,
        homeTeam TEXT NOT NULL,
        awayTeam TEXT NOT NULL,
        kickoff TEXT NOT NULL,
        status TEXT NOT NULL,
        score TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // Live scores table
    await db.execute('''
      CREATE TABLE live_scores(
        id TEXT PRIMARY KEY,
        league TEXT NOT NULL,
        homeTeam TEXT NOT NULL,
        awayTeam TEXT NOT NULL,
        kickoff TEXT NOT NULL,
        status TEXT NOT NULL,
        score TEXT NOT NULL,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE user_preferences(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // Standings operations
  Future<void> insertStandings(String league, List<Map<String, dynamic>> standings) async {
    final db = await database;
    await db.delete('standings', where: 'league = ?', whereArgs: [league]);
    
    for (final standing in standings) {
      await db.insert('standings', {
        'league': league,
        'position': standing['position'],
        'team': standing['team'],
        'points': standing['points'],
        'matchPlayed': standing['matchPlayed'],
        'wins': standing['wins'],
        'lose': standing['lose'],
        'draw': standing['draw'],
        'gd': standing['gd'],
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getStandings(String league) async {
    final db = await database;
    return await db.query(
      'standings',
      where: 'league = ?',
      whereArgs: [league],
      orderBy: 'position ASC',
    );
  }

  // Fixtures operations
  Future<void> insertFixtures(List<Map<String, dynamic>> fixtures) async {
    final db = await database;
    await db.delete('fixtures');
    
    for (final fixture in fixtures) {
      await db.insert('fixtures', {
        'id': fixture['id'],
        'league': fixture['league'],
        'homeTeam': fixture['homeTeam'],
        'awayTeam': fixture['awayTeam'],
        'kickoff': fixture['kickoff'],
        'status': fixture['status'],
        'score': fixture['score'],
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getFixtures({String? league}) async {
    final db = await database;
    if (league != null) {
      return await db.query(
        'fixtures',
        where: 'league = ?',
        whereArgs: [league],
        orderBy: 'kickoff ASC',
      );
    }
    return await db.query('fixtures', orderBy: 'kickoff ASC');
  }

  // Live scores operations
  Future<void> insertLiveScores(List<Map<String, dynamic>> liveScores) async {
    final db = await database;
    await db.delete('live_scores');
    
    for (final liveScore in liveScores) {
      await db.insert('live_scores', {
        'id': liveScore['id'],
        'league': liveScore['league'],
        'homeTeam': liveScore['homeTeam'],
        'awayTeam': liveScore['awayTeam'],
        'kickoff': liveScore['kickoff'],
        'status': liveScore['status'],
        'score': liveScore['score'],
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getLiveScores() async {
    final db = await database;
    return await db.query('live_scores', orderBy: 'kickoff ASC');
  }

  // User preferences operations
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return result.isNotEmpty ? result.first['value'] as String? : null;
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('standings');
    await db.delete('fixtures');
    await db.delete('live_scores');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

