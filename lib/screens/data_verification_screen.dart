import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tracer/services/db_service.dart';
import 'package:tracer/utils/formatters.dart';
import 'package:tracer/widgets/gradient_border_button.dart';
import 'package:tracer/widgets/gradient_border_text_form_field.dart';
import 'package:tracer/widgets/gradient_icon.dart';

import '../utils/constants.dart';
import 'package:tracer/models/transaction.dart';

class DataVerificationScreen extends StatefulWidget {
  DataVerificationScreen({super.key, required this.transaction});

  Transaction transaction;

  @override
  DataVerificationScreenState createState() => DataVerificationScreenState();
}

class DataVerificationScreenState extends State<DataVerificationScreen> {
  // Controllers for text form fields
  TextEditingController _stuFirstNameController = TextEditingController();
  TextEditingController _stuMiddleInitialController = TextEditingController();
  TextEditingController _stuLastNameController = TextEditingController();
  TextEditingController _stuNumController = TextEditingController();
  TextEditingController _transactMonthController = TextEditingController();
  TextEditingController _transactDayController = TextEditingController();
  TextEditingController _transactYearController = TextEditingController();
  TextEditingController _transactAmountController = TextEditingController();
  TextEditingController _transactAmountWordsController = TextEditingController();
  TextEditingController _transactPurposeController = TextEditingController();
  TextEditingController _foFirstNameController = TextEditingController();
  TextEditingController _foMiddleInitialController = TextEditingController();
  TextEditingController _foLastNameController = TextEditingController();


  void _setFieldInitialValues() {
    _stuFirstNameController.text = widget.transaction.stuFirstName ?? "";
    _stuMiddleInitialController.text = widget.transaction.stuMiddleInitial ?? "";
    _stuLastNameController.text = widget.transaction.stuLastName ?? "";
    _stuNumController.text = widget.transaction.stuNum ?? "";
    _transactMonthController.text = widget.transaction.transactMonth ?? "";
    _transactDayController.text = widget.transaction.transactDay ?? "";
    _transactYearController.text = widget.transaction.transactYear ?? "";
    _transactAmountController.text = widget.transaction.transactAmount ?? "";
    _transactAmountWordsController.text = widget.transaction.transactAmountWords ?? "";
    _transactPurposeController.text = widget.transaction.transactPurpose ?? "";
    _foFirstNameController.text = widget.transaction.foFirstName ?? "";
    _foMiddleInitialController.text = widget.transaction.foMiddleInitial ?? "";
    _foLastNameController.text = widget.transaction.foLastName ?? "";
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
    _transactPurposeController.dispose();
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
              gradient: LinearGradient(
                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: bottomInset),
                      child: Form(
                        child: Column(
                          spacing: 20.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 15.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      size: AppDesign.sBtnIconSize,
                                      color: AppDesign.appOffblack,
                                    ),

                                    SizedBox(width: 10.0),

                                    const Text(
                                      "Retake photo",
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

                            const Text(
                              "Please confirm the details are correct",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppDesign.appOffblack,
                                fontFamily: "AROneSans",
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: AppDesign.appPaleCyan,
                                boxShadow: AppDesign.defaultBoxShadows,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Column(
                                spacing: 5.0,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Student Details",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 18.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey
                                  ),
                                  const Text(
                                    "First Name",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 12.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GradientTextFormField(
                                    controller: _stuFirstNameController,
                                    inputFormatters: [
                                      NameFormatter()
                                    ],
                                    keyboardType: TextInputType.name,
                                    textCapitalization: TextCapitalization.words,
                                    borderRadius: BorderRadius.circular(30.0),
                                    activeGradient: const LinearGradient(
                                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                    ),
                                    suffixIcon: GradientIcon(
                                      icon: Icons.edit_outlined,
                                      size: 24.0,
                                      gradient: const LinearGradient(
                                        colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    ),
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
                                            const Text(
                                              "Middle Initial",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _stuMiddleInitialController,
                                              inputFormatters: [
                                                NameFormatter()
                                              ],
                                              keyboardType: TextInputType.name,
                                              textCapitalization: TextCapitalization.words,
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.edit_outlined,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
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
                                            const Text(
                                              "Last Name",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _stuLastNameController,
                                              inputFormatters: [
                                                NameFormatter()
                                              ],
                                              keyboardType: TextInputType.name,
                                              textCapitalization: TextCapitalization.words,
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.edit_outlined,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Text(
                                    "Student No.",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 12.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GradientTextFormField(
                                    controller: _stuNumController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]-'))
                                    ],
                                    keyboardType: TextInputType.number,
                                    borderRadius: BorderRadius.circular(30.0),
                                    activeGradient: const LinearGradient(
                                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                    ),
                                    suffixIcon: GradientIcon(
                                      icon: Icons.edit_outlined,
                                      size: 24.0,
                                      gradient: const LinearGradient(
                                        colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: AppDesign.appPaleCyan,
                                boxShadow: AppDesign.defaultBoxShadows,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Column(
                                spacing: 5.0,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Transaction Details",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 18.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          spacing: 5.0,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Month",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _transactMonthController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(2),
                                              ],
                                              readOnly: true,
                                              onTap: () async {
                                                await _selectDate(context);
                                              },
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.arrow_drop_down,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
                                            )
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
                                            const Text(
                                              "Day",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _transactDayController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(2),
                                              ],
                                              readOnly: true,
                                              onTap: () async {
                                                await _selectDate(context);
                                              },
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.arrow_drop_down,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
                                            )
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
                                            const Text(
                                              "Year",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _transactYearController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(2),
                                              ],
                                              readOnly: true,
                                              onTap: () async {
                                                await _selectDate(context);
                                              },
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.arrow_drop_down,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Text(
                                    "Amount",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 12.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GradientTextFormField(
                                    controller: _transactAmountController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    onTap: () async {

                                    },
                                    borderRadius: BorderRadius.circular(30.0),
                                    activeGradient: const LinearGradient(
                                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                    ),
                                    prefixText: "PHP ",
                                    suffixIcon: GradientIcon(
                                      icon: Icons.edit_outlined,
                                      size: 24.0,
                                      gradient: const LinearGradient(
                                        colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    ),
                                  ),

                                  const Text(
                                    "Amount in words",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 12.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GradientTextFormField(
                                    controller: _transactAmountWordsController,
                                    readOnly: true,
                                    onTap: () async {

                                    },
                                    borderRadius: BorderRadius.circular(30.0),
                                    fillColor: Colors.grey.shade100,
                                    activeGradient: const LinearGradient(
                                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                    ),
                                    suffixIcon: GradientIcon(
                                      icon: Icons.edit_off_outlined,
                                      size: 24.0,
                                      gradient: const LinearGradient(
                                        colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    ),
                                  ),

                                  const Text(
                                    "Purpose of the transaction",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 12.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GradientTextFormField(
                                    controller: _transactPurposeController,
                                    textCapitalization: TextCapitalization.words,
                                    onTap: () async {

                                    },
                                    borderRadius: BorderRadius.circular(30.0),
                                    activeGradient: const LinearGradient(
                                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                    ),
                                    suffixIcon: GradientIcon(
                                      icon: Icons.edit_outlined,
                                      size: 24.0,
                                      gradient: const LinearGradient(
                                        colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: AppDesign.appPaleCyan,
                                boxShadow: AppDesign.defaultBoxShadows,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Column(
                                spacing: 5.0,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Finance Officer Details",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 18.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey
                                  ),

                                  const Text(
                                    "First Name",
                                    style: TextStyle(
                                      color: AppDesign.appOffblack,
                                      fontSize: 12.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GradientTextFormField(
                                    controller: _foFirstNameController,
                                    inputFormatters: [
                                      NameFormatter()
                                    ],
                                    keyboardType: TextInputType.name,
                                    textCapitalization: TextCapitalization.words,
                                    onTap: () async {

                                    },
                                    borderRadius: BorderRadius.circular(30.0),
                                    activeGradient: const LinearGradient(
                                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                    ),
                                    suffixIcon: GradientIcon(
                                      icon: Icons.edit_outlined,
                                      size: 24.0,
                                      gradient: const LinearGradient(
                                        colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )
                                    ),
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
                                            const Text(
                                              "Middle Initial",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _foMiddleInitialController,
                                              inputFormatters: [
                                                NameFormatter()
                                              ],
                                              keyboardType: TextInputType.name,
                                              textCapitalization: TextCapitalization.words,
                                              onTap: () {

                                              },
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.edit_outlined,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
                                            )
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
                                            const Text(
                                              "Last Name",
                                              style: TextStyle(
                                                color: AppDesign.appOffblack,
                                                fontSize: 12.0,
                                                fontFamily: "AROneSans",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GradientTextFormField(
                                              controller: _foLastNameController,
                                              inputFormatters: [
                                                NameFormatter()
                                              ],
                                              keyboardType: TextInputType.name,
                                              textCapitalization: TextCapitalization.words,
                                              onTap: () {

                                              },
                                              borderRadius: BorderRadius.circular(30.0),
                                              activeGradient: const LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                              ),
                                              suffixIcon: GradientIcon(
                                                icon: Icons.edit_outlined,
                                                size: 24.0,
                                                gradient: const LinearGradient(
                                                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),

                            GradientBorderButton(
                              onPressed: () async {
                                context.read<DbService>().insertTransaction(widget.transaction);
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
