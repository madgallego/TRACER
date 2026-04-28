import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:tracer/services/db_service.dart';
import 'package:tracer/utils/formatters.dart';
import 'package:tracer/widgets/gradient_border_button.dart';
import 'package:tracer/widgets/gradient_border_text_form_field.dart';
import 'package:tracer/widgets/gradient_icon.dart';

import 'package:tracer/utils/constants.dart';
import 'package:tracer/models/transaction.dart';

class DataVerificationScreen extends StatefulWidget {
  Transaction transaction;
  final bool isFromHomeScreen;

  DataVerificationScreen({
    super.key,
    required this.transaction,
    this.isFromHomeScreen = false,
  });


  @override
  DataVerificationScreenState createState() => DataVerificationScreenState();
}

class DataVerificationScreenState extends State<DataVerificationScreen> {
  // Controllers for text form fields
  final TextEditingController _stuFirstNameController = TextEditingController();
  final TextEditingController _stuMiddleInitialController = TextEditingController();
  final TextEditingController _stuLastNameController = TextEditingController();
  final TextEditingController _stuNumController = TextEditingController();
  final TextEditingController _transactRecordNumController = TextEditingController();
  final TextEditingController _transactMonthController = TextEditingController();
  final TextEditingController _transactDayController = TextEditingController();
  final TextEditingController _transactYearController = TextEditingController();
  final TextEditingController _transactAmountController = TextEditingController();
  final TextEditingController _transactAmountWordsController = TextEditingController();
  final TextEditingController _transactDescriptionController = TextEditingController();
  final TextEditingController _foFirstNameController = TextEditingController();
  final TextEditingController _foMiddleInitialController = TextEditingController();
  final TextEditingController _foLastNameController = TextEditingController();

  String _formatName(String name) {
    if (name.isEmpty) return "";

    List<String> nameList = name.split(' ');

    for (final (index, name) in nameList.indexed) {
      nameList[index] = "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
    }

    return nameList.join(" ");
  }

  String _formatMI(String mi) {
    if (mi.isNotEmpty) {
      return mi[0].toUpperCase();
    }

    return '';
  }

  String _formatNum(String number) {
    List<String> chars = number.split('');
    StringBuffer buf = StringBuffer('');

    for (final char in chars) {
      if (char.isValidNumberString()) {
        buf.write(char);
      }
    }

    return buf.toString();
  }

  String _getAmtWords(String amt) {
    if (amt.isEmpty) return '';

    final numWords = int.parse(amt).toWords();

    List<String> wordList = numWords.split(' ');

    for (final (index, word) in wordList.indexed) {
      wordList[index] = '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }

    if (wordList.last != "Pesos") {
      wordList.add("Pesos");
    }

    return wordList.join(' ');
  }

  void _setFieldInitialValues() {
    _stuFirstNameController.text = _formatName(widget.transaction.stuFirstName ?? "");
    _stuMiddleInitialController.text = _formatMI(widget.transaction.stuMiddleInitial ?? "");
    _stuLastNameController.text = _formatName(widget.transaction.stuLastName ?? "");
    _stuNumController.text = _formatNum(widget.transaction.stuNum ?? "");
    _transactRecordNumController.text = _formatNum(widget.transaction.receiptNum ?? "");
    _transactMonthController.text = _formatNum(widget.transaction.transactMonth ?? "");
    _transactDayController.text = _formatNum(widget.transaction.transactDay ?? "");
    _transactYearController.text = _formatNum(widget.transaction.transactYear ?? "");
    _transactAmountController.text = _formatNum(widget.transaction.transactAmount ?? "");
    _transactAmountWordsController.text = _getAmtWords(_transactAmountController.text);
    _transactDescriptionController.text = _formatName(widget.transaction.transactPurpose ?? "");
    _foFirstNameController.text = _formatName(widget.transaction.foFirstName ?? "");
    _foMiddleInitialController.text = _formatMI(widget.transaction.foMiddleInitial ?? "");
    _foLastNameController.text = _formatName(widget.transaction.foLastName ?? "");
  }

  void _setTransactionFromFields() {
    widget.transaction.stuFirstName = _stuFirstNameController.text;
    widget.transaction.stuMiddleInitial = _stuMiddleInitialController.text;
    widget.transaction.stuLastName = _stuLastNameController.text;
    widget.transaction.stuNum = _stuNumController.text;
    widget.transaction.receiptNum = _transactRecordNumController.text;
    widget.transaction.transactMonth = _transactMonthController.text;
    widget.transaction.transactDay = _transactDayController.text;
    widget.transaction.transactYear = _transactYearController.text;
    widget.transaction.transactAmount = _transactAmountController.text;
    widget.transaction.transactAmountWords = _transactAmountWordsController.text;
    widget.transaction.transactPurpose = _transactDescriptionController.text;
    widget.transaction.foFirstName = _foFirstNameController.text;
    widget.transaction.foMiddleInitial = _foMiddleInitialController.text;
    widget.transaction.foLastName = _foLastNameController.text;

  }

  Future<void> _selectDate(BuildContext context) async {
  final initialDate = DateTime.now();

  final DateTime? pickedDate =
    await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      }
    );

    if (pickedDate != null) {
      setState(() {
        _transactDayController.text = pickedDate.day.toString().padLeft(2, '0');
        _transactMonthController.text = pickedDate.month.toString().padLeft(2, '0');
        _transactYearController.text = pickedDate.year.toString();
      });
    }
  }

  @override
  void initState() {
    _setFieldInitialValues();
    super.initState();
  }

  @override
  void dispose() {
    _stuFirstNameController.dispose();
    _stuMiddleInitialController.dispose();
    _stuLastNameController.dispose();
    _stuNumController.dispose();
    _transactMonthController.dispose();
    _transactDayController.dispose();
    _transactYearController.dispose();
    _transactAmountController.dispose();
    _transactAmountWordsController.dispose();
    _transactDescriptionController.dispose();
    _foFirstNameController.dispose();
    _foMiddleInitialController.dispose();
    _foLastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size of the gesture hint / navbar at the bottom of the screen
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: Material(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
              color: AppDesign.appLightGray,
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Stack(
                    alignment: AlignmentGeometry.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80.0),
                        child: SvgPicture.asset(
                          'assets/images/svg/data_verification_screen_top_graphic.svg',
                        ),
                      ),

                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 250.0),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: bottomInset),
                                child: Form(
                                  child: Column(
                                    spacing: 20.0,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Please confirm the details are correct",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: AppDesign.appOffblack,
                                          fontFamily: "AROneSans",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      VerificationSection(
                                        title: "Student Details",
                                        children: [
                                          LabeledField(
                                            label: "First Name",
                                            controller: _stuFirstNameController,
                                            formatters: [NameFormatter()],
                                            keyboardType: TextInputType.name,
                                            textCapitalization: TextCapitalization.words,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Middle Initial",
                                                      controller: _stuMiddleInitialController,
                                                      formatters: [
                                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]')),
                                                        MIFormatter()
                                                      ],
                                                      keyboardType: TextInputType.name,
                                                      textCapitalization: TextCapitalization.words,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 10.0,
                                              ),

                                              Expanded(
                                                flex: 7,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Last Name",
                                                      controller: _stuLastNameController,
                                                      formatters: [
                                                        NameFormatter()
                                                      ],
                                                      keyboardType: TextInputType.name,
                                                      textCapitalization: TextCapitalization.words,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          LabeledField(
                                            label: "Student Number",
                                            controller: _stuNumController,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),

                                      VerificationSection(
                                        title: "Transaction Details",
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Month",
                                                      suffixIcon: Icons.arrow_drop_down,
                                                      controller: _transactMonthController,
                                                      formatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        LengthLimitingTextInputFormatter(2),
                                                      ],
                                                      keyboardType: TextInputType.number,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        await _selectDate(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Day",
                                                      suffixIcon: Icons.arrow_drop_down,
                                                      controller: _transactDayController,
                                                      formatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        LengthLimitingTextInputFormatter(2),
                                                      ],
                                                      keyboardType: TextInputType.number,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        await _selectDate(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Year",
                                                      suffixIcon: Icons.arrow_drop_down,
                                                      controller: _transactYearController,
                                                      formatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        LengthLimitingTextInputFormatter(2),
                                                      ],
                                                      keyboardType: TextInputType.number,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        await _selectDate(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          LabeledField(
                                            label: "Amount",
                                            controller: _transactAmountController,
                                            formatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            prefixText: "PHP ",
                                          ),

                                          LabeledField(
                                            label: "Amount in words",
                                            suffixIcon: Icons.edit_off_outlined,
                                            textColor: Colors.grey.shade500,
                                            controller: _transactAmountWordsController,
                                            readOnly: true,
                                          ),

                                          LabeledField(
                                            label: "Description",
                                            controller: _transactDescriptionController,
                                            formatters: [
                                              NameFormatter(),
                                            ],
                                            textCapitalization: TextCapitalization.words,
                                          ),

                                          LabeledField(
                                            label: "Receipt Number",
                                            controller: _transactRecordNumController,
                                            formatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),

                                      VerificationSection(
                                        title: "Finance Officer Details",
                                        children: [
                                          LabeledField(
                                            label: "First Name",
                                            controller: _foFirstNameController,
                                            formatters: [
                                              NameFormatter(),
                                            ],
                                            keyboardType: TextInputType.name,
                                            textCapitalization: TextCapitalization.words,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Middle Initial",
                                                      controller: _foMiddleInitialController,
                                                      formatters: [
                                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]')),
                                                        MIFormatter()
                                                      ],
                                                      keyboardType: TextInputType.name,
                                                      textCapitalization: TextCapitalization.words,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(width: 10.0),

                                              Expanded(
                                                flex: 7,
                                                child: Column(
                                                  spacing: 5.0,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    LabeledField(
                                                      label: "Last Name",
                                                      controller: _foLastNameController,
                                                      formatters: [
                                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]')),
                                                        MIFormatter()
                                                      ],
                                                      keyboardType: TextInputType.name,
                                                      textCapitalization: TextCapitalization.words,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      GradientBorderButton(
                                        onPressed: () async {
                                          try {
                                            _setTransactionFromFields();

                                            final List<Map<String, dynamic>> response =
                                              await context.read<DbService>().insertTransaction(widget.transaction);

                                            if (response.isNotEmpty) {
                                              debugPrint('Transaction saved successfully! ID: ${response.first['id']}');

                                              if (!context.mounted) return;

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return _Popup(
                                                    GradientIcon(
                                                      icon: Icons.check_circle_outline,
                                                      size: 48.0,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppDesign.primaryGradientStart,
                                                          AppDesign.primaryGradientEnd,
                                                        ],
                                                      ),
                                                    ),
                                                    "Data saved successfully!\nReceipt was also sent to student's email.",
                                                    GradientBorderButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                                      },
                                                      borderRadius: BorderRadius.circular(30.0),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppDesign.primaryGradientStart,
                                                          AppDesign.primaryGradientEnd,
                                                        ],
                                                      ),
                                                      child: Text(
                                                        "Confirm",
                                                        style: TextStyle(
                                                          color: AppDesign.appOffblack,
                                                          fontSize: 12.0,
                                                          fontFamily: "AROneSans",
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              );
                                            }
                                          } catch (e) {
                                            debugPrint('Upload Failed $e');

                                            if (!context.mounted) return;

                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return _Popup(
                                                  Icon(
                                                    Icons.error,
                                                    size: 48.0,
                                                    color: Colors.red,
                                                  ),
                                                  "Failed to upload the data!\nFailed to generate receipt! :(",
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context, rootNavigator: true).pop();
                                                    },
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Ok",
                                                          style: TextStyle(
                                                            color: AppDesign.appOffblack,
                                                            fontSize: 14.0,
                                                            fontFamily: "AROneSans",
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            );
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30.0),
                                        gradient: const LinearGradient(
                                          colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                        ),
                                        child: const Text(
                                          "Upload to Database",
                                          style: TextStyle(
                                            color: AppDesign.appOffblack,
                                            fontSize: 14.0,
                                            fontFamily: "AROneSans",
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  _TopStickyButton(
                    text: widget.isFromHomeScreen ?
                    'Back to Home' :
                    'Retake Photo',
                    iconData: widget.isFromHomeScreen ?
                    Icons.arrow_back_rounded :
                    Icons.replay,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopStickyButton extends StatelessWidget {
  final String text;
  final IconData iconData;

  const _TopStickyButton({
    super.key,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: AppDesign.sBtnIconSize,
                color: AppDesign.appOffblack,
              ),

              SizedBox(width: 10.0),

              Text(
                text,
                style: TextStyle(
                  color: AppDesign.appOffblack,
                  fontFamily: "AROneSans",
                  fontWeight: FontWeight.bold,
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}

class _Popup extends StatelessWidget {
  const _Popup(
    this.icon,
    this.dialog,
    this.btn,
  );

  final Widget icon;
  final String dialog;
  final Widget btn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 30.0,
      ),
      color: Colors.black12,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20.0,
            children: [
              icon,

              Text(
                dialog,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppDesign.appOffblack,
                  fontSize: 14.0,
                  fontFamily: "AROneSans",
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none
                ),
              ),

              btn,
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const VerificationSection({
    super.key,
    required this.title,
    required this.children,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDesign.defaultBoxShadows,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        spacing: 5.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
            color: AppDesign.appOffblack,
            fontSize: 18.0,
            fontFamily: "AROneSans",
            fontWeight: FontWeight.bold,
          )), // Use a constant style
          const Divider(color: Colors.grey),
          ...children,
        ],
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? prefixText;
  final IconData suffixIcon;
  final Color? textColor;
  final Color? fillColor;

  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.formatters,
    this.keyboardType,
    this.textCapitalization,
    this.onTap,
    this.readOnly = false,
    this.prefixText,
    this.suffixIcon = Icons.edit_outlined,
    this.textColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.0, fontFamily: "AROneSans", fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        GradientTextFormField(
          controller: controller,
          inputFormatters: formatters,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          readOnly: readOnly,
          onTap: onTap,
          prefixText: prefixText,

          // Shared design properties
          textColor: textColor,
          fillColor: fillColor,
          activeGradient: const LinearGradient(
            colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
          ),
          borderRadius: BorderRadius.circular(30.0),
          suffixIcon: GradientIcon(
            icon: suffixIcon,
            size: 24.0,
            gradient: const LinearGradient(
              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )
          ),
        ),
      ],
    );
  }
}
