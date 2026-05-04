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
  bool? isReceiptRequested;

  Transaction({
    this.stuFirstName,
    this.stuMiddleInitial,
    this.stuLastName,
    this.stuNum,
    this.receiptNum,
    this.transactMonth,
    this.transactDay,
    this.transactYear,
    this.transactAmount,
    this.transactAmountWords,
    this.transactPurpose,
    this.foFirstName,
    this.foMiddleInitial,
    this.foLastName,
    this.isReceiptRequested,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    String month = '', day = '', year = '';
    if (json['receiptdate'] != null) {
      try {
        DateTime dt = DateTime.parse(json['receiptdate'].toString());
        month = dt.month.toString();
        day = dt.day.toString();
        year = dt.year.toString();

      } catch (e) {
        print("Date parse error: $e");
      }
    }

    bool sendReceipt;
    if (json['send_receipt'] == "true") {
      sendReceipt = true;
    } else {
      sendReceipt = false;
    }

    return Transaction(
      receiptNum: json['receiptno']?.toString() ?? '',
      stuNum: json['studentid']?.toString() ?? '',
      stuFirstName: json['stud_fn']?.toString() ?? '',
      stuMiddleInitial: json['stud_mi']?.toString() ?? '',
      stuLastName: json['stud_ln']?.toString() ?? '',
      transactAmount: json['amount']?.toString() ?? '0.00',
      transactAmountWords: json['amountwords']?.toString() ?? '',
      transactPurpose: json['purpose']?.toString() ?? 'No Purpose',
      foFirstName: json['finance_fn']?.toString() ?? '',
      foMiddleInitial: json['finance_mi']?.toString() ?? '',
      foLastName: json['finance_ln']?.toString() ?? '',
      transactYear: year,
      transactMonth: month,
      transactDay: day,
      isReceiptRequested: sendReceipt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "receiptno": receiptNum,
      "studentid": stuNum,
      "amount": transactAmount,
      "amountwords": transactAmountWords,
      "purpose": transactPurpose,
      "finance_fn": foFirstName,
      "finance_mi": foMiddleInitial,
      "finance_ln": foLastName,
      "receiptdate": "$transactYear-$transactMonth-$transactDay",
      "send_receipt": isReceiptRequested,
    };
  }

  bool isEmpty() {
    return [
      stuFirstName, stuMiddleInitial, stuLastName, stuNum, receiptNum, transactDay, transactMonth, transactPurpose,
      transactYear, transactAmount, transactAmountWords, foFirstName, foMiddleInitial, foLastName
    ].every((field) => field == null || field.isEmpty);
  }

  bool isMissingRequiredValue() {
    return [
      stuFirstName, stuLastName, stuNum, receiptNum, transactDay, transactMonth, transactPurpose,
      transactYear, transactAmount, transactAmountWords, foFirstName, foLastName
    ].any((field) => field == null || field.isEmpty);
  }

}
