import 'package:flutter/material.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:my_first_app/ui/custom_widget/app2_button.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/app_image.dart';
import 'package:my_first_app/ui/custom_widget/app_password_textfield.dart';
import 'package:my_first_app/ui/custom_widget/app_textfield.dart';
import 'package:my_first_app/ui/custom_widget/app_title_text.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_constants.dart';
import 'user_sign_up_viewmodel.dart';

class UserSignUpView extends StackedView<UserSignUpViewModel> {
  const UserSignUpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UserSignUpViewModel viewModel,
    Widget? child,
  ) {
    return AppBody(
        body: SingleChildScrollView(
      child: viewModel.isBusy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                AppBar(),
                AppTitleText(text: AppConstants.createAccText),
                AppImage(path: AppPng.AppAuthCreatePath),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 25,
                ),
                AppTextField(
                  controller: viewModel.nameTextController,
                  label: AppConstants.nameText,
                  icon: Icon(
                    Icons.person,
                    color: const Color.fromARGB(255, 32, 211, 217),
                  ),
                ),
                AppTextField(
                  controller: viewModel.phoneNumTextController,
                  label: AppConstants.phoneNumText,
                  icon: Icon(
                    Icons.contact_phone,
                    color: const Color.fromARGB(255, 32, 211, 217),
                  ),
                ),
                AppTextField(
                    controller: viewModel.emailTextController,
                    label: AppConstants.emailText),
                AppPasswordTextField(
                  controller: viewModel.passwordTextController,
                  label: AppConstants.passwordText,
                ),
                App2Button(
                  text: AppConstants.createText,
                  onClick: viewModel.signupPressed,
                  isSelected: false,
                )
              ],
            ),
    ));
  }

  @override
  UserSignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UserSignUpViewModel();
}
