import 'package:flutter/material.dart';
import 'package:inputgram/util.dart';

String mainDb = "mainDb";
String titleSuccess = "Success";
String subtitleSuccess = "Submitted!";

String kTitleSuccess = "Login/registeration failed";
String kSubtitleSuccess = "Try again with correct username & password";
String kSubTitleEntryAlreadyPresent = "Entry already present, can not add";
String kTitlePresent = "PRESENT";
String kTitleNotPresent = "No Present";
String kSubTitleEmailPresent = "Email not present";
String kTitleSignOut = "SignOut";
String kSubtitleLogOutConfirmation = "Do you want to log out?";
//Msgs
String msgOnlyNumber = "Please enter only numbers";
String msgEnterEmail = "Please Enter admin email";
String msgEnterUserMail = "Enter email";
String msgEnterPassword = "Please Enter min 6 char Password";
String msgReEnterPassword = "Please re enter password";
String msgEnterVillageName = 'Please enter village name';
String msgEnterVillagePin = 'Please enter village pin';
String msgEnterVillageAddress = 'Please enter village address';
String msgEnterMobileNumber = "Enter mobile Number";
String msgTenDigitNumber = "Please enter 10 digits!";
String msgEnterFullName = "Enter Full Name";
String msgEnterHouseTax = "Enter House tax";
String msgHouseTaxAmount = 'Please enter house tax amount';
String msgWaterTax = "Enter Water tax";
String msgProcessingData = 'Processing Data';
String msgAlreadyRemoved = "Allready Removed";
String msgToogleToApproveDis = "Toggle to approve/disapprove user";
String msgNoExpense = "There is no expense";
String msgLoading = "loading";

String msgNotAdmin = "notAdmin";
//button Labels
String bLabelAdminlogin = 'Admin Log In';
String bLabelAdminRegiter = 'Admin Register';
String bLabelSubmit = 'Submit';

//Drawer sections
String dAddEntry = 'addEntry';
String dRemoveEntry = 'removeEntry';
String dApprove = 'Approve';
String dHeading = 'Admin';

//options pop up
String optCancel = "cancel";
String optOk = "OK";

//appLable
String appLabel = 'Gram Admin';
//activity type
String actPending = "PENDING";
String actIn = "IN";

//Table data column heading
String tableHeadingEmail = 'Email';
String tableHeadingStatus = 'Status';
String tableHeadingAccess = 'Access';
String tableHeadingChangeStatus = 'ChangeStatus';
//String tableHeading = "";

//Form field Lable
String labelWaterTax = "Water Tax *";
String labelMobile = "Mobile *";
String labelAdminEmail = "AdminEmail *";
String labelEmail = "Mail * ";
String labelAdminPassword = "AdminPassword *";
String labelVillage = "Village *";
String labelPin = "Pin *";
String labelVillageAddress = "VillageAddress *";
String labelRegister = 'Register';
String labelLogin = 'Log In';
String labelName = "Name *";
String labelHouseTax = "House Tax *";

//doc strings
String docVillageInfo = "villageInfo";
String docCalcultion = 'calculation';

//collection strings
String collUsers = 'users';
String collFormula = 'formula';

//app bar heading
String appBarHeadingApproveRemove = "Approve/Remove";
String appBarHeadingInputInfo = "Add New Person to GramDB";
String appBarHeadingRemoveInfo = "Remove Person from GramDB";
String appBarMainAppInfo = 'Admin, Register, approve, make db';

//keys
String keyVillage = 'village';
String keyPin = 'pin';
String keyApproved = 'approved';
String keyAccessLevel = 'accessLevel';
String keyMail = 'mail';
String keyIsAdmin = 'isAdmin';
String keyAccess = "accessLevel";
String keyAddress = 'address';
String keyAdminMail = 'adminMail';
String keyHouse = 'house';
String keyHouseGiven = 'houseGiven';
String keyWater = 'water';
String keyWaterGiven = 'waterGiven';
String keyMobile = "mobile";
String keyName = "name";
String keyEmail = "email";
String keyTotalBalance = 'totalBalance';
String keyTotalIn = 'totalIn';
String keyTotalOut = 'totalOut';

//String key = "";

String scafBeginInfoApproveRemove =
    "Please approve or remove clicking toggle icon";

//From util oldies
String registerSubtitleSuccess = "Register success!";
String registerSuccess = "Admin and village regsitered successfully";
String kTitleFail = "Login/registeration failed";
String kTitleTryCatchFail =
    "Fail"; //dont know reason. some failure in try catch
String kSubtitleFail = "Try again with correct username & password";
String kTitleLoginSuccess = "login success";

String kSubTitleOnlyAdmin = "Only Admin allowed";
String titlePasswordMismatch = "Password mismatch";
String subtitlePasswordMismatch =
    "password and re entered password should match";

String kTitleEntryRemoved = "Entry Removed";

String tableHeadingFontFamily = "RobotoMono";
String labelYear = "Year";

Color clrGreen = Color(0xFFc8e6c9); //in

Color clrRed = Color(0xffef9a9a); //out

Color clrAmber = Color(0xFFF7E5B4); //pending

Color clrBlue = Color(0xFF7E57E2); //report indigo;

String dropdownvalue = "2021";
var items = [
  "2012",
  "2013",
  "2014",
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
  "2021",
  "2022",
];

String access = "select";
enum accessLevel {
  select,
  Viewer,
  Collector,
  Spender,
  SuperUser,
}
var accessItems = [
  "select",
  "Viewer",
  "Collector",
  "Spender",
  "SuperUser",
];
