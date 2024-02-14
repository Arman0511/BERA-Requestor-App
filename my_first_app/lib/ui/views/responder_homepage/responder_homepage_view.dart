import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/app_constants.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:stacked/stacked.dart';

import 'responder_homepage_viewmodel.dart';

class ResponderHomepageView extends StackedView<ResponderHomepageViewModel> {
  const ResponderHomepageView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ResponderHomepageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Details'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5, // Adjust as needed
              itemBuilder: (context, index) {
                return AppButton(
                  onClick: viewModel.displayNotifications,
                  title: AppConstants.cartCourseText,
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: const Text(
                      AppConstants.helpText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  ResponderHomepageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ResponderHomepageViewModel();
}
