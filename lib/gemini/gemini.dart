import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  static const String apiKey = "AIzaSyBa8Rdq-3YMe7A2IjdGYSKXtWON6kWgDGs";

  final String instructionPrompt = '''
      You are given a content. Make it more readable in a way that makes most sense. Add spaces where ever needed. And give it back without any explanation.
''';

  Future<String> generator(String inputText) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final content = [
      Content.text(instructionPrompt), // Prompt (system message)
      Content.text(inputText), // File content (user message)
    ];

    try {
      final response = await model.generateContent(content);
      final reply = response.text ?? "Failed to generate content.";
      return reply;
    } catch (e) {
      if (e is GenerativeAIException) {
        return "Error Occured in Gemini Processing. Please Try Again.";
      } else if (e.toString().contains('SocketException')) {
        print(e.toString());
        return "Please check your internet connection.";
      } else {
        return "Unexpected error occured.";
      }
    }
  }

  Future<String> generateToBionicFormat(String content) async {
    final lines = content.split('\n'); // Break by line first

    String processWord(String word) {
      if (word.length <= 2) return word;
      final boldLength = word.length >= 6 ? 4 : 2;
      final boldPart = word.substring(0, boldLength);
      final normalPart = word.substring(boldLength);
      return '**$boldPart**$normalPart';
    }

    final processedLines = lines.map((line) {
      final wordsAndSpaces = RegExp(r'(\w+|\s+|[^\w\s]+)')
          .allMatches(line)
          .map((match) => match.group(0)!)
          .toList();

      final processedWords = wordsAndSpaces.map((segment) {
        final isWord = RegExp(r'\w+').hasMatch(segment);
        return isWord
            ? processWord(segment)
            : segment; // If it's space/punctuation, keep it as-is
      }).join('');

      return processedWords;
    });

    return processedLines.join('\n'); // Keep newlines intact
  }
}
