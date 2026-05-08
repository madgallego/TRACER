import 'package:flutter/widgets.dart';
import 'package:tracer/models/transaction.dart';
import 'package:tracer/utils/formatters.dart';

class VerificationViewModel extends ChangeNotifier {
  final TextEditingController stuNumController = TextEditingController();
  final TextEditingController transactRecordNumController = TextEditingController();
  final TextEditingController transactMonthController = TextEditingController();
  final TextEditingController transactDayController = TextEditingController();
  final TextEditingController transactYearController = TextEditingController();
  final TextEditingController transactAmountController = TextEditingController();
  final TextEditingController transactAmountWordsController = TextEditingController();
  final TextEditingController transactDescriptionController = TextEditingController();
  final TextEditingController foFirstNameController = TextEditingController();
  final TextEditingController foMiddleInitialController = TextEditingController();
  final TextEditingController foLastNameController = TextEditingController();
  bool isReceiptRequested = true;

  void init(Transaction transaction) {
    stuNumController.text = Formatters.digits(transaction.stuNum ?? "");
    transactRecordNumController.text = Formatters.digits(transaction.receiptNum ?? "");
    transactMonthController.text = Formatters.digits(transaction.transactMonth ?? "");
    transactDayController.text = Formatters.digits(transaction.transactDay ?? "");
    transactYearController.text = Formatters.digits(transaction.transactYear ?? "");
    transactAmountController.text = Formatters.currency(transaction.transactAmount ?? "");
    transactAmountWordsController.text = Formatters.amountToWords(transactAmountController.text);
    transactDescriptionController.text = Formatters.name(transaction.transactPurpose ?? "");
    foFirstNameController.text = Formatters.name(transaction.foFirstName ?? "");
    foMiddleInitialController.text = Formatters.middleInitial(transaction.foMiddleInitial ?? "");
    foLastNameController.text = Formatters.name(transaction.foLastName ?? "");
  }

  void updateModel(Transaction transaction) {
    transaction.stuNum = stuNumController.text;
    transaction.receiptNum = transactRecordNumController.text;
    transaction.transactMonth = transactMonthController.text;
    transaction.transactDay = transactDayController.text;
    transaction.transactYear = transactYearController.text;
    transaction.transactAmount = transactAmountController.text;
    transaction.transactAmountWords = transactAmountWordsController.text;
    transaction.transactPurpose = transactDescriptionController.text;
    transaction.foFirstName = foFirstNameController.text;
    transaction.foMiddleInitial = foMiddleInitialController.text;
    transaction.foLastName = foLastNameController.text;
    transaction.isReceiptRequested = isReceiptRequested;
  }

  bool isEmpty() {
    return [
      stuNumController,
      transactRecordNumController,
      transactMonthController,
      transactDayController,
      transactYearController,
      transactAmountController,
      transactAmountWordsController,
      transactDescriptionController,
      foFirstNameController,
      foMiddleInitialController,
      foLastNameController,
    ].every((element) => element.text.isEmpty);
  }

  bool isMissingRequiredValue() {
    return [
      stuNumController,
      transactRecordNumController,
      transactMonthController,
      transactDayController,
      transactYearController,
      transactAmountController,
      transactAmountWordsController,
      transactDescriptionController,
      foFirstNameController,
      foLastNameController,
    ].any((element) => element.text.isEmpty);
  }

  @override
  void dispose() {
    stuNumController.dispose();
    transactRecordNumController.dispose();
    transactMonthController.dispose();
    transactDayController.dispose();
    transactYearController.dispose();
    transactAmountController.dispose();
    transactAmountWordsController.dispose();
    transactDescriptionController.dispose();
    foFirstNameController.dispose();
    foMiddleInitialController.dispose();
    foLastNameController.dispose();
    super.dispose();
  }
}
