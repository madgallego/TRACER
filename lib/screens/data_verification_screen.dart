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
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                      color: AppDesign.appOffblack
                                    ),
                                  )
                                ]
                              ),
                            )
                          ),

                          Text(
                            "Please confirm the details are correct.",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppDesign.appOffblack
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Student Details",
                                  style: TextStyle(
                                    color: AppDesign.appOffblack,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey
                                ),
                                Text(
                                  "First Name"
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
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Text("Middle Initial"),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Last Name"),
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

                                Text("Student No."),
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

                          // TODO: more containers here!

                          GradientBorderButton(
                            onPressed: () async {

                            },
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
                            ),
                            child: Text("Upload to Database"),
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
