import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService authSvc = AuthService();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    _user = await authSvc.getUserData();
    notifyListeners();
  }
}
