import 'package:flutter/cupertino.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/methods/common_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/authentication_service.dart';
import '../../common/app_constants.dart';
import '../../common/app_exception_constants.dart';

class UserSignUpViewModel extends BaseViewModel {
  final phoneNumTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final _authenticationService = locator<AuthenticationService>();
  final _navigatorService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();
  CommonMethods cmethods = CommonMethods();

  bool obscureText = true;

  void visibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> signupPressed() async {
    // Retrieve the current BuildContext
    BuildContext? context =
        locator<NavigationService>().navigatorKey?.currentContext!;

    // Check connectivity
    await cmethods.checkConnectivity(context!);

    final verifyForm = validateForm();
    if (verifyForm != null) {
      _snackBarService.showSnackbar(message: verifyForm);
    } else {
      try {
        // Show loading indicator
        setBusy(true);

        final response = await _authenticationService.signup(
          nameTextController.text,
          emailTextController.text,
          passwordTextController.text,
          phoneNumTextController.text,
        );

        // Hide loading indicator
        setBusy(false);

        response.fold(
          (l) {
            _snackBarService.showSnackbar(message: l.message);
          },
          (r) {
            _snackBarService.showSnackbar(
                message: AppConstants.accountCreatedText,
                duration: const Duration(seconds: 2));
            _navigatorService.replaceWithLoginView();
          },
        );
      } catch (e) {
        // Hide loading indicator in case of error
        setBusy(false);
        // Handle error, you might want to show an error message or log it
        print("Error during signup: $e");
        // Optionally show a snackbar or dialog to inform the user about the error
        _snackBarService.showSnackbar(
            message:
                "An error occurred during signup. Please try again later.");
      }
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
