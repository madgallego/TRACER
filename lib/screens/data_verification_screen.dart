import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tracer/services/db_service.dart';
import 'package:tracer/utils/feedback_helper.dart';
import 'package:tracer/utils/formatters.dart';
import 'package:tracer/view_models/data_verification_screen_view_model.dart';
import 'package:tracer/widgets/error_snackbar.dart';
import 'package:tracer/widgets/gradient_border_button.dart';
import 'package:tracer/widgets/gradient_icon.dart';

import 'package:tracer/utils/constants.dart';
import 'package:tracer/models/transaction.dart';
import 'package:tracer/widgets/labeled_widgets.dart';
import 'package:tracer/widgets/titled_card.dart';

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
  VerificationViewModel viewModel = VerificationViewModel();

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
        viewModel.transactDayController.text = pickedDate.day.toString().padLeft(2, '0');
        viewModel.transactMonthController.text = pickedDate.month.toString().padLeft(2, '0');
        viewModel.transactYearController.text = pickedDate.year.toString();
      });
    }
  }

  @override
  void initState() {
    viewModel.init(widget.transaction);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size of the gesture hint / navbar at the bottom of the screen
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: viewModel.isEmpty(),

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        showUnsavedDialog(context);
      },

      child: Scaffold(
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
                                          'Please confirm the details are correct',
                                          style: AppDesign.subHeading2Style,
                                        ),

                                        TitledCard(
                                          title: "Student Details",
                                          icon: GradientIcon(
                                            icon: Icons.account_circle_rounded,
                                            size: AppDesign.sIconSize,
                                          ),
                                          children: [
                                            LabeledFormField(
                                              label: "Student Number",
                                              controller: viewModel.stuNumController,
                                              formatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                              ],
                                              keyboardType: TextInputType.number,
                                            ),

                                            Text(
                                              'The app fetches the student\'s details from the database using the student number.',
                                              style: AppDesign.bodyStyle.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),

                                        TitledCard(
                                          title: "Transaction Details",
                                          icon: GradientIcon(
                                            icon: Icons.credit_card_rounded,
                                            size: AppDesign.sIconSize,
                                          ),
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
                                                      LabeledFormField(
                                                        label: "Month",
                                                        suffixIcon: Icons.arrow_drop_down,
                                                        controller: viewModel.transactMonthController,
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
                                                      LabeledFormField(
                                                        label: "Day",
                                                        suffixIcon: Icons.arrow_drop_down,
                                                        controller: viewModel.transactDayController,
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
                                                      LabeledFormField(
                                                        label: "Year",
                                                        suffixIcon: Icons.arrow_drop_down,
                                                        controller: viewModel.transactYearController,
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

                                            LabeledFormField(
                                              label: "Amount",
                                              controller: viewModel.transactAmountController,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              onChanged: (_) {
                                                viewModel.transactAmountWordsController.text =
                                                  Formatters.amountToWords(viewModel.transactAmountController.text);
                                              },
                                              formatters: [
                                                // This regex allows digits and up to 2 decimal places (standard for PHP)
                                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                              ],
                                              prefixText: "PHP ",
                                            ),

                                            LabeledFormField(
                                              label: "Amount in words",
                                              suffixIcon: Icons.edit_off_outlined,
                                              iconColor: AppDesign.disabledGray,
                                              textColor: Colors.grey.shade500,
                                              controller: viewModel.transactAmountWordsController,
                                              readOnly: true,
                                            ),

                                            LabeledFormField(
                                              label: "Description",
                                              controller: viewModel.transactDescriptionController,
                                              formatters: [
                                                NameFormatter(),
                                              ],
                                              textCapitalization: TextCapitalization.words,
                                            ),

                                            LabeledFormField(
                                              label: "Receipt Number",
                                              controller: viewModel.transactRecordNumController,
                                              formatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                              keyboardType: TextInputType.number,
                                            ),
                                          ],
                                        ),

                                        TitledCard(
                                          title: "Finance Officer Details",
                                          icon: GradientIcon(
                                            icon: Icons.stars_rounded,
                                            size: AppDesign.sIconSize,
                                          ),
                                          children: [
                                            LabeledFormField(
                                              label: "First Name",
                                              controller: viewModel.foFirstNameController,
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
                                                      LabeledFormField(
                                                        label: "M.I.",
                                                        optional: true,
                                                        controller: viewModel.foMiddleInitialController,
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
                                                      LabeledFormField(
                                                        label: "Last Name",
                                                        controller: viewModel.foLastNameController,
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
                                          ],
                                        ),

                                        LabeledCheckbox(
                                          label: 'Send Receipt to Student',
                                          value: viewModel.isReceiptRequested,
                                          onChanged: (val) => setState(() => viewModel.isReceiptRequested = val ?? false)
                                        ),

                                        GradientBorderButton(
                                          isInternetRequired: true,
                                          onPressed: () async {
                                            if (viewModel.isMissingRequiredValue()) {
                                              ErrorSnackbar.show(context, 'Please fill in all required fields!');
                                              return;
                                            }

                                            viewModel.updateModel(widget.transaction);

                                            try {
                                              Transaction resp = await context.read<DbService>().insertTransaction(widget.transaction);

                                              if (!context.mounted) return;

                                              showSuccessDialog(context, resp);
                                            } on DuplicateReceiptException {
                                              ErrorSnackbar.show(context, 'Receipt number already exists.\nAre you sure it is correct?');
                                            } on NonExistentStudentException {
                                              ErrorSnackbar.show(context, 'Student Number does not exist\nAre you sure it is correct?');
                                            }
                                            catch (e) {
                                              ErrorSnackbar.show(context, 'Unknown error,\nPlease try again later.');
                                              debugPrint(e.toString());
                                            }
                                          },
                                          child: const Text(
                                            "Upload to Database",
                                            style: AppDesign.buttonTextStyle,
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
                      onPressed: () async {
                        if (!viewModel.isEmpty()) {
                          showUnsavedDialog(context);
                          return;
                        }

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showSuccessDialog(BuildContext context, Transaction resp) {
    FeedbackHelper.successFeedback();
    String dialog;
    String continueBtnText;

    if (resp.isReceiptRequested == true) {
      dialog = 'Data saved successfully!\nReceipt was also sent to student\'s email.';
    } else {
      dialog = 'Data saved successfully!';
    }

    if (widget.isFromHomeScreen) {
      continueBtnText = 'Input another receipt';
    } else {
      continueBtnText = 'Scan another receipt';
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,

          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },

          child: _Popup(
            GradientIcon(
              icon: Icons.check_circle_outline,
              size: AppDesign.mIconSize,
            ),
            dialog,
            GradientBorderButton(
              onPressed: () async {
                if (widget.isFromHomeScreen) {
                  widget.transaction = Transaction();
                  viewModel.clear();
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  Navigator.of(context).popUntil(ModalRoute.withName('/scan'));
                }

              },
              child: Text(
                continueBtnText,
                style: AppDesign.buttonTextStyle,
              ),
            ),
            btn2: GradientBorderButton(
              onPressed: () async {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              child: Text(
                'Back to Home',
                style: AppDesign.buttonTextStyle,
              ),
            ),
          ),
        );
      }
    );
  }

  Future<dynamic> showUnsavedDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _Popup(
          Icon(
            Icons.error_outline_rounded,
            size: 48.0,
            color: AppDesign.dangerRed,
          ),
          'Wait! You have unsaved changes!',
          GradientBorderButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text(
              "Go back",
              style: AppDesign.buttonTextStyle,
            ),
          ),
          btn2: GradientBorderButton(
            onPressed: () async {
              if (widget.isFromHomeScreen) {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
                return;
              }
              Navigator.of(context).popUntil(ModalRoute.withName('/scan'));
            },
            borderColor: AppDesign.dangerRed,
            child: Text(
              "Discard",
              style: AppDesign.buttonTextStyle,
            ),
          ),
        );
      }
    );
  }
}

class _TopStickyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onPressed;

  const _TopStickyButton({
    super.key,
    required this.text,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: AppDesign.sIconSize,
                color: AppDesign.appOffblack,
              ),

              SizedBox(width: 10.0),

              Text(
                text,
                style: AppDesign.buttonTextStyle,
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
    this.btn1, {
    this.btn2,
  });

  final Widget icon;
  final String dialog;
  final Widget btn1;
  final Widget? btn2;

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
              Column(
                spacing: 8.0,
                children: [
                  icon,

                  Text(
                    dialog,
                    textAlign: TextAlign.center,
                    style: AppDesign.bodyStyle.copyWith(decoration: TextDecoration.none),
                  ),
                ],
              ),

              Column(
                spacing: 12.0,
                children: [
                  btn1,
                  ?btn2,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
