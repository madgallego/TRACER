import 'package:flutter/material.dart';

import '../utils/constants.dart';

class DataVerificationScreen extends StatefulWidget {
  const DataVerificationScreen({super.key});

  @override
  DataVerificationScreenState createState() => DataVerificationScreenState();
}

class DataVerificationScreenState extends State<DataVerificationScreen> {

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
    return Container(
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
                child: Column(
                  spacing: 20.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        overlayColor: Colors.black,
                        padding: EdgeInsets.zero
                      ),
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
                      child: Text(
                        "Student Details",
                        style: TextStyle(
                          color: AppDesign.appOffblack,
                          fontSize: 14.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
