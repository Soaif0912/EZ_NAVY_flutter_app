

import 'dart:convert';

import 'package:ez_navy_app/model/user_model/user_model.dart';
import 'package:ez_navy_app/services/shared_perps/shared_perps.dart';

class GlobalDataManager {
  
  static final GlobalDataManager _instance = GlobalDataManager._internal();
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  String? _jwtJsonToken;
  UserModel? _userProfile;
  String? _userId;

  factory GlobalDataManager() {
    return _instance;
  }

  GlobalDataManager._internal() {
    initialize();
  }

  Future<void> initialize() async {
    try {
      // await _loadJwtJsonToken();
      // await _loadUserProfile();
      await _loadUserId();
    } catch (e) {
      // Handle initialization error (e.g., log it)
      print('Initialization error: $e');
    }
  }

  Future<void> _loadUserId() async{
    _userId = await _prefsHelper.getuserId();
  }

  String? getUserId() {
    return _userId;
  }

  Future<void> setuserId(String userId) async{
    await _prefsHelper.setUserId(userId);
    _userId = userId;
  }

  Future<void> removeUserId()async{
    _userId = null;
    await _prefsHelper.removeUserId();
  }

  Future<void> _loadJwtJsonToken() async {
    _jwtJsonToken = await _prefsHelper.getJwtJsonToken();
    print('Token: $_jwtJsonToken ');
  }

  Future<void> _loadUserProfile() async {
    _userProfile = await _prefsHelper.getUserProfile();
  }

  Future<void> setJwtJsonToken(String token) async {
    _jwtJsonToken = token;
    await _prefsHelper.setJwtJsonToken(token);
  }

  String? getJwtJsonToken() {
    return _jwtJsonToken;
  }

  Future<void> removeJwtToken() async {
    _jwtJsonToken = null;
    await _prefsHelper.removeJwtJsonToken();
  }

// User Profile Data functions
  Future<void> setUserProfile(UserModel profile) async {
    _userProfile = profile;
    await _prefsHelper.setUserProfile(profile: jsonEncode(profile.toJson()));
  }

  UserModel? getUserProfile() {
    return _userProfile;
  }

  // Remove all information
  Future<void> clearAll() async {
    await removeJwtToken();
    await _prefsHelper.removeUserProfile();
    _userProfile = null;
  }
}