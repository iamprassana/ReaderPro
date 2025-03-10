import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class Extractor {

  Future<String?> extractPDF(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final String content = PdfTextExtractor(document).extractText();

    return content;
  }
}
