import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAME";
  static String userEmailKey = "USEREMAILKEY";
  static String userPhoneNumber = "USERPHONENUMBER";
  static String userAbout = "USERABOUT";
  static String userProfilePicKey = "USERPROFILEKEY";

  //save data
  Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName);
  }

  Future<bool> saveUserPhoneNumber(String getUserPhoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhoneNumber, getUserPhoneNumber);
  }

  Future<bool> saveUserAbout(String getUserAbout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAbout, getUserAbout);
  }

  Future<bool> saveUserProfileUrl(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicKey, getUserProfile);
  }

  //get data

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPhoneNumber);
  }

  Future<String?> getUserAbout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAbout);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }

  //update data

  Future<bool> updateUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userNameKey);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(userNameKey, userName);
  }

  Future<bool> updateUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userEmailKey);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> updateUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userIdKey);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(userIdKey, getUserId);
  }

  Future<bool> updateDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(displayNameKey);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(displayNameKey, getDisplayName);
  }

  Future<bool> updateUserPhoneNumber(String getUserPhoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userPhoneNumber);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(userPhoneNumber, getUserPhoneNumber);
  }

  Future<bool> updateUserAbout(String getUserAbout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userAbout);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(userAbout, getUserAbout);
  }

  Future<bool> updateUserProfile(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userProfilePicKey);
    SharedPreferences newPrefs = await SharedPreferences.getInstance();
    return newPrefs.setString(userProfilePicKey, getUserProfile);
  }

  //remove account

  removeAccount() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    prefs1.remove(userProfilePicKey);
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    prefs2.remove(userAbout);
    SharedPreferences prefs3 = await SharedPreferences.getInstance();
    prefs3.remove(userPhoneNumber);
    SharedPreferences prefs4 = await SharedPreferences.getInstance();
    prefs4.remove(userNameKey);
    SharedPreferences prefs5 = await SharedPreferences.getInstance();
    prefs5.remove(userIdKey);
    SharedPreferences prefs6 = await SharedPreferences.getInstance();
    prefs6.remove(userEmailKey);
    SharedPreferences prefs7 = await SharedPreferences.getInstance();
    prefs7.remove(displayNameKey);
  }

  clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
