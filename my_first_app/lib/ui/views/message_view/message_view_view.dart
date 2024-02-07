import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'message_view_viewmodel.dart';

class MessageViewView extends StackedView<MessageViewViewModel> {
  const MessageViewView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MessageViewViewModel viewModel,
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
  MessageViewViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MessageViewViewModel();
}
