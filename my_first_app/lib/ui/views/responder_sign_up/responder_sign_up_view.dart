import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'responder_sign_up_viewmodel.dart';

class ResponderSignUpView extends StackedView<ResponderSignUpViewModel> {
  const ResponderSignUpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ResponderSignUpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responder Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: viewModel.nameTextController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: viewModel.emailTextController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: viewModel.passwordTextController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Home Address'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Work Address'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Geo-Coordinates'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Skills and Training'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.signupPressed;
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ResponderSignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ResponderSignUpViewModel();
}
