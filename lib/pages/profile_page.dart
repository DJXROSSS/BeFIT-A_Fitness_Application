// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import 'edit_profile_page.dart'; // Make sure to import the edit page

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String name = 'Loading...';
//   String email = '';
//   String photoUrl = '';
//   String gender = '';
//   int streakCount = 0;
//   int totalSteps = 0;
//   double calorieBurned = 0;
//   int waterCups = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     fetchTodayStats();
//     fetchStreak();
//   }

//   Future<void> fetchUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();
//         final data = doc.data();

//         setState(() {
//           name = data?['name'] ?? user.displayName ?? 'No Name';
//           email = data?['email'] ?? user.email ?? 'No Email';
//           photoUrl = data?['photoUrl'] ?? user.photoURL ?? '';
//           gender = data?['gender'] ?? '';
//           streakCount = data?['streak'] ?? 0;
//         });
//       } catch (e) {
//         print("Error fetching user data: $e");
//       }
//     }
//   }

//   Future<void> fetchTodayStats() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         final today = DateTime.now();
//         final todayKey =
//             "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .collection('activity_logs')
//             .doc(todayKey)
//             .get();

//         if (doc.exists) {
//           final data = doc.data();
//           setState(() {
//             totalSteps = data?['stepCount'] ?? 0;
//             calorieBurned = (data?['calorieBurned'] ?? 0).toDouble();
//             waterCups = data?['waterCups'] ?? 0;
//           });
//         } else {
//           setState(() {
//             totalSteps = 0;
//             calorieBurned = 0;
//             waterCups = 0;
//           });
//         }
//       } catch (e) {
//         print("Error fetching today's activity log: $e");
//       }
//     }
//   }

//   Future<void> fetchStreak() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         final streakDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .collection('activity_logs')
//             .doc('streak')
//             .get();

//         if (streakDoc.exists) {
//           final data = streakDoc.data();
//           setState(() {
//             streakCount = data?['streakCount'] ?? 0;
//           });
//         }
//       } catch (e) {
//         print("Error fetching streak: $e");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "Your Profile",
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.w700,
//                         color: AppTheme.textColor,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppTheme.accentColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.edit_rounded,
//                         color: AppTheme.accentColor,
//                       ),
//                       onPressed: () async {
//                         final updated = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => EditProfilePage(
//                               currentName: name,
//                               currentEmail: email,
//                               currentPhotoUrl: photoUrl,
//                             ),
//                           ),
//                         );
//                         if (updated == true) fetchUserData();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               _buildProfileHeader(),
//               const SizedBox(height: 32),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Today's Stats",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: AppTheme.textColor,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _buildStatCard(
//                 Icons.emoji_events_outlined,
//                 "Streak",
//                 "$streakCount days",
//                 AppTheme.primaryOrange,
//               ),
//               const SizedBox(height: 12),
//               _buildStatCard(
//                 Icons.directions_walk_rounded,
//                 "Steps",
//                 "$totalSteps",
//                 AppTheme.primaryGreen,
//               ),
//               const SizedBox(height: 12),
//               _buildStatCard(
//                 Icons.local_fire_department_rounded,
//                 "Calories",
//                 "${calorieBurned.toStringAsFixed(0)} kcal",
//                 AppTheme.primaryRed,
//               ),
//               const SizedBox(height: 12),
//               _buildStatCard(
//                 Icons.local_drink_rounded,
//                 "Water",
//                 "$waterCups cups",
//                 AppTheme.accentColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     ImageProvider imageProvider;

//     if (photoUrl.isNotEmpty) {
//       imageProvider = NetworkImage(photoUrl);
//     } else if (gender == 'Male') {
//       imageProvider = AssetImage('assets/images/default_male.png');
//     } else if (gender == 'Female') {
//       imageProvider = AssetImage('assets/images/default_female.png');
//     } else {
//       imageProvider = AssetImage('assets/images/default.png');
//     }

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppTheme.dividerColor, width: 0.5),
//         boxShadow: [
//           BoxShadow(
//             color: AppTheme.isDarkMode
//                 ? Colors.black.withOpacity(0.2)
//                 : Colors.grey.withOpacity(0.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: AppTheme.accentColor, width: 2),
//             ),
//             child: CircleAvatar(radius: 50, backgroundImage: imageProvider),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             name,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//               color: AppTheme.textColor,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             email,
//             style: TextStyle(fontSize: 14, color: AppTheme.subtextColor),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     IconData icon,
//     String label,
//     String value,
//     Color iconColor,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppTheme.dividerColor, width: 0.5),
//         boxShadow: [
//           BoxShadow(
//             color: AppTheme.isDarkMode
//                 ? Colors.black.withOpacity(0.2)
//                 : Colors.grey.withOpacity(0.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 24, color: iconColor),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: AppTheme.subtextColor,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     color: AppTheme.textColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/app_theme.dart';
import 'edit_profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../services/dark_mode_controller.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final ThemeController themeController = Get.find();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String name = 'Loading...';
  String email = '';
  String photoUrl = '';
  String gender = '';
  int streakCount = 0;
  int totalSteps = 0;
  double calorieBurned = 0;
  int waterCups = 0;

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

    fetchUserData();
    fetchTodayStats();
    fetchStreak();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data();

        setState(() {
          name = data?['name'] ?? user.displayName ?? 'No Name';
          email = data?['email'] ?? user.email ?? 'No Email';
          photoUrl = data?['photoUrl'] ?? user.photoURL ?? '';
          gender = data?['gender'] ?? '';
          streakCount = data?['streak'] ?? 0;
        });
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> fetchTodayStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final today = DateTime.now();
        final todayKey =
            "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('activity_logs')
            .doc(todayKey)
            .get();

        if (doc.exists) {
          final data = doc.data();
          setState(() {
            totalSteps = data?['stepCount'] ?? 0;
            calorieBurned = (data?['calorieBurned'] ?? 0).toDouble();
            waterCups = data?['waterCups'] ?? 0;
          });
        } else {
          setState(() {
            totalSteps = 0;
            calorieBurned = 0;
            waterCups = 0;
          });
        }
      } catch (e) {
        print("Error fetching today's activity log: $e");
      }
    }
  }

  Future<void> fetchStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final streakDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('activity_logs')
            .doc('streak')
            .get();

        if (streakDoc.exists) {
          final data = streakDoc.data();
          setState(() {
            streakCount = data?['streakCount'] ?? 0;
          });
        }
      } catch (e) {
        print("Error fetching streak: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      extendBody: true,
      body: Container(
        color: isDark ? Color(0xFF000000) : Color(0xFFe4e2de),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(isDark),
                        const SizedBox(height: 32),
                        _buildProfileCard(isDark),
                        const SizedBox(height: 32),
                        _buildStatsSection(isDark),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile',
          style: GoogleFonts.notoSans(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -0.8,
          ),
        ),
        _buildNeumorphicIconButton(
          isDark: isDark,
          icon: Icons.edit_rounded,
          onPressed: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfilePage(
                  currentName: name,
                  currentEmail: email,
                  currentPhotoUrl: photoUrl,
                ),
              ),
            );
            if (updated == true) {
              fetchUserData();
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(bool isDark) {
    ImageProvider imageProvider;

    if (photoUrl.isNotEmpty) {
      imageProvider = NetworkImage(photoUrl);
    } else if (gender == 'Male') {
      imageProvider = AssetImage('assets/images/default_male.png');
    } else if (gender == 'Female') {
      imageProvider = AssetImage('assets/images/default_female.png');
    } else {
      imageProvider = AssetImage('assets/images/default.png');
    }

    return _buildLiquidGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF000000),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.4),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Color(0xFF1a1a2e) : Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF000000),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: GoogleFonts.notoSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProfileStat(isDark, '$streakCount', 'Day Streak'),
                Container(
                  width: 1,
                  height: 40,
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
                _buildProfileStat(isDark, '$totalSteps', 'Steps Today'),
                Container(
                  width: 1,
                  height: 40,
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
                _buildProfileStat(
                  isDark,
                  '${calorieBurned.toInt()}',
                  'Calories',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(bool isDark, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.notoSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Today\'s Activity',
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ),
        _buildStatCard(
          isDark: isDark,
          icon: Icons.local_fire_department_rounded,
          label: 'Workout Streak',
          value: '$streakCount days',
          gradientColors: [Color(0xFFf12711), Color(0xFFf5af19)],
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          isDark: isDark,
          icon: Icons.directions_walk_rounded,
          label: 'Total Steps',
          value: '$totalSteps',
          gradientColors: [Color(0xFF7FFF00), Color(0xFF00CC66)],
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          isDark: isDark,
          icon: Icons.local_fire_department_rounded,
          label: 'Calories Burned',
          value: '${calorieBurned.toStringAsFixed(0)} kcal',
          gradientColors: [Color(0xFFFF006E), Color(0xFFFF4D00)],
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          isDark: isDark,
          icon: Icons.water_drop_rounded,
          label: 'Water Intake',
          value: '$waterCups cups',
          gradientColors: [Color(0xFF4D9FFF), Color(0xFF00B4D8)],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradientColors,
  }) {
    return _buildNeumorphicContainer(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF000000),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.notoSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white30 : Colors.black26,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidGlassCard({required bool isDark, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF000000) : Color(0xFFe4e2de),
            borderRadius: BorderRadius.circular(24),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1a1a2e) : Color(0xFFe8eaf6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.1),
            offset: Offset(8, 8),
            blurRadius: 16,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.9),
            offset: Offset(-8, -8),
            blurRadius: 16,
          ),
        ],
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1a1a2e) : Color(0xFFe8eaf6),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.08),
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.white.withOpacity(0.9),
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 22,
        ),
      ),
    );
  }
}
