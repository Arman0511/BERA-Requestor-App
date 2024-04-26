import 'dart:async';
import 'dart:convert';

import 'package:my_first_app/model/no_acc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class SharedPreferenceService {
  late StreamController<User?> _userStreamController;

  String userId = "";

  SharedPreferenceService() {
    _userStreamController = StreamController<User?>.broadcast();
  }
  Stream<User?> get userStream => _userStreamController.stream;

  Future<void> deleteCurrentUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove("USER_KEY");
  }

  Future<void> setIsPreviousOnline(bool status) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool("USER_STATUS", status);
  }

  Future<bool?> getIsPreviousOnline() async {
    final sharedPref = await SharedPreferences.getInstance();
    final status = sharedPref.getBool("USER_STATUS");
    return status;
  }

  Future<String?> getUserId() async {
    final user = await getCurrentUser();
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    final user = sharedPref.getString("USER_KEY");
    if (user == null) return null;
    return User.fromJson(json.decode(user));
  }

  Future<void> saveUser(User user) async {
    if (_userStreamController.isClosed) {
      _userStreamController = StreamController<User?>.broadcast();
    }
    _userStreamController.add(user);
    final sharedPref = await SharedPreferences.getInstance();
    userId = user.uid;
    await sharedPref.setString("USER_KEY", jsonEncode(user.toJson()));
  }

  Future<void> saveNoAcc(NoAcc user) async {
    final sharedPref = await SharedPreferences.getInstance();
    userId = user.uid;
    await sharedPref.setString("USER_KEY", jsonEncode(user.toJson()));
  }

  Future<NoAcc?> getCurrentNoAcc() async {
    final sharedPref = await SharedPreferences.getInstance();
    final user = sharedPref.getString("USER_KEY");
    if (user == null) return null;
    return NoAcc.fromJson(json.decode(user));
  }

  void dispose() {
    _userStreamController.close();
  }
}
