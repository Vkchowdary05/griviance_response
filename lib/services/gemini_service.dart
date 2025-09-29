import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/exceptions.dart';

class GeminiService {
  static late final GenerativeModel _model;
  
  static void initialize() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: AppConstants.geminiApiKey,
    );
  }

  static Future<double> validateGrievanceRelevance(
    String title,
    String description,
  ) async {
    try {
      final prompt = '''
Analyze this grievance submission for relevance and legitimacy. 
Rate it from 0.0 to 1.0 where:
- 1.0 = Highly relevant, legitimate public grievance
- 0.5 = Moderately relevant, needs review
- 0.0 = Spam, irrelevant, or inappropriate

Title: $title
Description: $description

Consider:
1. Is this a legitimate public service issue?
2. Is the language appropriate and professional?
3. Does it contain sufficient detail?
4. Is it a real grievance vs spam/joke?

Respond with only a number between 0.0 and 1.0.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final scoreText = response.text?.trim() ?? '0.0';
      final score = double.tryParse(scoreText) ?? 0.0;
      
      return score.clamp(0.0, 1.0);
    } catch (e) {
      print('Gemini validation error: $e');
      return 0.5; // Default score if AI fails
    }
  }

  static Future<String> generateGrievanceSummary(
    String title,
    String description,
  ) async {
    try {
      final prompt = '''
Create a concise summary of this grievance in 1-2 sentences:

Title: $title
Description: $description

Summary should be professional and capture the main issue.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text?.trim() ?? 'Summary not available';
    } catch (e) {
      print('Gemini summary error: $e');
      return 'Summary not available';
    }
  }

  static Future<List<String>> suggestSimilarGrievances(
    String description,
    List<String> existingGrievances,
  ) async {
    if (existingGrievances.isEmpty) return [];
    
    try {
      final prompt = '''
Find similar grievances from this list that match the new grievance:

New Grievance: $description

Existing Grievances:
${existingGrievances.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

Return only the numbers (1, 2, 3, etc.) of similar grievances, separated by commas.
If no similar grievances found, return "none".
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final result = response.text?.trim() ?? 'none';
      
      if (result.toLowerCase() == 'none') return [];
      
      final indices = result
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .where((i) => i != null && i > 0 && i <= existingGrievances.length)
          .map((i) => existingGrievances[i! - 1])
          .toList();
      
      return indices;
    } catch (e) {
      print('Gemini similarity error: $e');
      return [];
    }
  }
}
