import 'package:my_first_app/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:my_first_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:my_first_app/ui/views/home/home_view.dart';
import 'package:my_first_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_first_app/ui/views/login/login_view.dart';
import 'package:my_first_app/ui/views/responder_sign_up/responder_sign_up_view.dart';
import 'package:my_first_app/ui/views/responder_homepage/responder_homepage_view.dart';

import '../services/authentication_service.dart';
import '../services/authentication_service_impl.dart';
import '../services/authentication_service_mock.dart';
import '../services/shared_pref_service.dart';
import 'package:my_first_app/ui/views/user_sign_up/user_sign_up_view.dart';
import 'package:my_first_app/ui/views/message_view/message_view_view.dart';
import 'package:my_first_app/ui/views/forgot_password_view/forgot_password_view_view.dart';
import 'package:my_first_app/ui/views/profile_view/profile_view_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: ResponderSignUpView),
    MaterialRoute(page: ResponderHomepageView),
    MaterialRoute(page: UserSignUpView),
    MaterialRoute(page: MessageViewView),
    MaterialRoute(page: ForgotPasswordViewView),
    MaterialRoute(page: ProfileViewView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),

    LazySingleton(
        environments: {Environment.dev},
        classType: AuthenticationServiceMock,
        asType: AuthenticationService),
    LazySingleton(
        environments: {Environment.prod},
        classType: AuthenticationServiceImpl,
        asType: AuthenticationService),

    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
// @stacked-dialog
  ],
)
class App {}
