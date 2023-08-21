import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyAgreement extends StatefulWidget {
  final VoidCallback? onPressed;
  PrivacyPolicyAgreement(this.onPressed);

  @override
  State<PrivacyPolicyAgreement> createState() => _PrivacyPolicyAgreementState();
}

class _PrivacyPolicyAgreementState extends State<PrivacyPolicyAgreement> {
  bool? agree_terms = false;
  bool? agree_policy = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 232, 229, 229),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Text('wellcome_to_odlay'.tr,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text('privacy_policy_paragraph'.tr,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ))))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.agree_policy,
                          onChanged: (bool) {
                            agree_policy = bool;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: termsPrivacyLink(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.agree_terms,
                          onChanged: (bool) {
                            agree_terms = bool;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: termsConditionsLink(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 35,
                    child: agree_policy == true && agree_terms == true
                        ? AppElevatedButton(
                            borderRadius: BorderRadius.circular(20),
                            onPressed: widget.onPressed,
                            child: const Text('Continue'),
                          )
                        : Container(
                            margin: EdgeInsets.all(10),
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  showToast(
                                      "Please Accept Terms and conditions and policy",
                                      context: context,
                                      backgroundColor: Colors.green);
                                },
                                icon: const Icon(
                                  // <-- Icon

                                  Icons.camera_alt_outlined,
                                  size: 0.0,
                                ),
                                label: Text(
                                  'Continue',
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  primary: Colors.grey,
                                )),
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget termsConditionsLink(BuildContext context) {
    TextStyle defaultStyle =
        TextStyle(color: Colors.orange[900], fontSize: 12.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 12.0);
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: 'I have read and agree with '),
          TextSpan(
              text: 'User Terms',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse(AppConstants.privacy_terms_links));
                }),
          TextSpan(text: ' of Odlay Services'),
        ],
      ),
    );
  }

  Widget termsPrivacyLink(BuildContext context) {
    TextStyle defaultStyle =
        TextStyle(color: Colors.orange[900], fontSize: 12.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 12.0);
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: 'I have read and agree with '),
          TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse(AppConstants.privacy_policy_link));
                }),
          TextSpan(text: ' of Odlay Services'),
        ],
      ),
    );
  }
}
