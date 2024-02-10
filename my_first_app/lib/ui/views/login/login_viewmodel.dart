import 'package:flutter/material.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  void logIn() {
    _navigationService.replaceWithHomeView();
  }

  void goToSignUp() {
    _navigationService.navigateToUserSignUpView();
  }

  void goToForgotPassword() {
    _navigationService.navigateToForgotPasswordViewView();
  }
}
