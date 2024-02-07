import 'package:flutter/material.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:my_first_app/ui/custom_widget/app2_button.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/app_image.dart';
import 'package:my_first_app/ui/custom_widget/app_password_textfield.dart';
import 'package:my_first_app/ui/custom_widget/app_textbutton.dart';
import 'package:my_first_app/ui/custom_widget/app_textfield.dart';
import 'package:my_first_app/ui/custom_widget/app_title_text.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_constants.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return AppBody(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppTitleText(text: AppConstants.welcomeText),
            const SizedBox(
              height: 10,
            ),
            const AppImage(path: AppPng.AppAuthLoginPath),
            const SizedBox(
              height: 25,
            ),
            AppTextField(
              controller: viewModel.emailController,
              label: AppConstants.emailText,
            ),
            AppPasswordTextField(
              controller: viewModel.passwordController,
              label: AppConstants.passwordText,
            ),
            const SizedBox(
              height: 10,
            ),
            App2Button(
              text: AppConstants.loginText,
              onClick: viewModel.logIn,
            ),
            const SizedBox(
              height: 20,
            ),
            AppTextButton(
              title: AppConstants.createNewAccText,
              onClick: viewModel.goToSignUp,
            ),
            AppTextButton(
              title: AppConstants.forgotPassText,
              onClick: viewModel.goToForgotPassword,
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
