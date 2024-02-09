import 'package:flutter/material.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:stacked/stacked.dart';
import 'package:my_first_app/ui/common/app_colors.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../common/app_constants.dart';
import '../../custom_widget/app_button.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              shape: const CircleBorder(),
              elevation: 4.0, // Adjust the elevation for a shadow effect
              color:
                  Colors.red, // You can change the color to match your design
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
              child: AppButton2(
                title: AppConstants.medText,
                onClick: viewModel.medPressed,
                isSelected: viewModel.btnMedSelected,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: AppButton2(
                title: AppConstants.fireText,
                onClick: viewModel.firePressed,
                isSelected: viewModel.btnFireSelected,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: AppButton2(
                title: AppConstants.policeText,
                onClick: viewModel.policePressed,
                isSelected: viewModel.btnPoliceSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
