// import 'dart:ui';
// import '../services/frostedGlassEffect.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import '../services/motivational_service.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../services/dark_mode_controller.dart';
// import 'chat_page.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'cardio_section.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainHomePage extends StatefulWidget {
//   const MainHomePage({super.key}); // Added key for best practice

//   @override
//   State<MainHomePage> createState() => _MainHomePageState();
// }

// class _MainHomePageState extends State<MainHomePage> {
//   final ThemeController themeController = Get.find();
//   final user = FirebaseAuth.instance.currentUser;

//   final User? _user =
//       FirebaseAuth.instance.currentUser; // Use _user for consistency

//   late Future<String> _quoteFuture;

//   String _name = 'Loading...'; // Use _name for state variables
//   String _chatResponse =
//       ''; // Not directly used in this snippet, but kept from original
//   String? _calorieResult; // From SharedPreferences
//   String? _proteinResult; // From SharedPreferences
//   String? _waterIntake; // Fetched from Firestore
//   String? _stepsCount; // Fetched from Firestore
//   String? _calorieBurnedToday; // Fetched from Firestore
//   int _streakCount = 0; // Use _streakCount for consistency

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the quote future
//     _quoteFuture = MotivationService(GEMINI_API_KEY).getQuote();
//     // Load user's display name from Firestore
//     _loadUserData();
//     // Load calorie and protein results from SharedPreferences
//     _loadResults();
//     // Load daily activity data (steps, water, calories burned) from Firestore
//     _loadDailyActivityData();
//     _loadStreakCount();
//   }

//   /// Fetches the user's name from Firestore based on their UID.
//   Future<void> _loadUserData() async {
//     if (_user != null) {
//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(_user!.uid)
//             .get();
//         final data = doc.data();
//         setState(() {
//           _name = data?['name'] ?? _user!.displayName ?? 'User';
//         });
//       } catch (e) {
//         debugPrint(
//           "Error fetching user data: $e",
//         ); // Use debugPrint for Flutter logs
//         setState(() {
//           _name = 'User'; // Fallback name on error
//         });
//       }
//     } else {
//       setState(() {
//         _name = 'Guest'; // If no user is logged in
//       });
//     }
//   }

//   /// Loads last saved calorie and protein results from SharedPreferences.
//   Future<void> _loadResults() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _calorieResult = prefs.getString('last_calorie_result');
//       _proteinResult = prefs.getString('last_protein_result');
//     });
//   }

//   /// Loads daily activity data (stepCount, waterCups, calorieBurned) from Firestore.
//   /// Assumes data is stored under 'users/{uid}/activity_logs/{YYYY-MM-DD}'.
//   Future<void> _loadDailyActivityData() async {
//     if (_user != null) {
//       try {
//         // Format today's date to match the Firestore document ID format (e.g., "2025-07-06")
//         final today = DateTime.now();
//         final formattedDate =
//             "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

//         debugPrint(
//           'Attempting to load daily activity for user: ${_user!.uid} on date: $formattedDate',
//         );

//         // Construct the Firestore path to the daily activity document
//         final docSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(_user!.uid)
//             .collection(
//               'activity_logs',
//             ) // Corrected from 'dailyActivity' as per previous discussion
//             .doc(formattedDate)
//             .get();

//         if (docSnapshot.exists) {
//           // If the document exists, retrieve its data
//           final data = docSnapshot.data();
//           debugPrint('Daily activity document found. Data: $data');

//           setState(() {
//             // Assign fetched values to state variables, defaulting to '0' if null
//             _stepsCount = data?['stepCount']?.toString() ?? '0';
//             _waterIntake = data?['waterCups']?.toString() ?? '0';
//             _calorieBurnedToday = data?['calorieBurned']?.toString() ?? '0';
//           });
//           debugPrint(
//             'Steps loaded: $_stepsCount, Water loaded: $_waterIntake, Calories Burned loaded: $_calorieBurnedToday',
//           );
//         } else {
//           // If the document does not exist for today, set default '0' values
//           debugPrint(
//             "No daily activity data found for today: $formattedDate (Document does not exist)",
//           );
//           setState(() {
//             _stepsCount = '0';
//             _waterIntake = '0';
//             _calorieBurnedToday = '0';
//           });
//         }
//       } catch (e) {
//         // Catch any errors during Firestore fetching and set 'NA'
//         debugPrint("Error fetching daily activity data: $e");
//         setState(() {
//           _stepsCount = 'Start';
//           _waterIntake = 'Start';
//           _calorieBurnedToday = 'Start';
//         });
//       }
//     } else {
//       // If no user is logged in, set 'NA'
//       debugPrint("No user logged in, cannot load daily activity data.");
//       setState(() {
//         _stepsCount = 'Start';
//         _waterIntake = 'Start';
//         _calorieBurnedToday = 'Start';
//       });
//     }
//   }

//   /// Refreshes the motivational quote.
//   void _refreshQuote() {
//     setState(() {
//       _quoteFuture = MotivationService(GEMINI_API_KEY).getQuote();
//     });
//   }

//   /// Returns a greeting based on the current time of day.
//   String _getGreeting() {
//     // Changed to private method
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Good morning';
//     if (hour < 17) return 'Good afternoon';
//     return 'Good evening';
//   }

//   /// Helper function to display 'NA' for null, empty, or '0' values.
//   String displayValue(String? value, {String? fallback}) {
//     // Changed to private method
//     if (value == null || value.isEmpty || value == '0') {
//       return fallback ?? 'NA'; // Use fallback if provided, else default to 'NA'
//     }
//     return value;
//   }

//   Future<void> _loadStreakCount() async {
//     // Changed to private method
//     if (_user == null) return;

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(_user!.uid)
//         .collection('activity_logs') // Assuming streak is stored here
//         .doc('streak') // Assuming a specific document for streak
//         .get();

//     if (doc.exists) {
//       final data = doc.data();
//       setState(() {
//         _streakCount = data?['streakCount'] ?? 0;
//       });
//     } else {
//       debugPrint("No streak document found for user: ${_user!.uid}");
//       setState(() {
//         _streakCount = 0; // Reset to 0 if no streak document
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     themeController.onThemeChanged = () {
//       if (mounted) setState(() {});
//     };
//     return Scaffold(
//       extendBody: true,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppTheme.appBarBg,
//               AppTheme.backgroundColor,
//               AppTheme.appBarBg,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),

//                 // Motivational Quote Section
//                 FutureBuilder<String>(
//                   future: _quoteFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       debugPrint('Error loading quote: ${snapshot.error}');
//                       return Text(
//                         "❌ Couldn't load quote",
//                         style: TextStyle(color: AppTheme.titleTextColor),
//                       );
//                     } else {
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppTheme.appBarBg.withOpacity(0.85),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: const [
//                             // Changed to const for optimization
//                             BoxShadow(
//                               color: Colors.black38,
//                               blurRadius: 8,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 '"${snapshot.data!}"',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontStyle: FontStyle.italic,
//                                   color: AppTheme.titleTextColor,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.refresh,
//                                 color: AppTheme.titleTextColor,
//                               ),
//                               onPressed: _refreshQuote,
//                               tooltip: "Refresh Quote",
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                 ),

//                 // Greeting and User Name
//                 Text(
//                   '${_getGreeting()},',
//                   style: GoogleFonts.notoSans(
//                     color: AppTheme.textColor,
//                     fontSize: 18,
//                     shadows: [
//                       Shadow(
//                         offset: Offset(0, 0),
//                         blurRadius: 10,
//                         color: Colors.black.withOpacity(0.15),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   _name, // Use private _name
//                   style: GoogleFonts.berkshireSwash(
//                     color: AppTheme.textColor,
//                     fontSize: 40,
//                     shadows: [
//                       Shadow(
//                         offset: const Offset(0, 0),
//                         blurRadius: 8,
//                         color: Colors.black.withOpacity(0.1),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // Workout Streak Section
//                 _buildWorkoutStreak(), // Changed to private method

//                 const SizedBox(height: 10),

//                 // Daily Goals Card (now includes Firestore data)
//                 _buildDailyGoals(), // Changed to private method

//                 const SizedBox(height: 20),

//                 // Start Workout Button
//                 Align(
//                   alignment: Alignment.center,
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.75,
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         // Removed const here as WidgetStateProperty.all might not be const callable
//                         backgroundColor: WidgetStateProperty.all(
//                           AppTheme.appBarBg,
//                         ), // Changed from WidgetStatePropertyAll
//                         elevation: WidgetStateProperty.all(
//                           6,
//                         ), // Changed from WidgetStatePropertyAll
//                       ),
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Progresspage()),
//                       ),
//                       child: Text(
//                         'Start Workout',
//                         style: TextStyle(
//                           color: AppTheme.titleTextColor,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Builds the workout streak display.
//   Widget _buildWorkoutStreak() {
//     // Changed to private method
//     return Center(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.88,
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         decoration: BoxDecoration(
//           color: Colors.transparent, // Keeps color transparent
//           borderRadius: BorderRadius.circular(28.0),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '🔥 Workout Streak',
//               style: GoogleFonts.notoSans(
//                 color: AppTheme.textColor,
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 shadows: [
//                   Shadow(
//                     offset: Offset(0, 0),
//                     blurRadius: 8,
//                     color: Colors.black.withOpacity(0.15),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             FrostedGlassBox(
//               width: double.infinity,
//               height: 60,
//               color: AppTheme.titleTextColor.withOpacity(0.15),
//               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(7, (index) {
//                   return index <
//                           _streakCount // Use private _streakCount
//                       ? const Text('🔥', style: TextStyle(fontSize: 28))
//                       : Text(
//                           '◯',
//                           style: TextStyle(
//                             fontSize: 28,
//                             color: AppTheme.titleTextColor,
//                           ),
//                         );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Builds the daily goals display, including data from SharedPreferences and Firestore.
//   Widget _buildDailyGoals() {
//     // Changed to private method
//     return Align(
//       alignment: Alignment.center,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         width: MediaQuery.of(context).size.width * 0.84,
//         height: 350,
//         decoration: BoxDecoration(
//           color: AppTheme.cardColor,
//           borderRadius: BorderRadius.circular(28.0),
//           boxShadow: [
//             BoxShadow(
//               color: AppTheme.appBarBg.withOpacity(0.35),
//               blurRadius: 4,
//               offset: const Offset(0, 3), // Added const
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'Daily Goals',
//               style: GoogleFonts.notoSans(
//                 color: AppTheme.textColor,
//                 fontSize: 24,
//                 letterSpacing: 1,
//                 shadows: [
//                   Shadow(
//                     offset: Offset(0, 0),
//                     blurRadius: 10,
//                     color: Colors.black.withOpacity(0.15),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Display Protein from SharedPreferences
//                 dailyGoalsTile(
//                   'Protein',
//                   displayValue(_proteinResult, fallback: '+/-'),
//                   themeController.isDarkMode.value
//                       ? Color(0xFF000000)
//                       : Colors.teal.shade400,
//                 ),
//                 // Display Calories from SharedPreferences
//                 dailyGoalsTile(
//                   'Calories',
//                   displayValue(_calorieResult, fallback: '+/-'),
//                   themeController.isDarkMode.value
//                       ? Color(0xFF000000)
//                       : Colors.red.shade400,
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Display Water from Firestore (waterCups)
//                 dailyGoalsTile(
//                   'Water',
//                   '${displayValue(_waterIntake)} cups',
//                   themeController.isDarkMode.value
//                       ? Color(0xFF000000)
//                       : Colors.blueAccent,
//                 ),
//                 // Display Steps from Firestore (stepCount)
//                 dailyGoalsTile(
//                   'Steps',
//                   displayValue(_stepsCount),
//                   themeController.isDarkMode.value
//                       ? Color(0xFF000000)
//                       : Colors.orange,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// A reusable tile widget for displaying daily goals.
//   Widget dailyGoalsTile(String title, String value, Color color) {
//     // Changed to private method
//     double height = 120;
//     double radius = height / 2;
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.32,
//       height: height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.6),
//             blurRadius: 20,
//             offset: const Offset(2, 2), // Added const
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(radius),
//         child: BackdropFilter(
//           blendMode: BlendMode.luminosity,
//           filter: ImageFilter.blur(
//             sigmaX: 0.0,
//             sigmaY: 0.0,
//           ), // Sigma values are 0.0, so blur is effectively off.
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(radius + 2),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.notoSans(
//                     color: AppTheme.textColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   value,
//                   style: GoogleFonts.notoSans(
//                     color: AppTheme.textColor,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import '../services/frostedGlassEffect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/app_theme.dart';
import '../services/motivational_service.dart';
import 'package:get/get.dart';
import '../services/dark_mode_controller.dart';
import 'chat_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cardio_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with SingleTickerProviderStateMixin {
  final ThemeController themeController = Get.find();
  final user = FirebaseAuth.instance.currentUser;
  final User? _user = FirebaseAuth.instance.currentUser;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late Future<String> _quoteFuture;
  String _name = 'Loading...';
  String _chatResponse = '';
  String? _calorieResult;
  String? _proteinResult;
  String? _waterIntake;
  String? _stepsCount;
  String? _calorieBurnedToday;
  int _streakCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _quoteFuture = MotivationService(GEMINI_API_KEY).getQuote();
    _loadUserData();
    _loadResults();
    _loadDailyActivityData();
    _loadStreakCount();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        final data = doc.data();
        setState(() {
          _name = data?['name'] ?? _user!.displayName ?? 'User';
        });
      } catch (e) {
        debugPrint("Error fetching user data: $e");
        setState(() {
          _name = 'User';
        });
      }
    } else {
      setState(() {
        _name = 'Guest';
      });
    }
  }

  Future<void> _loadResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _calorieResult = prefs.getString('last_calorie_result');
      _proteinResult = prefs.getString('last_protein_result');
    });
  }

  Future<void> _loadDailyActivityData() async {
    if (_user != null) {
      try {
        final today = DateTime.now();
        final formattedDate =
            "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('activity_logs')
            .doc(formattedDate)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            _stepsCount = data?['stepCount']?.toString() ?? '0';
            _waterIntake = data?['waterCups']?.toString() ?? '0';
            _calorieBurnedToday = data?['calorieBurned']?.toString() ?? '0';
          });
        } else {
          setState(() {
            _stepsCount = '0';
            _waterIntake = '0';
            _calorieBurnedToday = '0';
          });
        }
      } catch (e) {
        debugPrint("Error fetching daily activity data: $e");
        setState(() {
          _stepsCount = 'Start';
          _waterIntake = 'Start';
          _calorieBurnedToday = 'Start';
        });
      }
    }
  }

  void _refreshQuote() {
    setState(() {
      _quoteFuture = MotivationService(GEMINI_API_KEY).getQuote();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String displayValue(String? value, {String? fallback}) {
    if (value == null || value.isEmpty || value == '0') {
      return fallback ?? 'NA';
    }
    return value;
  }

  Future<void> _loadStreakCount() async {
    if (_user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('activity_logs')
        .doc('streak')
        .get();

    if (doc.exists) {
      final data = doc.data();
      setState(() {
        _streakCount = data?['streakCount'] ?? 0;
      });
    }
  }

  int _selectedDayIndex = 0;
  final List<String> _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    themeController.onThemeChanged = () {
      if (mounted) setState(() {});
    };

    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      extendBody: true,
      backgroundColor: isDark ? Color(0xFF000000) : Color(0xFFe4e2de),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildAppHeader(isDark),
                  const SizedBox(height: 32),
                  _buildMyActivitySection(isDark),
                  const SizedBox(height: 24),
                  _buildDaySelector(isDark),
                  const SizedBox(height: 32),
                  _buildCircularProgress(isDark),
                  const SizedBox(height: 32),
                  _buildDailyIntakeSection(isDark),
                  const SizedBox(height: 24),
                  _buildStartWorkoutButton(isDark),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1a1a1a) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Icon(
              Icons.menu_rounded,
              color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
              size: 22,
            ),
          ),
        ),
        Text(
          'BeFit',
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
            letterSpacing: -0.5,
          ),
        ),
        GestureDetector(
          onTap: () => themeController.toggleSettings(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1a1a1a) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Icon(
              Icons.settings_outlined,
              color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyActivitySection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Activity',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
          ),
        ),
        Text(
          DateFormat('MMM d, yyyy').format(DateTime.now()),
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector(bool isDark) {
    final today = DateTime.now().weekday % 7;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = index == today;
        return GestureDetector(
          onTap: () => setState(() => _selectedDayIndex = index),
          child: Container(
            width: 44,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFF000000)
                  : isDark
                  ? Color(0xFF1a1a1a)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : isDark
                    ? Colors.white12
                    : Colors.black12,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _days[index],
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isDark
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateTime.now().subtract(Duration(days: today - index)).day}',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : isDark
                        ? Color(0xFFe4e2de)
                        : Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCircularProgress(bool isDark) {
    final calorieTarget = 2000.0;
    final currentCalories = double.tryParse(_calorieResult ?? '0') ?? 0;
    final progress = (currentCalories / calorieTarget).clamp(0.0, 1.0);

    return Center(
      child: Container(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Color(0xFF1a1a1a) : Colors.white,
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                  width: 1,
                ),
              ),
            ),
            // Progress arc
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: isDark ? Color(0xFF2a2a2a) : Color(0xFFf0f0f0),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000000)),
                strokeCap: StrokeCap.round,
              ),
            ),
            // Inner content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 32,
                  color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
                ),
                const SizedBox(height: 8),
                Text(
                  displayValue(_calorieResult),
                  style: GoogleFonts.notoSans(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  'of ${calorieTarget.toInt()} kcal',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyIntakeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Intake',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildIntakeCard(
                isDark: isDark,
                icon: Icons.egg_rounded,
                label: 'Protein',
                value: displayValue(_proteinResult),
                unit: 'g',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIntakeCard(
                isDark: isDark,
                icon: Icons.water_drop_rounded,
                label: 'Water',
                value: displayValue(_waterIntake),
                unit: 'cups',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIntakeCard(
                isDark: isDark,
                icon: Icons.directions_walk_rounded,
                label: 'Steps',
                value: displayValue(_stepsCount),
                unit: '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntakeCard({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1a1a1a) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
            ),
          ),
          Text(
            unit.isNotEmpty ? '$label ($unit)' : label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: GoogleFonts.notoSans(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.black54,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _name,
          style: GoogleFonts.notoSans(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalCard(bool isDark) {
    return FutureBuilder<String>(
      future: _quoteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildNeumorphicContainer(
            isDark: isDark,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    isDark ? Colors.white38 : Colors.black26,
                  ),
                ),
              ),
            ),
            height: 140,
          );
        } else if (snapshot.hasError) {
          return _buildNeumorphicContainer(
            isDark: isDark,
            child: Center(
              child: Text(
                "Unable to load quote",
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
            height: 140,
          );
        } else {
          return _buildLiquidGlassCard(
            isDark: isDark,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFF000000),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Daily Inspiration',
                              style: GoogleFonts.notoSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black54,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '"${snapshot.data!}"',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                            height: 1.5,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildNeumorphicIconButton(
                    isDark: isDark,
                    icon: Icons.refresh_rounded,
                    onPressed: _refreshQuote,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildStreakCard(bool isDark) {
    return _buildLiquidGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF000000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout Streak',
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          '$_streakCount day${_streakCount != 1 ? 's' : ''} strong',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final isCompleted = index < _streakCount;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? Color(0xFF000000)
                        : isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white38 : Colors.black26,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRings(bool isDark) {
    final calorieValue = double.tryParse(_calorieResult ?? '0') ?? 0;
    final proteinValue = double.tryParse(_proteinResult ?? '0') ?? 0;
    final stepsValue = double.tryParse(_stepsCount ?? '0') ?? 0;

    return _buildLiquidGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActivityRing(
              isDark: isDark,
              value: (calorieValue / 2000).clamp(0, 1),
              color: Color(0xFFFF006E),
              label: 'Calories',
              icon: Icons.local_fire_department_rounded,
            ),
            _buildActivityRing(
              isDark: isDark,
              value: (proteinValue / 150).clamp(0, 1),
              color: Color(0xFF00D9FF),
              label: 'Protein',
              icon: Icons.fitness_center_rounded,
            ),
            _buildActivityRing(
              isDark: isDark,
              value: (stepsValue / 10000).clamp(0, 1),
              color: Color(0xFF7FFF00),
              label: 'Steps',
              icon: Icons.directions_walk_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRing({
    required bool isDark,
    required double value,
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation(
                  isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
            ),
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Icon(icon, color: color, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyMetrics(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Today\'s Progress',
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _buildMetricCard(
              isDark: isDark,
              label: 'Calories',
              value: displayValue(_calorieResult),
              unit: 'kcal',
              icon: Icons.local_fire_department_rounded,
            ),
            _buildMetricCard(
              isDark: isDark,
              label: 'Protein',
              value: displayValue(_proteinResult),
              unit: 'g',
              icon: Icons.egg_rounded,
            ),
            _buildMetricCard(
              isDark: isDark,
              label: 'Water',
              value: displayValue(_waterIntake),
              unit: 'cups',
              icon: Icons.water_drop_rounded,
            ),
            _buildMetricCard(
              isDark: isDark,
              label: 'Steps',
              value: displayValue(_stepsCount),
              unit: '',
              icon: Icons.directions_walk_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String label,
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return _buildNeumorphicContainer(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(0xFF000000),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.notoSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          unit,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartWorkoutButton(bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Progresspage()),
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFFe4e2de) : Color(0xFF000000),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Start Workout',
            style: GoogleFonts.notoSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? Color(0xFF000000) : Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiquidGlassCard({required bool isDark, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ]
                  : [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildNeumorphicContainer({
    required bool isDark,
    required Widget child,
    double? height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1a1a2e) : Color(0xFFe8eaf6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildNeumorphicIconButton({
    required bool isDark,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1a1a2e) : Color(0xFFe8eaf6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 20,
        ),
      ),
    );
  }
}
