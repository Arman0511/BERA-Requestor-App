import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'profile_view_viewmodel.dart';

class ProfileViewView extends StackedView<ProfileViewViewModel> {
  const ProfileViewView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  ProfileViewViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewViewModel();
}
