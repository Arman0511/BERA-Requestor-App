import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/app/app.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:my_first_app/ui/custom_widget/app2_button.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_icon_button.dart';
import 'package:my_first_app/ui/custom_widget/app_loading.dart';
import 'package:my_first_app/ui/custom_widget/app_textbutton.dart';
import 'package:my_first_app/ui/custom_widget/edit_profile_card.dart';
import 'package:stacked/stacked.dart';

import 'profile_view_viewmodel.dart';

class ProfileViewView extends StackedView<ProfileViewViewModel> {
  const ProfileViewView({Key? key}) : super(key: key);

  ImageProvider getImage() {
    if (imageFile == null) {
      return AssetImage(AppPng.AppAvatarPath);
    } else {
      return FileImage(File(imageFile!.path));
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ProfileViewViewModel viewModel,
    Widget? child,
  ) {
    return AppBody(
        body: viewModel.isBusy
            ? AppLoading(
                label: "Loading Profile",
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    AppBar(),
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: viewModel.showUploadPictureDialog,
                          child: AbsorbPointer(
                            child: Container(
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
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 160,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      viewModel.user.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  AppIconButton(
                                    onClick: viewModel.showUpdateNameDialog,
                                    icon:
                                        Icons.drive_file_rename_outline_rounded,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ), Container(
                              width: 160,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      viewModel.user.phonenumber,
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                 AppIconButton(
                                    onClick: viewModel.showUpdateNumberDialog,
                                    icon:
                                        Icons.drive_file_rename_outline_rounded,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.primaryColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.secondaryColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email: ${viewModel.user.email}",
                            style: TextStyle(fontSize: 16),
                          ),
                          AppIconButton(
                              onClick: viewModel.showUpdateEmailDialog,
                              icon: Icons.edit_rounded)
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: viewModel.showUpdatePasswordDialog,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.grey,
                      ),
                      child: const Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    verticalSpaceMedium,
                    AppButton(
                      text: 'Log out',
                      onClick: viewModel.logOut,
                      isSelected: false,
                    ),
                  ],
                ),
              ));
  }

  @override
  ProfileViewViewModel viewModelBuilder(BuildContext context) =>
      ProfileViewViewModel();

  @override
  void onViewModelReady(ProfileViewViewModel viewModel) {
    viewModel.init();
  }
}
