import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_loading.dart';
import 'package:my_first_app/ui/custom_widget/dialog_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'update_profile_image_dialog_model.dart';

class UpdateProfileImageDialog
    extends StackedView<UpdateProfileImageDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const UpdateProfileImageDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdateProfileImageDialogModel viewModel,
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
                  title: "Upload Photo",
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: viewModel.getImage(),
                    backgroundColor: AppColor.secondaryColor,
                  ),
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        viewModel.pickImage(ImageSource.camera);
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: AppColor.primaryColor,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        viewModel.pickImage(ImageSource.gallery);
                      },
                      icon: Icon(
                        Icons.image,
                        color: AppColor.primaryColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                AppButton(
                  text: "Save",
                  onClick: viewModel.uploadImage,
                  isSelected: false,
                ),
                verticalSpaceMedium,
              ],
            ),
    );
  }

  @override
  UpdateProfileImageDialogModel viewModelBuilder(BuildContext context) =>
      UpdateProfileImageDialogModel();

  @override
  void onViewModelReady(UpdateProfileImageDialogModel viewModel) {
    viewModel.init();
  }
}
