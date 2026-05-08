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
    transactMonthController.text = Formatters.digits(transaction.transactMonth ?? "", limit: 2);
    transactDayController.text = Formatters.digits(transaction.transactDay ?? "", limit: 2);
    transactYearController.text = Formatters.digits(transaction.transactYear ?? "", limit: 4);
    transactAmountController.text = Formatters.currency(transaction.transactAmount ?? "");
    transactAmountWordsController.text = Formatters.amountToWords(transactAmountController.text);
    transactDescriptionController.text = Formatters.name(transaction.transactPurpose ?? "");
    foFirstNameController.text = Formatters.name(transaction.foFirstName ?? "");
    foMiddleInitialController.text = Formatters.middleInitial(transaction.foMiddleInitial ?? "");
    foLastNameController.text = Formatters.name(transaction.foLastName ?? "");

    // Clamp date to current date
    if (Formatters.isFutureDate(transactMonthController.text, transactDayController.text, transactYearController.text)) {
      final now = DateTime.now();

      transactMonthController.text = now.month.toString();
      transactDayController.text = now.day.toString();
      transactYearController.text = now.year.toString();
    }
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

  void clear() {
    stuNumController.text = '';
    transactRecordNumController.text = '';
    transactMonthController.text = '';
    transactDayController.text = '';
    transactYearController.text = '';
    transactAmountController.text = '';
    transactAmountWordsController.text = '';
    transactDescriptionController.text = '';
    foFirstNameController.text = '';
    foMiddleInitialController.text = '';
    foLastNameController.text = '';
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
