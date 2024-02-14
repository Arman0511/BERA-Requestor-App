import 'package:flutter/material.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:stacked_services/stacked_services.dart';

class ResponderHomepageViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);
  final _navigationService = locator<NavigationService>();
  int currentPageIndex = 0;

  void goToProfileView() {
    _navigationService.navigateToProfileViewView();
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    rebuildUi();
  }

  void onDestinationSelected(int index) {
    currentPageIndex = index;
    changePage(currentPageIndex);
  }

  void changePage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
