import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_loading.dart';
import 'package:my_first_app/ui/custom_widget/app_password_textfield.dart';
import 'package:my_first_app/ui/custom_widget/dialog_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'update_password_dialog_model.dart';

class UpdatePasswordDialog extends StackedView<UpdatePasswordDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const UpdatePasswordDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdatePasswordDialogModel viewModel,
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
                  title: "Change Password",
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      AppPasswordTextField(
                        controller: viewModel.currentPasswordController,
                        label: "Current Password",
                      ),
                      AppPasswordTextField(
                        controller: viewModel.newPasswordController,
                        label: "New Password",
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                AppButton(
                  text: "Save",
                  onClick: viewModel.changePassword,
                  isSelected: false,
                ),
                verticalSpaceMedium,
              ],
            ),
    );
  }

  @override
  UpdatePasswordDialogModel viewModelBuilder(BuildContext context) =>
      UpdatePasswordDialogModel();
}
