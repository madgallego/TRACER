import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:tracer/services/ocr_service.dart';

class Transaction {
  String? stuFirstName;
  String? stuMiddleInitial;
  String? stuLastName;
  String? stuNum;
  String? receiptNum;
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
      verticalOffsetMultiplier: 2.5,
      widthMultiplier: 1.2,
      heightMultiplier: 1.1,
    );

    stuMiddleInitial = (await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      horizontalOffsetMultiplier: 1.3,
      verticalOffsetMultiplier: 2.5,
      widthMultiplier: 0.5,
      heightMultiplier: 1.1,
    ));

    stuLastName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      horizontalOffsetMultiplier: 1.7,
      verticalOffsetMultiplier: 2.5,
      widthMultiplier: 0.8,
      heightMultiplier: 1.1
    );

    stuNum = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      horizontalOffsetMultiplier: 3.0,
      verticalOffsetMultiplier: 2.5,
      widthMultiplier: 4.0,
      heightMultiplier: 1.0
    );

    transactAmount = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Transaction Details",
      verticalOffsetMultiplier: 2.5,
      widthMultiplier: 0.9,
      heightMultiplier: 1.3
    );

    transactPurpose = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      verticalOffsetMultiplier: -3.5,
      widthMultiplier: 10.0,
      heightMultiplier: 0.8,
    );

    transactMonth = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      horizontalOffsetMultiplier: 3.5,
      verticalOffsetMultiplier: -3.5,
      widthMultiplier: 0.3,
      heightMultiplier: 0.5,
    );

    transactDay = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      horizontalOffsetMultiplier: 4.0,
      verticalOffsetMultiplier: -3.5,
      widthMultiplier: 0.3,
      heightMultiplier: 0.5,
    );

    transactYear = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Student Details",
      horizontalOffsetMultiplier: 4.5,
      verticalOffsetMultiplier: -3.5,
      widthMultiplier: 0.3,
      heightMultiplier: 0.5,
    );

    receiptNum = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      horizontalOffsetMultiplier: 2.4,
      verticalOffsetMultiplier: 2.3,
      widthMultiplier: 3.0,
      heightMultiplier: 3.0,
    );

    foFirstName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      verticalOffsetMultiplier: 2.3,
      widthMultiplier: 0.7,
      heightMultiplier: 0.8,
    );

    foMiddleInitial = (await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      horizontalOffsetMultiplier: 1.0,
      verticalOffsetMultiplier: 2.3,
      widthMultiplier: 0.2,
      heightMultiplier: 0.8,
    ));

    foLastName = await ocrMapper.extractHandwrittenField(
      recognizedText,
      "Finance Officer",
      horizontalOffsetMultiplier: 1.5,
      verticalOffsetMultiplier: 2.3,
      widthMultiplier: 0.5,
      heightMultiplier: 0.7,
    );
  }
}
