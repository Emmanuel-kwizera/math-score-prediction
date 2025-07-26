import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MathScorePredictorApp());
}

class MathScorePredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Score Predictor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: ScorePredictorForm(),
    );
  }
}

class ScorePredictorForm extends StatefulWidget {
  @override
  _ScorePredictorFormState createState() => _ScorePredictorFormState();
}

class _ScorePredictorFormState extends State<ScorePredictorForm> {
  final _formKey = GlobalKey<FormState>();
  final readingScoreController = TextEditingController();
  final writingScoreController = TextEditingController();

  String? gender;
  String? raceEthnicity;
  String? parentalEducation;
  String? lunch;
  String? testPreparation;
  String? predictionResult;
  bool isLoading = false;

  Future<void> predictScore() async {
    final url =
        Uri.parse('https://math-score-prediction-jv5y.onrender.com/predict');

    final body = {
      "gender": gender ?? "",
      "race_ethnicity": raceEthnicity ?? "",
      "parental_level_of_education": parentalEducation ?? "",
      "lunch": lunch ?? "",
      "test_preparation_course": testPreparation ?? "",
      "reading_score": double.parse(readingScoreController.text),
      "writing_score": double.parse(writingScoreController.text),
    };

    setState(() {
      isLoading = true;
      predictionResult = null;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          predictionResult = data['predicted_math_score'].toString();
        });
      } else {
        setState(() {
          predictionResult = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "Error: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? value,
    required Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(labelText: label),
        value: value,
        items: items
            .map((val) =>
                DropdownMenuItem(value: val, child: Text(val.toString())))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text('Math Score Predictor'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildDropdown(
                    label: 'Gender',
                    items: ['male', 'female'],
                    value: gender,
                    onChanged: (val) => setState(() => gender = val),
                  ),
                  _buildDropdown(
                    label: 'Race/Ethnicity',
                    items: [
                      'group A',
                      'group B',
                      'group C',
                      'group D',
                      'group E'
                    ],
                    value: raceEthnicity,
                    onChanged: (val) => setState(() => raceEthnicity = val),
                  ),
                  _buildDropdown(
                    label: 'Parental Level of Education',
                    items: [
                      'high school',
                      'some college',
                      'associate\'s degree',
                      'bachelor\'s degree',
                      'master\'s degree'
                    ],
                    value: parentalEducation,
                    onChanged: (val) => setState(() => parentalEducation = val),
                  ),
                  _buildDropdown(
                    label: 'Lunch',
                    items: ['standard', 'free/reduced'],
                    value: lunch,
                    onChanged: (val) => setState(() => lunch = val),
                  ),
                  _buildDropdown(
                    label: 'Test Preparation Course',
                    items: ['none', 'completed'],
                    value: testPreparation,
                    onChanged: (val) => setState(() => testPreparation = val),
                  ),
                  _buildTextInput('Reading Score', readingScoreController),
                  _buildTextInput('Writing Score', writingScoreController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              predictScore();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Predict Math Score',
                            style: TextStyle(color: Colors.white)),
                  ),
                  if (predictionResult != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Predicted Math Score: $predictionResult',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
