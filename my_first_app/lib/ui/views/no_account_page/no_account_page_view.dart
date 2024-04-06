import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/app_constants.dart';
import 'package:my_first_app/ui/custom_widget/app2_button.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:stacked/stacked.dart';

import 'no_account_page_viewmodel.dart';

class NoAccountPageView extends StackedView<NoAccountPageViewModel> {
  const NoAccountPageView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NoAccountPageViewModel viewModel,
    Widget? child,
  ) {
    return AppBody(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                AppButton(
                  text: AppConstants.createAccText,
                  onClick: viewModel.goToSignUp,
                  isSelected: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  text: AppConstants.GoTologInText,
                  onClick: viewModel.goToLogin,
                  isSelected: false,
                ),
                const SizedBox(
                  height: 40,
                ),
                Material(
                  shape: const CircleBorder(),
                  elevation: 4.0,
                  color: Colors.red,
                  child: InkWell(
                    onTap: viewModel.helpPressed,
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const Text(
                        AppConstants.helpText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: App2Button(
                    text: AppConstants.medText,
                    onClick: viewModel.medPressed,
                    isSelected: viewModel.btnMedSelected,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: App2Button(
                    text: AppConstants.fireText,
                    onClick: viewModel.firePressed,
                    isSelected: viewModel.btnFireSelected,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: App2Button(
                    text: AppConstants.policeText,
                    onClick: viewModel.policePressed,
                    isSelected: viewModel.btnPoliceSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  NoAccountPageViewModel viewModelBuilder(BuildContext context) =>
      NoAccountPageViewModel();

  @override
  void onViewModelReady(NoAccountPageViewModel viewModel) {
    viewModel.init();
  }
}
