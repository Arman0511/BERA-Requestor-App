import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/app_constants.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/app_button.dart';
import 'package:my_first_app/ui/custom_widget/user_profile.dart';
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
    return AppBody(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                primaryShadow(),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: viewModel.goToProfileView,
                  child: UserProfile(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: PageView(
              controller: viewModel.pageController,
              physics: const AlwaysScrollableScrollPhysics(),
              onPageChanged: viewModel.onPageChanged,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        width: 300,
                        height: 473,
                        child: Column(
                          children: <Widget>[
                            Material(
                              shape: const CircleBorder(),
                              elevation:
                                  4.0, // Adjust the elevation for a shadow effect
                              color: Colors
                                  .red, // You can change the color to match your design
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // LessonsView(),
                // PlayView(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.white,
              labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE35629),
                    );
                  } else {
                    return const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    );
                  }
                },
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.white,
              height: 70,
              shadowColor: Color(0xFF948D8D),
              selectedIndex: viewModel.currentPageIndex,
              onDestinationSelected: viewModel.onDestinationSelected,
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: Colors.red,
                    size: 40,
                  ),
                  label: AppConstants.HomeText,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.photo,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.photo,
                    color: Colors.red,
                    size: 40,
                  ),
                  label: AppConstants.sendText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  ResponderHomepageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ResponderHomepageViewModel();
}
