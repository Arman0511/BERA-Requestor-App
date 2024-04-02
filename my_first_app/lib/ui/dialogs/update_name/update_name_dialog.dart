import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_loading.dart';
import 'package:my_first_app/ui/custom_widget/app_textfield.dart';
import 'package:my_first_app/ui/custom_widget/dialog_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


import 'update_name_dialog_model.dart';

class UpdateNameDialog extends StackedView<UpdateNameDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const UpdateNameDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdateNameDialogModel viewModel,
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
                  title: "Change Name",
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AppTextField(
                    controller: viewModel.nameTextController,
                    label: "Enter your new name",
                    icon: const Icon(
                      Icons.person,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                AppButton(text: "Save", onClick: viewModel.updateName, isSelected: false,),
                verticalSpaceMedium,
              ],
            ),
    );
  }

  @override
  UpdateNameDialogModel viewModelBuilder(BuildContext context) =>
      UpdateNameDialogModel();

  @override
  void onViewModelReady(UpdateNameDialogModel viewModel) {
    viewModel.init();
  }
}
