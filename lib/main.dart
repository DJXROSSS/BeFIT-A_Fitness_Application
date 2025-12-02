import 'pages/SignUp_screen.dart';
import 'services/mealgeneration.dart';
import 'package:flutter/services.dart';
import 'pages/chat_page.dart';
import 'services/app_theme.dart';
import 'pages/Login_screen.dart';
import 'services/dark_mode_controller.dart';
import 'services/frostedGlassEffect.dart';
import 'package:flutter/material.dart';
import 'pages/About_page.dart';
import 'pages/BMI_calculator.dart';
import 'pages/cardio_section.dart';
import 'pages/Suggested_page.dart';
import 'pages/home_page.dart';
import 'pages/intake_page.dart';
import 'pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ThemeController());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(BeFitApp());
}

class BeFitApp extends StatelessWidget {
  BeFitApp({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BeFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeController themeController = Get.find();
  int _selectedIndex = 2;
  bool _showSettings = false;

  final List<Widget> _pages = [
    BMIcalculatorPage(),
    DietPage(),
    MainHomePage(),
    SuggestedPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTheme.setDarkMode(themeController.isDarkMode.value);
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'BeFit',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.cardColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppTheme.accentColor),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildDrawerItem(
                context,
                Icons.monitor_heart_rounded,
                'Track Workout',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Progresspage()),
                ),
              ),
              _buildDrawerItem(
                context,
                Icons.chat_bubble_outline_rounded,
                'Ask BeFit',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                ),
              ),
              _buildDrawerItem(
                context,
                Icons.restaurant_rounded,
                'Meal Generator',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealChatPage()),
                ),
              ),
              _buildDrawerItem(
                context,
                Icons.info_outline_rounded,
                'About',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Aboutpage()),
                ),
              ),
              const Divider(),
              _buildDrawerItem(
                context,
                Icons.logout_rounded,
                'Logout',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                ),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          if (_showSettings) _buildSettingsPanel(context),
        ],
      ),
      bottomNavigationBar: _buildMinimalBottomNav(),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppTheme.primaryRed : AppTheme.accentColor,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isDestructive ? AppTheme.primaryRed : AppTheme.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSettingsPanel(BuildContext context) {
    return Positioned(
      top: kToolbarHeight + 8,
      right: 8,
      left: 8,
      child: FrostedGlassBox(
        width: double.infinity,
        height: 250,
        borderRadius: 20,
        blurAmount: 12,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showSettings = false;
                    });
                  },
                  child: Icon(Icons.close_rounded, color: AppTheme.textColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: themeController.isDarkMode.value,
                onChanged: (value) {
                  themeController.toggleDarkMode(value);
                },
                tileColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Obx(
              () => SwitchListTile(
                title: Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: themeController.notificationsEnabled.value,
                onChanged: (value) {
                  themeController.toggleNotifications(value);
                },
                tileColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(Icons.calculate_rounded, 0),
          _buildBottomNavItem(Icons.restaurant_rounded, 1),
          _buildBottomNavItem(Icons.home_rounded, 2),
          _buildBottomNavItem(Icons.fitness_center_rounded, 3),
          _buildBottomNavItem(Icons.person_rounded, 4),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppTheme.accentColor : AppTheme.subtextColor,
          size: 24,
        ),
      ),
    );
  }
}
