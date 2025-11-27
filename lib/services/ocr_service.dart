import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// Ocr service to scan an input image
class OcrService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<RecognizedText> run(String imagePath) async {
    InputImage inputImage = InputImage.fromFilePath(imagePath);

    return await _textRecognizer.processImage(inputImage);
  }

  void dispose() {
    _textRecognizer.close();
  }
}

// Looks for the handwritten text in the scanned image using
// printed text as the anchors, then maps it to a Transaction object
class OcrMapperService {

  // Assumes we look for text beside the anchor by default
  Future<String?> extractHandwrittenField(
    RecognizedText recognizedText,
    String anchorLabel,
    {
      double horizontalOffsetMultiplier = 0.0,
      double verticalOffsetMultiplier = 0.0,
      double widthMultiplier = 4.0,
      double heightMultiplier = 1.5,
    }
  ) async {

    Rect? anchorBox = _findAnchorBoundingBox(recognizedText, anchorLabel);

    if (anchorBox == null) {
      debugPrint('Anchor label "$anchorLabel" not found.');
      return null;
    }

    Rect searchRegion = _defineSearchRegion(
      anchorBox,
      horizontalOffsetMultiplier,
      verticalOffsetMultiplier,
      widthMultiplier,
      heightMultiplier,
    );
    String extractedText = _searchRegionForText(recognizedText, searchRegion);
    return extractedText.trim().isNotEmpty ? extractedText.trim() : null;
  }

  // Finds the bounding box of the target label
  Rect? _findAnchorBoundingBox(RecognizedText recognizedText, String label) {
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        if (line.text.contains(label)) {
          return line.boundingBox;
        }
      }
    }
    return null;
  }

  Rect _defineSearchRegion(
    Rect anchorBox,
    double horizontalOffsetMultiplier,
    double verticalOffsetMultiplier,
    double widthMultiplier,
    double heightMultiplier,
  ) {
    final double searchWidth = anchorBox.width * widthMultiplier;
    final double searchHeight = anchorBox.height * heightMultiplier;
    final double searchTop = anchorBox.bottom + ((anchorBox.bottom - anchorBox.top) * verticalOffsetMultiplier);
    final double searchLeft = anchorBox.left + ((anchorBox.right - anchorBox.left) * horizontalOffsetMultiplier);

    return Rect.fromLTWH(
      searchLeft,
      searchTop,
      searchWidth,
      searchHeight,
    );
  }

  String _searchRegionForText(RecognizedText recognizedText, Rect searchRegion) {
    StringBuffer buffer = StringBuffer();

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final textElement in line.elements) {
          if (
            searchRegion.overlaps(textElement.boundingBox)) {
            buffer.write('${textElement.text} ');
          }
        }
      }
    }
    return buffer.toString();
  }
}
