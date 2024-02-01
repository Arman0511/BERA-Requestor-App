import 'package:flutter/material.dart';
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
                return ElevatedButton(
                  onPressed: () {
                    // Handle the specific incident based on the index.
                  },
                  child: Text('Incident ${index + 1}'),
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
