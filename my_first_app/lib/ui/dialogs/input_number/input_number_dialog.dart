import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/app_colors.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/App_color.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_loading.dart';
import 'package:my_first_app/ui/custom_widget/app_textfield.dart';
import 'package:my_first_app/ui/custom_widget/dialog_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'input_number_dialog_model.dart';

const double _graphicSize = 60;

class InputNumberDialog extends StackedView<InputNumberDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InputNumberDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InputNumberDialogModel viewModel,
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
                  title: "Phone Number",
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AppTextField(
                    controller: viewModel.phonNumTextController,
                    label: "Enter your phone number",
                    icon: const Icon(
                      Icons.person,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                AppButton(
                  text: "Submit",
                  onClick: viewModel.saveDocument,
                  isSelected: false,
                ),
                verticalSpaceMedium,
              ],
            ),
    );
  }

  @override
  InputNumberDialogModel viewModelBuilder(BuildContext context) =>
      InputNumberDialogModel();
}
