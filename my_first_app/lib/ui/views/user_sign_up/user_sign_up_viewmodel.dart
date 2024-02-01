import 'package:flutter/cupertino.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/authentication_service.dart';
import '../../common/app_constants.dart';
import '../../common/app_exception_constants.dart';

class UserSignUpViewModel extends BaseViewModel {
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final _authenticationService = locator<AuthenticationService>();
  final _navigatorService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool obscureText = true;

  void visibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> signupPressed() async {
    final verifyForm = validateForm();
    if (verifyForm != null) {
      _snackBarService.showSnackbar(message: verifyForm);
    } else {
      setBusy(true);
      final response = await _authenticationService.signup(
        nameTextController.text,
        emailTextController.text,
        passwordTextController.text,
      );

      setBusy(false);

      response.fold((l) {
        _snackBarService.showSnackbar(message: l.message);
      }, (r) {
        _snackBarService.showSnackbar(
            message: AppConstants.accountCreatedSuccessfullyText,
            duration: const Duration(seconds: 2));
        _navigatorService.replaceWithLoginView();
      });
    }
  }

  void goToLoginPage() {
    _navigatorService.replaceWithLoginView();
  }

  String? validateForm() {
    if (nameTextController.text.isEmpty &&
        emailTextController.text.isEmpty &&
        passwordTextController.text.isEmpty) {
      return AppExceptionConstants.emptyEmailNamePass;
    } else if (nameTextController.text.isEmpty &&
        emailTextController.text.isEmpty) {
      return AppExceptionConstants.emptyEmailName;
    } else if (nameTextController.text.isEmpty &&
        passwordTextController.text.isEmpty) {
      return AppExceptionConstants.emptyNamePass;
    } else if (emailTextController.text.isEmpty &&
        passwordTextController.text.isEmpty) {
      return AppExceptionConstants.emptyEmailPass;
    } else if (nameTextController.text.isEmpty) {
      return AppExceptionConstants.emptyName;
    } else if (emailTextController.text.isEmpty) {
      return AppExceptionConstants.emptyEmail;
    } else if (passwordTextController.text.isEmpty) {
      return AppExceptionConstants.emptyPassword;
    } else {
      return null;
    }
  }
}
