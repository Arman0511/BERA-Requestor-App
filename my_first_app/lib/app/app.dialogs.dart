// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/input_number/input_number_dialog.dart';
import '../ui/dialogs/update_email/update_email_dialog.dart';
import '../ui/dialogs/update_name/update_name_dialog.dart';
import '../ui/dialogs/update_number/update_number_dialog.dart';
import '../ui/dialogs/update_password/update_password_dialog.dart';
import '../ui/dialogs/update_profile_image/update_profile_image_dialog.dart';

enum DialogType {
  infoAlert,
  updateProfileImage,
  updateName,
  updateEmail,
  updatePassword,
  inputNumber,
  updateNumber,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.updateProfileImage: (context, request, completer) =>
        UpdateProfileImageDialog(request: request, completer: completer),
    DialogType.updateName: (context, request, completer) =>
        UpdateNameDialog(request: request, completer: completer),
    DialogType.updateEmail: (context, request, completer) =>
        UpdateEmailDialog(request: request, completer: completer),
    DialogType.updatePassword: (context, request, completer) =>
        UpdatePasswordDialog(request: request, completer: completer),
    DialogType.inputNumber: (context, request, completer) =>
        InputNumberDialog(request: request, completer: completer),
    DialogType.updateNumber: (context, request, completer) =>
        UpdateNumberDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
