import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/app_theme.dart';
import 'weight_details_page.dart';

class Progresspage extends StatefulWidget {
  const Progresspage({Key? key}) : super(key: key);

  @override
  State<Progresspage> createState() => _ProgresspageState();
}

class _ProgresspageState extends State<Progresspage> {
  int waterCups = 0;
  int calories = 0;
  int steps = 0;
  double currentWeight = 0.0;
  List<Map<String, dynamic>> weeklyData = [];

  Timer? _timer;
  int _seconds = 0;
  double _caloriesBurned = 0.0;
  final double caloriesPerSecond = 0.123;

  int _savedSteps = 0;

  @override
  void initState() {
    super.initState();
    _loadTodayData();
    _fetchLatestWeight();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _caloriesBurned = _seconds * caloriesPerSecond;
        steps = _savedSteps + (_seconds / 2).floor();
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  Future<void> _saveProgressAndReset() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final now = DateTime.now();
    final docId =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_logs')
        .doc(docId);

    await docRef.set({
      'calorieBurned': _caloriesBurned,
      'stepCount': steps,
      'waterCups': waterCups,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    setState(() {
      _seconds = 0;
      _caloriesBurned = 0.0;
      _savedSteps = steps;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Progress saved to Firebase.")),
    );

    _loadTodayData();
  }

  Future<void> saveDailyProgress({
    required int calories,
    required int steps,
    required int waterCups,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = DateTime.now();
    final docId =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_logs')
        .doc(docId)
        .set({
          'calorieBurned': calories,
          'stepCount': steps,
          'waterCups': waterCups,
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> fetchTodayProgress() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = DateTime.now();
    final docId =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_logs')
        .doc(docId)
        .get();

    return doc.exists ? doc.data() as Map<String, dynamic> : {};
  }

  Future<List<Map<String, dynamic>>> fetchPast7DaysProgress() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = DateTime.now();
    final DateTime startOfToday = DateTime(today.year, today.month, today.day);
    final DateTime weekAgo = startOfToday.subtract(const Duration(days: 6));
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_logs')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .orderBy('timestamp')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> _fetchLatestWeight() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('weight_logs')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final weight = (data['weight'] as num?)?.toDouble() ?? 0.0;
      setState(() {
        currentWeight = weight;
      });
    }
  }

  Future<void> _loadTodayData() async {
    final data = await fetchTodayProgress();
    final weekData = await fetchPast7DaysProgress();
    setState(() {
      calories = data['calorieBurned']?.toInt() ?? 0;
      steps = data['stepCount']?.toInt() ?? 0;
      _savedSteps = steps;
      waterCups = data['waterCups'] ?? 0;
      weeklyData = weekData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Track Workout'),
        centerTitle: true,
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildDailyView(MediaQuery.of(context).size.width),
            const SizedBox(height: 24),
            _buildWaterIntakeCard(),
            const SizedBox(height: 20),
            _buildCaloriesAndStepsCard(),
            const SizedBox(height: 20),
            _buildWeightDetailsCard(),
            if (weeklyData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.dividerColor,
                          width: 0.5,
                        ),
                      ),
                      child: SizedBox(
                        height: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: weeklyData.map((data) {
                            final timestamp = data['timestamp'] as Timestamp?;
                            final date = timestamp?.toDate() ?? DateTime.now();
                            final day = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ][date.weekday - 1];
                            final steps =
                                (data['stepCount'] as num?)?.toDouble() ?? 0.0;
                            final calories =
                                (data['calorieBurned'] as num?)?.toDouble() ??
                                0.0;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: (steps / 2000) * 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryGreen,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 8,
                                      height: (calories / 200) * 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryOrange,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.subtextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _standardCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDailyView(double width) {
    final duration = Duration(seconds: _seconds);
    final time =
        "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";

    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Calories Burned: ${_caloriesBurned.toStringAsFixed(2)} kcal",
          style: TextStyle(fontSize: 16, color: AppTheme.textColor),
        ),
        const SizedBox(height: 8),
        Text(
          "Steps: $steps",
          style: TextStyle(fontSize: 16, color: AppTheme.textColor),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
              onPressed: _startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
              onPressed: _pauseTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: () async {
                await updateStreakOnWorkout();
                await _saveProgressAndReset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaterIntakeCard() {
    return _standardCard(
      title: 'Water Intake',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cups: $waterCups',
            style: TextStyle(fontSize: 18, color: AppTheme.textColor),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: AppTheme.primaryRed,
                ),
                onPressed: () {
                  setState(() {
                    if (waterCups > 0) waterCups--;
                  });
                  saveDailyProgress(
                    calories: calories,
                    steps: steps,
                    waterCups: waterCups,
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.primaryGreen,
                ),
                onPressed: () {
                  setState(() {
                    waterCups++;
                  });
                  saveDailyProgress(
                    calories: calories,
                    steps: steps,
                    waterCups: waterCups,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesAndStepsCard() {
    return _standardCard(
      title: 'Daily Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department, color: AppTheme.primaryOrange),
              const SizedBox(width: 12),
              Text(
                'Total Calories Burned: $calories kcal',
                style: TextStyle(fontSize: 16, color: AppTheme.textColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.directions_walk, color: AppTheme.primaryGreen),
              const SizedBox(width: 12),
              Text(
                'Total Steps: $steps',
                style: TextStyle(fontSize: 16, color: AppTheme.textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightDetailsCard() {
    return _standardCard(
      title: 'Weight Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Weight: ${currentWeight.toStringAsFixed(1)} kg',
            style: TextStyle(fontSize: 16, color: AppTheme.textColor),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeightDetailsPage(),
                  ),
                );
                _fetchLatestWeight();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View/Add Weight Details'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> updateStreakOnWorkout() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final now = DateTime.now();
  final todayStr =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final streakDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('activity_logs')
      .doc('streak');

  final streakDoc = await streakDocRef.get();

  if (streakDoc.exists) {
    final data = streakDoc.data();
    final lastDateStr = data?['lastWorkoutDate'];
    final lastDate = DateTime.tryParse(lastDateStr ?? '') ?? DateTime(2000);
    final streakCount = data?['streakCount'] ?? 0;

    final difference = now.difference(lastDate).inDays;

    if (difference == 1) {
      await streakDocRef.set({
        'streakCount': streakCount + 1,
        'lastWorkoutDate': todayStr,
      });
    } else if (difference == 0) {
      // Already logged today – do nothing
    } else {
      await streakDocRef.set({'streakCount': 1, 'lastWorkoutDate': todayStr});
    }
  } else {
    await streakDocRef.set({'streakCount': 1, 'lastWorkoutDate': todayStr});
  }
}
