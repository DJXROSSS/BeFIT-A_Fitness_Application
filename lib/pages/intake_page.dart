import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Intake Calculator',
      theme: AppTheme.theme,
      home: DietPage(),
    );
  }
}

Widget customCardButton({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dividerColor, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.accentColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.subtextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.subtextColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.dividerColor, width: 0.5),
              ),
              child: Text(
                'Choose Calculator',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            customCardButton(
              icon: Icons.local_fire_department,
              title: 'Calorie Intake Calculator',
              subtitle: 'Calculate your daily calorie needs.',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IntakeCalculatorScreen(isProtein: false),
                ),
              ),
            ),
            customCardButton(
              icon: Icons.restaurant_rounded,
              title: 'Protein Intake Calculator',
              subtitle: 'Estimate your daily protein intake.',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IntakeCalculatorScreen(isProtein: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ Intake Calculator ============

class IntakeCalculatorScreen extends StatefulWidget {
  final bool isProtein;
  IntakeCalculatorScreen({required this.isProtein});

  @override
  _IntakeCalculatorScreenState createState() => _IntakeCalculatorScreenState();
}

class _IntakeCalculatorScreenState extends State<IntakeCalculatorScreen> {
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  String weightUnit = 'Kg';
  String heightUnit = 'Cm';
  String gender = 'Male';
  String activityLevel = '';
  String goal = '';
  String result = '';

  InputDecoration buildDarkInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.subtextColor),
      filled: true,
      fillColor: AppTheme.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.dividerColor, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.dividerColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.accentColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // void calculateResult() {
  //   final age = int.tryParse(ageController.text) ?? 0;
  //   final weight = double.tryParse(weightController.text) ?? 0;
  //   final height = double.tryParse(heightController.text) ?? 0;
  //
  //   double weightKg = weightUnit == 'Kg' ? weight : weight * 0.453592;
  //   double heightCm = heightUnit == 'Cm' ? height : height * 30.48;
  //
  //   if (age > 150 || weight <= 0 || height <= 0) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Please enter valid inputs.')));
  //     return;
  //   }
  //
  //   double activityFactor = 1.2;
  //   if (activityLevel == 'Moderate')
  //     activityFactor = 1.55;
  //   else if (activityLevel == 'High')
  //     activityFactor = 1.9;
  //
  //   if (!widget.isProtein) {
  //     double bmr = gender == 'Male'
  //         ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
  //         : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
  //     double tdee = bmr * activityFactor;
  //
  //     if (goal == 'Lose Weight')
  //       tdee *= 0.85;
  //     else if (goal == 'Gain Muscle')
  //       tdee *= 1.15;
  //
  //     result = '${tdee.toStringAsFixed(0)} kcal/day';
  //   } else {
  //     double multiplier = 0.8;
  //     if (activityLevel == 'Moderate')
  //       multiplier = 1.2;
  //     else if (activityLevel == 'High')
  //       multiplier = 2.0;
  //     if (goal == 'Gain Muscle') multiplier += 0.3;
  //
  //     double protein = weightKg * multiplier;
  //     result = '${protein.toStringAsFixed(0)} grams/day';
  //   }
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Your Result"),
  //       content: Text(result),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text("OK"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void calculateResult() async {
    final age = int.tryParse(ageController.text) ?? 0;
    final weight = double.tryParse(weightController.text) ?? 0;
    final height = double.tryParse(heightController.text) ?? 0;

    double weightKg = weightUnit == 'Kg' ? weight : weight * 0.453592;
    double heightCm = heightUnit == 'Cm' ? height : height * 30.48;

    if (age > 150 || weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter valid inputs.')));
      return;
    }

    double activityFactor = 1.2;
    if (activityLevel == 'Moderate')
      activityFactor = 1.55;
    else if (activityLevel == 'High')
      activityFactor = 1.9;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!widget.isProtein) {
      double bmr = gender == 'Male'
          ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
          : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
      double tdee = bmr * activityFactor;

      if (goal == 'Lose Weight')
        tdee *= 0.85;
      else if (goal == 'Gain Muscle')
        tdee *= 1.15;

      result = '${tdee.toStringAsFixed(0)}';
      await prefs.setString('last_calorie_result', result);
      result = '$result kcal/day';
    } else {
      double multiplier = 0.8;
      if (activityLevel == 'Moderate')
        multiplier = 1.2;
      else if (activityLevel == 'High')
        multiplier = 2.0;
      if (goal == 'Gain Muscle') multiplier += 0.3;

      double protein = weightKg * multiplier;
      result = '${protein.toStringAsFixed(0)}';
      await prefs.setString('last_protein_result', result);
      result = '${protein.toStringAsFixed(0)} grams/day';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Result"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: AppTheme.titleTextColor)),
          ),
        ],
      ),
    );
  }

  Widget modernInputField({required String label, required Widget field}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.subtextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isProtein
        ? "Protein Intake Calculator"
        : "Calorie Intake Calculator";
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          modernInputField(
            label: "Age",
            field: TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: AppTheme.textColor),
              decoration: buildDarkInputDecoration("Enter your age"),
            ),
          ),
          modernInputField(
            label: "Weight",
            field: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: AppTheme.textColor),
                    decoration: buildDarkInputDecoration("Weight"),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: weightUnit,
                  dropdownColor: AppTheme.cardColor,
                  style: TextStyle(color: AppTheme.textColor),
                  onChanged: (val) => setState(() => weightUnit = val!),
                  items: ['Kg', 'Lbs']
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                ),
              ],
            ),
          ),
          modernInputField(
            label: "Height",
            field: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: AppTheme.textColor),
                    decoration: buildDarkInputDecoration("Height"),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: heightUnit,
                  dropdownColor: AppTheme.cardColor,
                  style: TextStyle(color: AppTheme.textColor),
                  onChanged: (val) => setState(() => heightUnit = val!),
                  items: ['Cm', 'Ft']
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                ),
              ],
            ),
          ),
          modernInputField(
            label: "Gender",
            field: Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      "Male",
                      style: TextStyle(color: AppTheme.textColor),
                    ),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (val) => setState(() => gender = val!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      "Female",
                      style: TextStyle(color: AppTheme.textColor),
                    ),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (val) => setState(() => gender = val!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          modernInputField(
            label: "Activity Level",
            field: DropdownButtonFormField<String>(
              value: activityLevel.isEmpty ? null : activityLevel,
              style: TextStyle(color: AppTheme.textColor),
              dropdownColor: AppTheme.cardColor,
              decoration: buildDarkInputDecoration("Select Activity Level"),
              items: [
                'Low',
                'Moderate',
                'High',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (val) => setState(() => activityLevel = val!),
            ),
          ),
          modernInputField(
            label: "Goal",
            field: DropdownButtonFormField<String>(
              value: goal.isEmpty ? null : goal,
              style: TextStyle(color: AppTheme.textColor),
              dropdownColor: AppTheme.cardColor,
              decoration: buildDarkInputDecoration("Select your goal"),
              items: [
                'Lose Weight',
                'Maintain Weight',
                'Gain Muscle',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (val) => setState(() => goal = val!),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: calculateResult,
              icon: const Icon(Icons.calculate),
              label: const Text(
                "Calculate",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// MealCalculatorScreen is unchanged; let me know if you want it updated with same dark style.

// class MealCalculatorScreen extends StatefulWidget {
//   @override
//   _MealCalculatorScreenState createState() => _MealCalculatorScreenState();
// }
//
// class _MealCalculatorScreenState extends State<MealCalculatorScreen> {
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController foodController = TextEditingController();
//
//   final Map<String, double> foodCaloriesPer100g = {
//     'rice': 130,
//     'chapati': 104,
//     'egg': 155,
//     'milk': 42,
//     'chicken': 165,
//     'banana': 89,
//     'apple': 52,
//     'paneer': 265,
//     'dal': 116,
//     'potato': 77,
//   };
//
//   void calculateCalories() {
//     String food = foodController.text.trim().toLowerCase();
//     double quantity = double.tryParse(quantityController.text.trim()) ?? 0;
//
//     if (!foodCaloriesPer100g.containsKey(food)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Food not found. Try rice, dal, egg...')),
//       );
//       return;
//     }
//
//     double calPer100g = foodCaloriesPer100g[food]!;
//     double estimatedCalories = (calPer100g / 100) * quantity;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Estimated Calories"),
//         content: Text(
//           "$quantity g of $food ≈ ${estimatedCalories.toStringAsFixed(1)} kcal",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Meal Calculator")),
//       body: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppTheme.appBarBg, AppTheme.backgroundColor],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: ListView(
//           children: [
//             Text(
//               "Estimate Calories in Your Meal",
//               style: Theme.of(
//                 context,
//               ).textTheme.headlineSmall?.copyWith(color: AppTheme.textColor),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             DropdownButtonFormField<String>(
//               value: foodController.text.isEmpty ? null : foodController.text,
//               items: foodCaloriesPer100g.keys.map((food) {
//                 return DropdownMenuItem(
//                   value: food,
//                   child: Text(food[0].toUpperCase() + food.substring(1)),
//                 );
//               }).toList(),
//               onChanged: (val) {
//                 setState(() => foodController.text = val!);
//               },
//               decoration: InputDecoration(
//                 labelText: 'Select Food Item',
//                 labelStyle: TextStyle(
//                   color: AppTheme.textColor.withOpacity(0.7),
//                 ),
//                 filled: true,
//                 fillColor: AppTheme.textColor.withAlpha(26),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: quantityController,
//               decoration: InputDecoration(
//                 labelText: 'Quantity in grams',
//                 labelStyle: TextStyle(
//                   color: AppTheme.textColor.withOpacity(0.7),
//                 ),
//                 filled: true,
//                 fillColor: AppTheme.textColor.withAlpha(26),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: calculateCalories,
//               icon: Icon(Icons.calculate),
//               label: Text('Estimate Calories', style: TextStyle(color: AppTheme.titleTextColor)),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 backgroundColor: AppTheme.appBarBg,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
