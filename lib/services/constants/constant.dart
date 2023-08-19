import 'package:flutter/material.dart';

const defaultPadding = 16.0;
const String noInternet = "No internet connection";
const String saved = "Information has been saved";
const String duplicate = "Record already stored in the database";
const String notSaved = "Something happened, could not save record";
const String infoNeeded = 'Please provide the required information to get data';
const String emptyPrint = "There are no record to print.";
const String companyName = "ROYAL FOAM GHANA LIMITED";
const String deleted = "Record has been deleted";
const String exportError = "Exporting record was not successfull";
const String export = "Record has been exported to Document with name:";
const String numberOnly = "Entry must be numbers only";
const String appName = "e3 Sales";
const String appLink = "esales.bistechgh.com";

const double pdfFont = 8;
const double pdfFontHeader = 8;
const double pdfFHead = 12;
const double pHeight = 800;

//var myFont = Font.ttf("asssets/fonts/Poppins-Regular.ttf");
const int rowsList = 15;

double myHeight(context, value) {
  return MediaQuery.of(context).size.height / value;
}

double myWidth(context, value) {
  return MediaQuery.of(context).size.width / value;
}

double myHeightTimes(context, value) {
  return MediaQuery.of(context).size.height * value;
}

double myWidthTimes(context, value) {
  return MediaQuery.of(context).size.width * value;
}

double screenHeight(context) => MediaQuery.of(context).size.height;
double screenWidth(context) => MediaQuery.of(context).size.width;
