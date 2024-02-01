import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_constants.dart';
import '../../custom_widget/app_button.dart';
import 'user_sign_up_viewmodel.dart';

class UserSignUpView extends StackedView<UserSignUpViewModel> {
  const UserSignUpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UserSignUpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        const Column(
                          children: [
                            Text(
                              AppConstants.signUpText,
                              style: TextStyle(
                                color: Color(0xFF3B3936),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.50,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              AppConstants.signUpBodyText,
                              style: TextStyle(
                                color: Color(0xFF78746D),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextField(
                          controller: viewModel.nameTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: AppConstants.nameText,
                            labelStyle: const TextStyle(
                              color: Color(0xFF78746D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextField(
                          controller: viewModel.emailTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: AppConstants.eMailText,
                            labelStyle: const TextStyle(
                              color: Color(0xFF78746D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextField(
                          controller: viewModel.passwordTextController,
                          obscureText: viewModel.obscureText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: AppConstants.passwordText,
                            labelStyle: const TextStyle(
                              color: Color(0xFF78746D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                viewModel.visibility();
                              },
                              icon: Transform.scale(
                                scale: 1,
                                child: Icon(viewModel.obscureText == true
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        AppButton2(
                          title: AppConstants.signUpText,
                          onClick: viewModel.signupPressed,
                         
                        ),
                        TextButton(
                          onPressed: viewModel.goToLoginPage,
                          child: const Text(
                            AppConstants.logInText,
                            style: TextStyle(
                              color: Color(0xFF78746D),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }

  @override
  UserSignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UserSignUpViewModel();
}
