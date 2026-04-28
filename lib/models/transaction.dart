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
  });

  // Convert json to Transaction object
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

    return Transaction(
      receiptNum: json['receiptno']?.toString() ?? '',
      stuNum: json['studentid']?.toString() ?? '',
      transactAmount: json['amount']?.toString() ?? '0.00',
      transactAmountWords: json['amountwords']?.toString() ?? '',
      transactPurpose: json['purpose']?.toString() ?? 'No Purpose',
      foFirstName: json['finance_fn']?.toString() ?? '',
      foMiddleInitial: json['finance_mi']?.toString() ?? '',
      foLastName: json['finance_ln']?.toString() ?? '',
      transactYear: year,
      transactMonth: month,
      transactDay: day,
    );
  }
}
