import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:tracer/services/ocr_service.dart';

class Transaction {
  String? stuFirstName;
  String? stuMiddleInitial;
  String? stuLastName;
  String? stuNum;
  String? transactMonth;
  String? transactDay;
  String? transactYear;
  String? transactAmount;
  String? transactAmountWords;
  String? transactPurpose;
  String? foFirstName;
  String? foMiddleInitial;
  String? foLastName;

  Future<void> populateWithOcrMapper(
    OcrMapperService ocrMapper,
    RecognizedText recognizedText,
  ) async {
    stuFirstName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      isBelow: true,
      verticalOffset: 100.0,
      widthMultiplier: 1.2,
      heightMultiplier: 1.1,
    );

    stuMiddleInitial = (await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      isBelow: true,
      horizontalOffset: 900.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.5,
      heightMultiplier: 1.1,
    ));

    stuLastName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      isBelow: true,
      horizontalOffset: 1100.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.8,
      heightMultiplier: 1.1
    );

    stuNum = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      isBelow: true,
      horizontalOffset: 1500.0,
      verticalOffset: 120.0,
      widthMultiplier: 1.5,
      heightMultiplier: 1.0
    );

    transactAmount = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Transaction Details",
      isBelow: true,
      verticalOffset: 150.0,
      widthMultiplier: 1.2,
      heightMultiplier: 1.3
    );

    transactPurpose = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Transaction Details",
      isBelow: true,
      verticalOffset: 500.0,
      widthMultiplier: 10.0,
      heightMultiplier: 1.3,
    );

    transactMonth = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      isBelow: true,
      horizontalOffset: 1700.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.3,
      heightMultiplier: 1.0,
    );

    transactDay = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      isBelow: true,
      horizontalOffset: 2100.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.3,
      heightMultiplier: 1.0,
    );

    transactYear = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      isBelow: true,
      horizontalOffset: 2500.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.3,
      heightMultiplier: 1.0,
    );

    foFirstName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      isBelow: true,
      verticalOffset: 120.0,
      widthMultiplier: 0.7,
      heightMultiplier: 1.0,
    );

    foMiddleInitial = (await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      isBelow: true,
      horizontalOffset: 600.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.3,
      heightMultiplier: 1.0,
    ));

    foLastName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      isBelow: true,
      horizontalOffset: 1100.0,
      verticalOffset: 120.0,
      widthMultiplier: 0.6,
      heightMultiplier: 1.0,
    );
  }
}
