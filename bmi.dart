import 'package:flutter/material.dart';

enum HeightType { cm, feetInch }

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  HeightType heightType = HeightType.cm;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _cmHeightController = TextEditingController();
  final TextEditingController _feetHeightController = TextEditingController();
  final TextEditingController _inchHeightController = TextEditingController();

  String bmiResult = "";
  String category = "";

  // CM to Meter
  double? cmToM() {
    final cm = double.tryParse(_cmHeightController.text.trim());
    if (cm == null || cm <= 0) return null;
    return cm / 100;
  }

  // Feet-inches to Meter
  double? feetInchToM() {
    final feet = double.tryParse(_feetHeightController.text.trim());
    final inch = double.tryParse(_inchHeightController.text.trim());

    if (feet == null || feet <= 0 || inch == null || inch < 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid height")));
      return null;
    }

    final totalInch = (feet * 12) + inch;
    return totalInch * 0.0254;
  }

  // Category Logic (Proper BMI Range)
  String categoryResult(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Healthy";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  // BMI Calculation
  void _calculate() {
    final weight = double.tryParse(_weightController.text.trim());

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid weight")));
      return;
    }

    final height = heightType == HeightType.cm ? cmToM() : feetInchToM();
    if (height == null) return;

    final bmi = weight / (height * height);

    setState(() {
      bmiResult = bmi.toStringAsFixed(2);
      category = categoryResult(bmi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BMI CALCULATOR",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0444B5),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Weight Input
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Height Type Switch
            SegmentedButton<HeightType>(
              segments: const [
                ButtonSegment(value: HeightType.cm, label: Text("CM")),
                ButtonSegment(value: HeightType.feetInch, label: Text("Feet/Inch")),
              ],
              selected: {heightType},
              onSelectionChanged: (value) {
                setState(() => heightType = value.first);
              },
            ),

            const SizedBox(height: 12),

            // Height Input
            if (heightType == HeightType.cm) ...[
              TextField(
                controller: _cmHeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Height (cm)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _feetHeightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Feet",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _inchHeightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Inch",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 30),

            // Calculate Button
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0444B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _calculate,
                child: const Text(
                  "BMI CALCULATE",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Result Section
            Text(
              "BMI Result: $bmiResult",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Category: $category",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
