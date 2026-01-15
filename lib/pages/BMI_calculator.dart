// import '../services/frostedGlassEffect.dart';
// import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import '../services/app_theme.dart';

// class BMIcalculatorPage extends StatelessWidget {
//   const BMIcalculatorPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BMICalculator();
//   }
// }

// class BMICalculator extends StatefulWidget {
//   const BMICalculator({super.key});

//   @override
//   State<BMICalculator> createState() => _BMICalculatorState();
// }

// class _BMICalculatorState extends State<BMICalculator> {
//   String gender = 'Male';
//   String _displaytext = "";
//   Color _color = Colors.transparent;
//   String _image = 'assets/bmi_images/bmi1.png';
//   final TextEditingController _weightcontroller = TextEditingController();
//   final TextEditingController _heightcontroller = TextEditingController();
//   final TextEditingController result = TextEditingController();

//   void BMIcalculate(String weight, String height) {
//     if (weight.isEmpty || height.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter both weight and height")),
//       );
//       return;
//     }

//     double? squareweight = double.tryParse(weight);
//     double? squareheight = double.tryParse(height);

//     if (squareweight == null || squareheight == null || squareheight == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Invalid input. Please check your entries."),
//         ),
//       );
//       return;
//     }

//     double res = (squareweight * 10000) / (squareheight * squareheight);

//     setState(() {
//       result.text = res.toStringAsFixed(2);

//       if (res < 18.5) {
//         _displaytext = "UNDERWEIGHT";
//         _image = 'assets/bmi_images/bmi1.png';
//         _color = Colors.blueAccent;
//       } else if (res <= 24.9) {
//         _displaytext = "NORMAL";
//         _color = Colors.green;
//         _image = 'assets/bmi_images/bmi2.png';
//       } else if (res <= 29.9) {
//         _displaytext = "OVERWEIGHT";
//         _color = Colors.amber;
//         _image = 'assets/bmi_images/bmi3.png';
//       } else if (res <= 39.9) {
//         _displaytext = "OBESE";
//         _color = Colors.deepOrange;
//         _image = 'assets/bmi_images/bmi4.png';
//       } else {
//         _displaytext = "MORBIDlY OBESE";
//         _color = Colors.red;
//         _image = 'assets/bmi_images/bmi5.png';
//       }
//     });
//   }

//   Widget _customInputField(TextEditingController? controller, String hint) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: TextField(
//         controller: controller,
//         keyboardType: const TextInputType.numberWithOptions(decimal: true),
//         style: const TextStyle(color: Colors.black),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.grey.shade100.withOpacity(0.95),
//           hintText: hint,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 18,
//             vertical: 16,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppTheme.titleTextColor, width: 1.5),
//             borderRadius: BorderRadius.circular(18),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(18),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _genderSelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: ['Male', 'Female', 'Other'].map((g) {
//         final isSelected = gender == g;
//         return GestureDetector(
//           onTap: () => setState(() => gender = g),
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 6),
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//             decoration: BoxDecoration(
//               color: isSelected ? AppTheme.accentColor : Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.grey),
//             ),
//             child: Text(
//               g,
//               style: TextStyle(
//                 color: isSelected ? AppTheme.titleTextColor : Colors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppTheme.appBarBg,
//               AppTheme.backgroundColor,
//               AppTheme.appBarBg,
//             ],
//             stops: [0, 0.6, 1],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 FrostedGlassBox(
//                   color: AppTheme.titleTextColor.withValues(alpha: 0.35),
//                   width: double.infinity,
//                   height: 60,
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Center(
//                     child: Text(
//                       'BMI Calculator',
//                       style: TextStyle(
//                         color: AppTheme.titleTextColor,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Please enter your details',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: AppTheme.titleTextColor,
//                     letterSpacing: 1,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 _customInputField(_weightcontroller, 'Enter your weight (kgs)'),
//                 _customInputField(
//                   _heightcontroller,
//                   'Enter your height (centi-meters)',
//                 ),
//                 _customInputField(null, 'Enter your age'),
//                 const SizedBox(height: 10),
//                 _genderSelector(),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       BMIcalculate(
//                         _weightcontroller.text,
//                         _heightcontroller.text,
//                       );
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             side: BorderSide(
//                               color: _color.withOpacity(0.7),
//                               strokeAlign: BorderSide.strokeAlignCenter,
//                               width: 6,
//                             ),
//                           ),
//                           backgroundColor: AppTheme.accentColor,
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(),
//                                 padding: EdgeInsets.all(16),
//                                 width: 250,
//                                 height: 200,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(20),
//                                   child: Image.asset(_image, fit: BoxFit.fill),
//                                 ),
//                               ),
//                               // const SizedBox(height: 10),
//                               Text(
//                                 'Your calculated BMI is ${result.text}',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: AppTheme.titleTextColor,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 15),
//                               AnimatedTextKit(
//                                 animatedTexts: [
//                                   TyperAnimatedText(
//                                     speed: Duration(milliseconds: 100),
//                                     _displaytext,
//                                     textStyle: TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       shadows: [
//                                         Shadow(
//                                           blurRadius: 20,
//                                           offset: const Offset(0, -5),
//                                           color: _color,
//                                         ),
//                                         Shadow(
//                                           blurRadius: 20,
//                                           offset: const Offset(-5, 0),
//                                           color: _color,
//                                         ),
//                                         Shadow(
//                                           blurRadius: 20,
//                                           offset: const Offset(0, 5),
//                                           color: _color,
//                                         ),
//                                         Shadow(
//                                           blurRadius: 20,
//                                           offset: const Offset(5, 0),
//                                           color: _color,
//                                         ),
//                                       ],
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppTheme.titleTextColor,
//                                     ),
//                                   ),
//                                 ],
//                                 isRepeatingAnimation: false,
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(),
//                               child: Text(
//                                 'Close',
//                                 style: TextStyle(
//                                   color: AppTheme.titleTextColor,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.appBarBg.withOpacity(0.1),
//                     ),
//                     child: Text(
//                       'Calculate',
//                       style: TextStyle(
//                         fontSize: 20,
//                         letterSpacing: 1,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.titleTextColor,
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
// }

import 'dart:ui';
import '../services/frostedGlassEffect.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../services/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../services/dark_mode_controller.dart';

class BMIcalculatorPage extends StatelessWidget {
  const BMIcalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BMICalculator();
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator>
    with SingleTickerProviderStateMixin {
  final ThemeController themeController = Get.find();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String gender = 'Male';
  String _displaytext = "";
  Color _color = Colors.transparent;
  String _image = 'assets/bmi_images/bmi1.png';
  final TextEditingController _weightcontroller = TextEditingController();
  final TextEditingController _heightcontroller = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController result = TextEditingController();

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _weightcontroller.dispose();
    _heightcontroller.dispose();
    _ageController.dispose();
    result.dispose();
    super.dispose();
  }

  void BMIcalculate(String weight, String height) {
    if (weight.isEmpty || height.isEmpty) {
      _showSnackbar("Please enter both weight and height");
      return;
    }

    double? squareweight = double.tryParse(weight);
    double? squareheight = double.tryParse(height);

    if (squareweight == null || squareheight == null || squareheight == 0) {
      _showSnackbar("Invalid input. Please check your entries.");
      return;
    }

    double res = (squareweight * 10000) / (squareheight * squareheight);

    setState(() {
      result.text = res.toStringAsFixed(2);

      if (res < 18.5) {
        _displaytext = "UNDERWEIGHT";
        _image = 'assets/bmi_images/bmi1.png';
        _color = Color(0xFF4D9FFF);
      } else if (res <= 24.9) {
        _displaytext = "NORMAL";
        _color = Color(0xFF00CC66);
        _image = 'assets/bmi_images/bmi2.png';
      } else if (res <= 29.9) {
        _displaytext = "OVERWEIGHT";
        _color = Color(0xFFf5af19);
        _image = 'assets/bmi_images/bmi3.png';
      } else if (res <= 39.9) {
        _displaytext = "OBESE";
        _color = Color(0xFFFF6B35);
        _image = 'assets/bmi_images/bmi4.png';
      } else {
        _displaytext = "MORBIDLY OBESE";
        _color = Color(0xFFFF006E);
        _image = 'assets/bmi_images/bmi5.png';
      }
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
                        _buildInputSection(isDark),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BMI Calculator',
          style: GoogleFonts.notoSans(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your body mass index',
          style: GoogleFonts.notoSans(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.black54,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(bool isDark) {
    return _buildLiquidGlassCard(
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Details',
              style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 24),
            _buildNeumorphicTextField(
              isDark: isDark,
              controller: _weightcontroller,
              hint: 'Weight',
              unit: 'kg',
              icon: Icons.monitor_weight_rounded,
            ),
            const SizedBox(height: 16),
            _buildNeumorphicTextField(
              isDark: isDark,
              controller: _heightcontroller,
              hint: 'Height',
              unit: 'cm',
              icon: Icons.height_rounded,
            ),
            const SizedBox(height: 16),
            _buildNeumorphicTextField(
              isDark: isDark,
              controller: _ageController,
              hint: 'Age',
              unit: 'years',
              icon: Icons.cake_rounded,
            ),
            const SizedBox(height: 24),
            Text(
              'Gender',
              style: GoogleFonts.notoSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            _buildGenderSelector(isDark),
            const SizedBox(height: 32),
            _buildCalculateButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicTextField({
    required bool isDark,
    required TextEditingController controller,
    required String hint,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1a1a2e) : Color(0xFFe8eaf6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.notoSans(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.notoSans(
            fontSize: 17,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
          prefixIcon: Icon(
            icon,
            color: isDark ? Colors.white54 : Colors.black45,
            size: 22,
          ),
          suffixText: unit,
          suffixStyle: GoogleFonts.notoSans(
            fontSize: 15,
            color: isDark ? Colors.white54 : Colors.black45,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(bool isDark) {
    final genders = [
      {'name': 'Male', 'icon': Icons.male_rounded},
      {'name': 'Female', 'icon': Icons.female_rounded},
      {'name': 'Other', 'icon': Icons.transgender_rounded},
    ];

    return Row(
      children: genders.map((g) {
        final isSelected = gender == g['name'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = g['name'] as String),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xFF000000)
                    : isDark
                    ? Color(0xFF000000)
                    : Color(0xFFe4e2de),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    g['icon'] as IconData,
                    color: isSelected
                        ? Colors.white
                        : isDark
                        ? Colors.white54
                        : Colors.black54,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    g['name'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isDark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculateButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        BMIcalculate(_weightcontroller.text, _heightcontroller.text);
        if (result.text.isNotEmpty) {
          _showResultDialog(isDark);
        }
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Color(0xFF000000),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Calculate BMI',
            style: GoogleFonts.notoSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ),
    );
  }

  void _showResultDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF000000) : Color(0xFFe4e2de),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _color.withOpacity(0.5), width: 2),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _color,
                      boxShadow: [
                        BoxShadow(
                          color: _color.withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        result.text,
                        style: GoogleFonts.notoSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your BMI',
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        _displaytext,
                        speed: Duration(milliseconds: 100),
                        textStyle: GoogleFonts.notoSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _color,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _color.withOpacity(0.2),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(_image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF000000) : Color(0xFFe4e2de),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Got it',
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          ),
          child: child,
        ),
      ),
    );
  }
}
