import 'package:flutter/material.dart';
import 'package:tracer/widgets/gradient_border_button.dart';
import 'package:tracer/widgets/gradient_border_text_form_field.dart';
import 'package:tracer/widgets/gradient_icon.dart';

import '../utils/constants.dart';

class DataVerificationScreen extends StatefulWidget {
  const DataVerificationScreen({super.key});

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
  TextEditingController _transactPurposeController = TextEditingController();
  TextEditingController _transactReceiptNumController = TextEditingController();
  TextEditingController _foFirstNameController = TextEditingController();
  TextEditingController _foMiddleInitialController = TextEditingController();
  TextEditingController _foLastNameController = TextEditingController();


  void _setFieldInitialValues() {

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
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size of the gesture hint / navbar at the bottom of the screen
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
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
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                decoration: BoxDecoration(
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

                                  Text(
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

                          Text(
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
                                Text(
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
                                Text(
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
                                  borderRadius: BorderRadius.circular(30.0),
                                  activeGradient: LinearGradient(
                                    colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                  ),
                                  suffixIcon: GradientIcon(
                                    icon: Icons.edit_outlined,
                                    size: 24.0,
                                    gradient: LinearGradient(
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
                                          Text(
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
                                            borderRadius: BorderRadius.circular(30.0),
                                            activeGradient: LinearGradient(
                                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                            ),
                                            suffixIcon: GradientIcon(
                                              icon: Icons.edit_outlined,
                                              size: 24.0,
                                              gradient: LinearGradient(
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
                                          Text(
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
                                            borderRadius: BorderRadius.circular(30.0),
                                            activeGradient: LinearGradient(
                                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                            ),
                                            suffixIcon: GradientIcon(
                                              icon: Icons.edit_outlined,
                                              size: 24.0,
                                              gradient: LinearGradient(
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

                                Text(
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
                                  borderRadius: BorderRadius.circular(30.0),
                                  activeGradient: LinearGradient(
                                    colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                  ),
                                  suffixIcon: GradientIcon(
                                    icon: Icons.edit_outlined,
                                    size: 24.0,
                                    gradient: LinearGradient(
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
                                Text(
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
                                          Text(
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
                                            readOnly: true,
                                            onTap: () async {
                                              await _selectDate(context);
                                            },
                                            borderRadius: BorderRadius.circular(30.0),
                                            activeGradient: LinearGradient(
                                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                            ),
                                            suffixIcon: GradientIcon(
                                              icon: Icons.arrow_drop_down,
                                              size: 24.0,
                                              gradient: LinearGradient(
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
                                          Text(
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
                                            readOnly: true,
                                            onTap: () async {
                                              await _selectDate(context);
                                            },
                                            borderRadius: BorderRadius.circular(30.0),
                                            activeGradient: LinearGradient(
                                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                            ),
                                            suffixIcon: GradientIcon(
                                              icon: Icons.arrow_drop_down,
                                              size: 24.0,
                                              gradient: LinearGradient(
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
                                          Text(
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
                                            readOnly: true,
                                            onTap: () async {
                                              await _selectDate(context);
                                            },
                                            borderRadius: BorderRadius.circular(30.0),
                                            activeGradient: LinearGradient(
                                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                                            ),
                                            suffixIcon: GradientIcon(
                                              icon: Icons.arrow_drop_down,
                                              size: 24.0,
                                              gradient: LinearGradient(
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
                                )

                              ],
                            ),

                          ),

                          // TODO: more containers here!

                          GradientBorderButton(
                            onPressed: () async {

                            },
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                            ),
                            child: Text(
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
    );
  }
}
