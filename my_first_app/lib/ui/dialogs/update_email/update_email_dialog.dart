import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_loading.dart';
import 'package:my_first_app/ui/custom_widget/app_password_textfield.dart';
import 'package:my_first_app/ui/custom_widget/app_textfield.dart';
import 'package:my_first_app/ui/custom_widget/dialog_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'update_email_dialog_model.dart';

class UpdateEmailDialog extends StackedView<UpdateEmailDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const UpdateEmailDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdateEmailDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: viewModel.isBusy
          ? AppLoading()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogBar(
                  onClick: () => completer(DialogResponse(confirmed: true)),
                  title: "Change Email",
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      AppTextField(
                          controller: viewModel.newEmailTextController,
                          label: "New Email"),
                      AppPasswordTextField(
                          controller: viewModel.passwordTextController,
                          label: "Confirm Password"),
                    ],
                  ),
                ),
                AppButton(
                  text: "Save",
                  onClick: viewModel.changeEmail,
                  isSelected: false,
                ),
                verticalSpaceMedium,
              ],
            ),
    );
  }

  @override
  UpdateEmailDialogModel viewModelBuilder(BuildContext context) =>
      UpdateEmailDialogModel();

  @override
  void onViewModelReady(UpdateEmailDialogModel viewModel) {
    viewModel.init();
  }
}
