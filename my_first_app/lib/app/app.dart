import 'package:my_first_app/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:my_first_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:my_first_app/ui/views/home/home_view.dart';
import 'package:my_first_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_first_app/ui/views/login/login_view.dart';
import '../services/authentication_service.dart';
import '../services/shared_pref_service.dart';
import 'package:my_first_app/ui/views/user_sign_up/user_sign_up_view.dart';
import 'package:my_first_app/ui/views/message_view/message_view_view.dart';
import 'package:my_first_app/ui/views/forgot_password_view/forgot_password_view_view.dart';
import 'package:my_first_app/ui/views/profile_view/profile_view_view.dart';

import 'package:my_first_app/ui/dialogs/update_profile_image/update_profile_image_dialog.dart';
import 'package:my_first_app/ui/dialogs/update_name/update_name_dialog.dart';
import 'package:my_first_app/ui/dialogs/update_email/update_email_dialog.dart';
import 'package:my_first_app/ui/dialogs/update_password/update_password_dialog.dart';
import 'package:my_first_app/ui/bottom_sheets/input_validation/input_validation_sheet.dart';
import 'package:my_first_app/services/user_service.dart';
import 'package:my_first_app/services/internet_service.dart';
import 'package:my_first_app/services/image_service.dart';
import 'package:my_first_app/ui/views/no_account_page/no_account_page_view.dart';
import 'package:my_first_app/ui/dialogs/input_number/input_number_dialog.dart';
import 'package:my_first_app/ui/dialogs/update_number/update_number_dialog.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: UserSignUpView),
    MaterialRoute(page: MessageViewView),
    MaterialRoute(page: ForgotPasswordViewView),
    MaterialRoute(page: ProfileViewView),

    MaterialRoute(page: NoAccountPageView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: SharedPreferenceService),

    LazySingleton(classType: UserService),
    LazySingleton(classType: InternetService),
    LazySingleton(classType: ImageService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: InputValidationSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: UpdateProfileImageDialog),
    StackedDialog(classType: UpdateNameDialog),
    StackedDialog(classType: UpdateEmailDialog),
    StackedDialog(classType: UpdatePasswordDialog),
    StackedDialog(classType: InputNumberDialog),
    StackedDialog(classType: UpdateNumberDialog),
// @stacked-dialog
  ],
)
class App {}
