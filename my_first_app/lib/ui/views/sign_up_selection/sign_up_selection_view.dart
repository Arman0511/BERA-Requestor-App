import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_constants.dart';
import 'sign_up_selection_viewmodel.dart';

class SignUpSelectionView extends StackedView<SignUpSelectionViewModel> {
  const SignUpSelectionView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignUpSelectionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Selection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
               onPressed: viewModel.responder,
                          child: const Text(
                            AppConstants.responderText,
                            style: TextStyle(
                              color: Color(0xFF78746D),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
               onPressed: viewModel.user,
                          child: const Text(
                            AppConstants.userText,
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
    );
  }

  @override
  SignUpSelectionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignUpSelectionViewModel();
}
