import 'package:my_first_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class SignUpSelectionViewModel extends BaseViewModel {
final _navigationService = locator<NavigationService>();

  void responder() {
    _navigationService.navigateToResponderSignUpView();
  }
  void user() {
    _navigationService.navigateToUserSignUpView();
  }
}
