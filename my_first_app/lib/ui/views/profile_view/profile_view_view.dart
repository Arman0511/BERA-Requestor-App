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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: getImage(),
              backgroundColor: AppColor.secondaryColor,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Change Picture"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              viewModel.chooseImageFromGallery();
                            },
                            child: Text("From Gallery"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              //viewModel.chooseImageFromCamera();
                            },
                            child: Text("From Camera"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text("Change Picture"),
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {},
              child: Text("View Picture"),
            ),
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            App2Button(text: 'Log out', onClick: () {}),
          ],
        ),
      ),
    );
  }

  @override
  ProfileViewViewModel viewModelBuilder(BuildContext context) =>
      ProfileViewViewModel();
}
