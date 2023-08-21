import 'package:flutter/material.dart';
import 'package:odlay_services/Styles/utils.dart';

class Styles {
  // declare two fonts into separate varibales
  static final String trojanFont = 'Trajan Pro';
  static final String schylerFont = 'Schyler';

  // normal text style
  static final TextStyle simpleText =
      TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold);
//upgrade sp message style
  static final TextStyle sp_note_style =
  TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold);
  static final TextStyle simpleTextColored =
      TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
  // normal text style
  static final TextStyle simpleTextRcpt = TextStyle(
      color: Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

// normal text style data
  static final TextStyle simpleTextData =
      TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);

  static final TextStyle simpleTextDataRcpt = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);
//profile stength
  static final TextStyle strengthTextStyle =
      TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold);
// normal text white style
  static final TextStyle simpletextStyleGig =
      TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold);
  static final TextStyle simpletextStyleGigColor =
      TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold);
//heading account
  static final TextStyle textStyleHeadingMyAccount =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
//heading style
  static final TextStyle headingText =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
//profile style
  static final TextStyle textProfileStyle =
      TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold);
//company name overflow
  static final TextStyle companyNameProfileStyle =
      TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold);
  static final TextStyle textSkillsStyle =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
//application description
static final TextStyle textdescriptionStyle =
      TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal);      
//profile style
  static final TextStyle textProfileStyle1 =
      TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold);
//review text style
//profile style
  static final TextStyle nameReview =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
//heading style color
  static final TextStyle headingTextColor = TextStyle(
      color: Color.fromARGB(255, 129, 16, 16),
      fontSize: 14,
      fontWeight: FontWeight.bold);

//odlay fee style color
  static final TextStyle OdlayTextColor = TextStyle(
      color: Color.fromARGB(255, 6, 6, 6),
      fontSize: 14,
      fontWeight: FontWeight.bold);
//note
  static final TextStyle noteTextColor =
      TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.normal);
//adress not
  static final TextStyle noteTextColorAddress = TextStyle(
      color: Color.fromARGB(255, 171, 27, 16),
      fontSize: 10,
      fontWeight: FontWeight.normal);
  // extend the header style into body
  static final bodyStyle = extend(simpleText,
      TextStyle(fontSize: 40, decoration: TextDecoration.underline));
//text style bottom sheet job title
  static final TextStyle textStyleJobTitle = TextStyle(
      color: Color.fromRGBO(255, 118, 87, 1),
      fontSize: 18,
      fontWeight: FontWeight.bold);
//gig style
  static final TextStyle textStyleGigTitle = TextStyle(
      color: Color.fromRGBO(255, 118, 87, 1),
      fontSize: 14,
      fontWeight: FontWeight.bold);
//review text styles
  static final TextStyle reviewTextStyle = TextStyle(
      color: Color.fromRGBO(255, 118, 87, 1),
      fontSize: 14,
      fontWeight: FontWeight.bold);
//text style bottom sheet note
  static final TextStyle textStyleJobTitleNote = TextStyle(
      color: Color.fromARGB(255, 255, 47, 0),
      fontSize: 14,
      fontWeight: FontWeight.bold);
//text style bottom sheet heading
  static final TextStyle textStyleJobSheetHeading = TextStyle(
      color: Color.fromARGB(255, 88, 88, 88),
      fontSize: 14,
      fontWeight: FontWeight.bold);
//budgetting style
  static final TextStyle textStyleJobSheetbudget =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
//budgetting style customer
  static final TextStyle textStyleJobSheetbudgetCustomer =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
//budgetting style customer
  static final TextStyle textStyleMyAccount =
      TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
//text style signout
  static final TextStyle textStyleSignOutAccount = TextStyle(
      color: Color.fromARGB(255, 225, 8, 8),
      fontSize: 14,
      fontWeight: FontWeight.bold);
//budgetting style colord
  static final TextStyle textStyleJobSheetbudgetColored =
      TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold);
  //budgetting style color customer
  static final TextStyle textStyleJobSheetbudgetColoredCustomer =
      TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle textStyleJobSheetbudgetColoredCustomerReceipt =
      TextStyle(
          color: Colors.green,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none);
//status color
  static final TextStyle textStyleStatusColor =
      TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold);

  static final TextStyle buttonStyles = TextStyle(
    fontFamily: schylerFont,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: Colors.white,
  );
  static final ButtonStyle appElevatedButtonStyle = ElevatedButton.styleFrom(
      primary: Color.fromRGBO(255, 118, 87, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // <-- Radius
      ),
      textStyle: const TextStyle(fontSize: 12, color: Colors.white));

  static final ButtonStyle appElevatedJobStatusButtonStyle =
      ElevatedButton.styleFrom(
          primary: const Color.fromRGBO(255, 118, 87, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // <-- Radius
          ),
          textStyle: const TextStyle(fontSize: 12, color: Colors.white));
//disable button style
  static final ButtonStyle appElevatedJobStatusButtonStyleDisable =
      ElevatedButton.styleFrom(
          primary: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // <-- Radius
          ),
          textStyle: const TextStyle(fontSize: 12, color: Colors.black));
  static final ButtonStyle appElevatedCancelButtonStyle =
      ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 99, 7, 7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // <-- Radius
          ),
          textStyle: const TextStyle(fontSize: 12, color: Colors.white));

//complete and uncomplete button styles
  static final ButtonStyle appElevatedButtonComplete = ElevatedButton.styleFrom(
      primary: Color.fromARGB(255, 23, 131, 204),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // <-- Radius
      ),
      textStyle: const TextStyle(fontSize: 12, color: Colors.white));

  static final ButtonStyle appElevatedButtonUnComplete =
      ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 204, 23, 23),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // <-- Radius
          ),
          textStyle: const TextStyle(fontSize: 12, color: Colors.white));
//review text styles
  static final TextStyle profileHeadings = TextStyle(
      color: Color.fromRGBO(255, 118, 87, 1),
      fontSize: 12,
      fontWeight: FontWeight.bold);

// detail review  text style
  static final TextStyle detailViewStyleHeader =
      TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
  static final TextStyle detailViewStyleChild = TextStyle(
      color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal);
}
