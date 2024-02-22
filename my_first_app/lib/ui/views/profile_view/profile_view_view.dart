import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/app/app.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:my_first_app/ui/custom_widget/app2_button.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/app_textbutton.dart';
import 'package:my_first_app/ui/custom_widget/edit_profile_card.dart';
import 'package:stacked/stacked.dart';

import 'profile_view_viewmodel.dart';

class ProfileViewView extends StackedView<ProfileViewViewModel> {
  const ProfileViewView({Key? key}) : super(key: key);

ImageProvider getImage() {
  if(imageFile == null) {
      return AssetImage(AppPng.AppAvatarPath);
  }
  else {
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
        body: SingleChildScrollView(
      child: Column(
        children: [
          AppBar(),
          Row(
            children: [
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
    backgroundImage: getImage(),
    backgroundColor: AppColor.secondaryColor,
  ),
),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextButton(title: "Change Picture", onClick:viewModel.chooseImageFromGallery,),
                  AppTextButton(title: "View Picture", onClick: () {}),
                ],
              )
            ],
          ),
          EditProfileCard(
            text: 'Armando',
            onClick: () {},
            label: 'Name',
          ),
          EditProfileCard(
            text: 'armando.jumawid@gmail.com',
            onClick: () {},
            label: 'Email',
          ),
          EditProfileCard(
            text: 'Change Password***',
            onClick: () {},
            label: 'Password',
          ),
          verticalSpaceMedium,
          App2Button(text: 'Log out', onClick: () {})
        ],
      ),
    ));
  }

  @override
  ProfileViewViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewViewModel();
}
