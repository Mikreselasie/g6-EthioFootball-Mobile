import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'providers.dart';
import '../domain/entities.dart';

class LiveHubPage extends ConsumerWidget {
  const LiveHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fixturesFutureProvider);
              ref.invalidate(standingsFutureProvider);
              ref.invalidate(liveScoresFutureProvider);
              await Future.wait([
                ref.read(fixturesFutureProvider.future),
                ref.read(standingsFutureProvider.future),
                ref.read(liveScoresFutureProvider.future),
              ]);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _OnlineBanner(),
                SizedBox(height: 16),
                _DateNavigationBar(),
                SizedBox(height: 20),
                _LiveMatchesSection(),
                SizedBox(height: 20),
                _TableSection(),
                SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _DateNavigationBar extends ConsumerStatefulWidget {
  const _DateNavigationBar();

  @override
  ConsumerState<_DateNavigationBar> createState() => _DateNavigationBarState();
}

class _DateNavigationBarState extends ConsumerState<_DateNavigationBar> {
  bool _showCalendar = false;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCalendar = !_showCalendar;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showCalendar ? 'Close Calendar' : 'Today',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
              const SizedBox(width: 16),
            ],
          ),
        ),
        if (_showCalendar)
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Material(
              elevation: 16,
              borderRadius: BorderRadius.circular(16),
              child: _CalendarOverlay(
                selectedDate: _selectedDate,
                currentMonth: _currentMonth,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    _showCalendar = false;
                  });
                },
                onMonthChanged: (month) {
                  setState(() => _currentMonth = month);
                },
                onLeagueChanged: (league) {
                  ref.read(selectedLeagueProvider.notifier).state = league;
                  setState(() {
                    _showCalendar = false;
                  });
                },
                selectedLeague: selectedLeague,
                onClose: () {
                  setState(() {
                    _showCalendar = false;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarOverlay extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;
  final Function(String) onLeagueChanged;
  final String selectedLeague;
  final VoidCallback onClose;

  const _CalendarOverlay({
    required this.selectedDate,
    required this.currentMonth,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onLeagueChanged,
    required this.selectedLeague,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calendar Header with Close Button
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => onMonthChanged(DateTime(currentMonth.year, currentMonth.month - 1)),
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xFF2E7D32), size: 18),
                ),
                Text(
                  '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onMonthChanged(DateTime(currentMonth.year, currentMonth.month + 1)),
                      child: const Icon(Icons.arrow_forward_ios, color: Color(0xFF2E7D32), size: 18),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onClose,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Calendar Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Days of week header
                const Row(
                  children: [
                    Expanded(child: Center(child: Text('Sun', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(child: Center(child: Text('Mon', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(child: Center(child: Text('Tue', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(child: Center(child: Text('Wed', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(child: Center(child: Text('Thu', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(child: Center(child: Text('Fri', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(child: Center(child: Text('Sat', style: TextStyle(fontSize: 12, color: Color(0xFF666666))))),
                  ],
                ),
                const SizedBox(height: 8),
                // Calendar dates
                ..._buildCalendarGrid(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // League Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE8F5E8), width: 1)),
            ),
            child: Column(
              children: [
                const Text(
                  'Select League',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LeagueButton(
                        title: 'Ethiopian Premier League',
                        isSelected: selectedLeague == 'ETH',
                        onTap: () => onLeagueChanged('ETH'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LeagueButton(
                        title: 'English Premier League',
                        isSelected: selectedLeague == 'EPL',
                        onTap: () => onLeagueChanged('EPL'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Convert to Sunday = 0
    
    final List<Widget> rows = [];
    List<Widget> currentRow = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      currentRow.add(const Expanded(child: SizedBox(height: 40)));
    }
    
    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected = date.day == selectedDate.day && 
                        date.month == selectedDate.month && 
                        date.year == selectedDate.year;
      final isToday = date.day == DateTime.now().day && 
                     date.month == DateTime.now().month && 
                     date.year == DateTime.now().year;
      
      currentRow.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : 
                       isToday ? const Color(0xFFE8F5E8) : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected ? Border.all(color: const Color(0xFF2E7D32), width: 1) : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : 
                           isToday ? const Color(0xFF2E7D32) : const Color(0xFF666666),
                    fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      
      // Start new row every 7 days
      if (currentRow.length == 7) {
        rows.add(Row(children: currentRow));
        currentRow = [];
      }
    }
    
    // Add remaining empty cells to complete the last row
    while (currentRow.length < 7 && currentRow.isNotEmpty) {
      currentRow.add(const Expanded(child: SizedBox(height: 40)));
    }
    
    if (currentRow.isNotEmpty) {
      rows.add(Row(children: currentRow));
    }
    
    return rows;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _LeagueButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LeagueButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}


class _LiveMatchesSection extends ConsumerWidget {
  const _LiveMatchesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final fixturesAsync = ref.watch(fixturesFutureProvider);
    final liveScoresAsync = ref.watch(liveScoresFutureProvider);
    
    // Show only the selected league
    if (selectedLeague == 'ETH') {
      return _LeagueCard(
        leagueName: 'ETHIOPIAN PREMIERE LEAGUE',
        leagueLogo: _EthiopianFlag(),
        fixtures: fixturesAsync.valueOrNull?.where((f) => f.league == 'ETH').take(3).toList() ?? [],
        liveScores: liveScoresAsync.valueOrNull?.where((l) => l.league == 'ETH').take(3).toList() ?? [],
      );
    } else {
      return _LeagueCard(
        leagueName: 'ENGLISH PREMIER LEAGUE',
        leagueLogo: _PremierLeagueLogo(),
        fixtures: fixturesAsync.valueOrNull?.where((f) => f.league == 'EPL').take(3).toList() ?? [],
        liveScores: liveScoresAsync.valueOrNull?.where((l) => l.league == 'EPL').take(3).toList() ?? [],
      );
    }
  }
}

class _LeagueCard extends StatelessWidget {
  final String leagueName;
  final Widget leagueLogo;
  final List<Fixture> fixtures;
  final List<LiveScore> liveScores;

  const _LeagueCard({
    required this.leagueName,
    required this.leagueLogo,
    required this.fixtures,
    required this.liveScores,
  });

  @override
  Widget build(BuildContext context) {
    final allMatches = <Widget>[];
    
    // Add live scores first
    for (final liveScore in liveScores) {
      allMatches.add(_MatchRow(
        homeTeam: liveScore.homeTeam,
        awayTeam: liveScore.awayTeam,
        score: liveScore.score,
        isLive: true,
        time: '67\'', // Mock live time
      ));
    }
    
    // Add fixtures
    for (final fixture in fixtures) {
      final time = DateFormat.Hm().format(fixture.kickoff.toLocal());
      allMatches.add(_MatchRow(
        homeTeam: fixture.homeTeam,
        awayTeam: fixture.awayTeam,
        score: fixture.score ?? '3-2', // Mock score
        isLive: false,
        time: time,
      ));
    }
    
    // If no data, add mock data
    if (allMatches.isEmpty) {
      for (int i = 0; i < 3; i++) {
        allMatches.add(_MatchRow(
          homeTeam: 'St. George',
          awayTeam: 'Ethio Bunna',
          score: '3-2',
          isLive: i == 0,
          time: i == 0 ? '67\'' : '9:45 PM',
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
              child: Column(
                children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                leagueLogo,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    leagueName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Matches
          ...allMatches.take(3).map((match) => match).toList(),
        ],
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String score;
  final bool isLive;
  final String time;

  const _MatchRow({
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.isLive,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE8F5E8), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              homeTeam,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          // Score or Time with Boolean Circle - Centered
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                    color: isLive ? const Color(0xFF2E7D32) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
                    isLive ? score : time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isLive ? Colors.white : const Color(0xFF666666),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isLive ? const Color(0xFF22C55E) : const Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isLive ? Colors.white : const Color(0xFF9E9E9E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              awayTeam,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableSection extends ConsumerWidget {
  const _TableSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    
    return Column(
            children: [
        // Table Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Table',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Show only the selected league table
        if (selectedLeague == 'ETH')
          _TableCard(
            leagueName: 'ETHIOPIAN PREMIERE LEAGUE',
            leagueLogo: _EthiopianFlag(),
            season: '2025/26',
          )
        else
          _TableCard(
            leagueName: 'ENGLISH PREMIER LEAGUE',
            leagueLogo: _PremierLeagueLogo(),
            season: '2025/26',
          ),
      ],
    );
  }
}

class _TableCard extends StatelessWidget {
  final String leagueName;
  final Widget leagueLogo;
  final String season;

  const _TableCard({
    required this.leagueName,
    required this.leagueLogo,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                leagueLogo,
                const SizedBox(width: 12),
          Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leagueName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        'TABLE - $season',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                top: BorderSide(color: Color(0xFFE8F5E8), width: 1),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 24, child: Text('#', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 8),
                Expanded(child: Text('CLUB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 20, child: Text('MP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 20, child: Text('W', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 20, child: Text('D', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 20, child: Text('L', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 20, child: Text('GD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 4, child: Text('|', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                SizedBox(width: 20, child: Text('Pts', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
              ],
            ),
          ),
          // Table Rows
          ..._generateTableRows(leagueName),
        ],
      ),
    );
  }

  List<Widget> _generateTableRows(String league) {
    final teams = league.contains('ETHIOPIAN') 
        ? ['St. George', 'St. George', 'St. George']
        : ['Chelsea', 'Liverpool', 'Arsenal'];
    
    return teams.asMap().entries.map((entry) {
      final index = entry.key;
      final team = entry.value;
      final position = index + 1;
      
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE8F5E8), width: 1),
          ),
        ),
        child: Row(
        children: [
            SizedBox(
              width: 24,
              child: Text(
                '$position',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
                  const SizedBox(width: 8),
            Expanded(
              child: Text(
                team,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(width: 20, child: Text('2', style: TextStyle(fontSize: 12, color: Color(0xFF1A1A1A)))),
            const SizedBox(width: 20, child: Text('2', style: TextStyle(fontSize: 12, color: Color(0xFF1A1A1A)))),
            const SizedBox(width: 20, child: Text('2', style: TextStyle(fontSize: 12, color: Color(0xFF1A1A1A)))),
            const SizedBox(width: 20, child: Text('2', style: TextStyle(fontSize: 12, color: Color(0xFF1A1A1A)))),
            const SizedBox(width: 20, child: Text('2', style: TextStyle(fontSize: 12, color: Color(0xFF1A1A1A)))),
            const SizedBox(width: 4, child: Text('|', style: TextStyle(fontSize: 12, color: Color(0xFF666666)))),
            SizedBox(
              width: 20,
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '9',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    }).toList();
  }
}

class _EthiopianFlag extends StatelessWidget {
  const _EthiopianFlag();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE31E24), // Red
            Color(0xFFFCD116), // Yellow
            Color(0xFF078930), // Green
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.flag,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }
}

class _PremierLeagueLogo extends StatelessWidget {
  const _PremierLeagueLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF37003C), // Purple
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'PL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _OnlineBanner extends StatelessWidget {
  const _OnlineBanner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 8,
            height: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'You are Online.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE0E0E0),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.wifi_tethering), label: 'Live Hub'),
        BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'Compare'),
        BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'News'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: 1,
      onTap: (_) {},
      type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

