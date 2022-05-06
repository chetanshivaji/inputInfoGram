import 'package:flutter/material.dart';
import 'package:inputgram/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String mainDb = "mainDb";

String titleSuccess = "Success";
String subtitleSuccess = "Submitted!";

String kTitleSuccess = "Login/registeration failed";
String kSubtitleSuccess = "Try again with correct username & password";
String kSubTitleEntryAlreadyPresent =
    "Entry mobile/uid present, Use new mobile/uid";
String kTitlePresent = "PRESENT";
String kTitleNotPresent = "No Present";
String kTitleMobileNotPresent = "Mobile not Present";
String kTitleMultiUids = "Multiple Uids for mobile, please enter one";
String kTitleMultiUids_AddPerson =
    "Multi UIDs found last Year, Enter one Or create new one, Press SUBMIT";
String kSubTitleEmailNotPresent = "Email not present";
String kTitleSignOut = "SignOut";
String kTitleVillageAlreadyPresent =
    "Vilage already present. Use different village";
String kSubtitleLogOutConfirmation = "Do you want to log out?";
String kTitleForgotPasswordMailSent = "Mail sent to change password";
String kSubTitleForgotPasswordMailSent = "Please check your login email inbox";
//Msgs
String msgOnlyNumber = "Please enter only numbers";
String msgNoStartZero = "Mobile not start with zero";
String msgEnterEmail = "Please Enter admin email";
String msgEnterUser = "Enter your name";
String msgEnterUserMail = "Enter email";
String msgEnterUserNewMail = "Enter new email";
String msgEnterPassword = "Please Enter min 6 char Password";
String msgReEnterPassword = "Please re enter password";
String msgEnterVillageName = 'Please enter village name';
String msgEnterVillagePin = 'Please enter village pin';

String msgEnterMobileNumber = "Enter mobile Number";
String msgEnterNewMobileNumber = "Enter new mobile Number";
String msgTenDigitNumber = "Please enter 10 digits!";
String msgEnterFullName = "Enter Full Name";
String msgEnterHouseTax = "Enter House tax";
String msgHouseTaxAmount = 'Please enter house tax amount';
String msgWaterTax = "Enter Water tax";
String msgExtraInfo = "Enter Extra Information";
String msgProcessingData = 'Processing Data';
String msgAlreadyRemoved = "Allready Removed";

String msgNoExpense = "There is no expense";
String msgLoading = "loading";

String msgNotAdmin = "notAdmin";
//button Labels
String bLabelAdminlogin = 'Admin Log In';
String bLabelAdminRegiter = 'Admin Register';
String bLabelSubmit = 'Submit';
String bLabelAdd = 'Add';
String bLabelSubmitRefresh = 'Submit/Refresh';

//Drawer sections
String dAddPerson = 'AddPersonTax';
String dRemovePerson = 'RemovePersonTax';
String dApprove = 'Approve';
String dReport = 'Report';
String dUpdatePerson = 'UpdatePerson';
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
String tableHeadingRegisteredName = 'Name';
String tableHeadingStatus = 'Status';
String tableHeadingExtraInfo = 'ExtraInfo';

//String tableHeading = "";
String tableHeading_srNum = "SrNum.";

String tableHeading_year = "Year";
String tableHeading_totalHouse = "TotalHouse";
String tableHeading_pendingHouse = "PendingHouse";
String tableHeading_collectedHouse = "CollectedHouse";
String tableHeading_totalWater = "TotalWater";
String tableHeading_pendingWater = "PendingWater";
String tableHeading_collectedWater = "CollectedWater";

//Form field Lable
String labelExtraInfo = "Extra information";
String labelWaterTax = "Water Tax *";
String labelMobile = "Mobile *";
String labelUid = "Uid *";
String labelNewMobile = "New Mobile *";
String labelNewEmail = "New Email";
String labelAdminEmail = "AdminEmail *";
String labelEmail = "Mail * ";
String labelAdminPassword = "AdminPassword *";
String labelVillage = "Village *";
String labelPin = "Pin *";

String labelRegister = 'Register';
String labelLogin = 'Log In';
String labelForgotPassword = 'Forgot Password?';

String labelName = "Name *";

String labelHouseTax = "House Tax *";

//doc strings
String docVillageInfo = "villageInfo";
String docCalcultion = 'calculation';
String docMobileUidMap = 'mobileUidMap';
String docUids = "uids";

//collection strings
String collUsers = 'users';
String collFormula = 'formula';

//app bar heading
String appBarHeadingApproveRemove = "Approve/Remove";
String appBarHeadingInputInfo = "Add New Person Gram";
String appBarHeadingRemoveInfo = "Remove Person Gram";
String appBarMainAppInfo = 'Admin, Register, approve, make db';
String appBarHeadingUpdateInfo = 'Update Info in Gram';
String appBarHeadingReportInfo = 'Report Info in Gram';

String tableHeadingDate = 'Date';
String txtHtoL = "H to L";
String txtLtoH = "L to H";
String txtTaxTypeExtraIncome = "ExtraIn";
String msgEnterUid = "Enter UID";

//keys
String keyExtraInfo = "extraInfo";
String keyRegisteredName = 'registeredName';
String keyVillage = 'village';
String keyState = 'state';
String keyDistrict = 'district';
String keyTaluka = 'taluka';
String keyUids = 'villageUids';
String keyPin = 'pin';

String keyAccessLevel = 'accessLevel';
String keyMail = 'mail';
String keyIsAdmin = 'isAdmin';
String keyAccess = "accessLevel";

String keyAdminMail = 'adminMail';
String keyHouse = 'house';
String keyHouseGiven = 'houseGiven';
String keyWater = 'water';
String keyWaterGiven = 'waterGiven';
String keyUid = "uid";
String keyMobile = "mobile";
String keyName = "name";
String keyEmail = "email";
String keyTotalBalance = 'totalBalance';
String keyTotalIn = 'totalIn';
String keyTotalOut = 'totalOut';
String keyAdminAppLanguage = 'userAppLanguage';
String keyYfTotalHouse = 'yfTotalHouse';
String keyYfCollectedHouse = 'yfCollectedHouse';
String keyYfPendingHouse = 'yfPendingHouse';

String keyYfTotalWater = 'yfTotalWater';
String keyYfCollectedWater = 'yfCollectedWater';
String keyYfPendingWater = 'yfPendingWater';

//String key = "";

String scafBeginInfoApproveRemove =
    "Please approve/Disapprove selecting status";

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

//Colors.
Color clrGreen = Color(0xFFc8e6c9); //in
Color clrTableVerticleBorder = Colors.blue; //Color(0xFFB3E5FC); //light blue.
Color clrTableHorizontalBorder = Colors.blue; //Color(0xFFB3E5FC); //in

Color clrRed = Color(0xffef9a9a); //out

Color clrAmber = Color(0xFFF7E5B4); //pending

Color clrBlue = Color(0xFF7E57E2); //report indigo;

Color clrBSplash = Colors.purple;
Color clrIconSpalsh = Colors.orange;
double iconSplashRadius = 20.0;

class yearTile extends StatefulWidget {
  Color clr = Colors.blue;
  yearTile({Key? key, this.clr = Colors.blue}) : super(key: key);

  @override
  _yearTileState createState() => _yearTileState();
}

class _yearTileState extends State<yearTile> {
  @override
  Widget build(BuildContext context) {
    gContext = context;
    return ListTile(
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: widget.clr,

        alignment: Alignment.topLeft,

        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.date_range,
          color: widget.clr,
        ),
        // Array list of items
        items: items.map(
          (String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          },
        ).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(
            () {
              dropdownValueYear = newValue!;
            },
          );
        },
      ),
    );
  }
}

String dropdownValueYear = DateTime.now().year.toString();

var items = [
  "2019",
  "2020",
  "2021",
  "2022",
  "2023",
];

var formulaYears = [
  "2019",
  "2020",
  "2021",
  "2022",
  "2023",
  "2024",
  "2025",
  "2026",
  "2027",
  "2028",
  "2029",
  "2030",
];

String access = "select";
enum accessLevel {
  select,
  Viewer,
  Collector,
  Spender,
  SuperUser,
  No,
}
var accessItems = [
  "select",
  "Viewer",
  "Collector",
  "Spender",
  "SuperUser",
  "No",
];
String sState = "Maharashtra";
String sDistrict = "Kolhapur";
String sTaluka = "Gadhinglaj";

var states = [
  "Maharashtra",
  "Karnataka",
];
var districts = [
  "Kolhapur",
];

var talukas = [
  "Gadhinglaj",
];
