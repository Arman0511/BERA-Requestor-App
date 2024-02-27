import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/global/global_var.dart';
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
                  child: UserProfile(
                    name: '',
                  ),
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
                      Container(
                        height: 400, // Set a specific height for the GoogleMap
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: googlePlexInitialPosition,
                          onMapCreated: viewModel.mapCreated,
                        ),
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
                      color: Color.fromARGB(255, 41, 63, 227),
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
                    color: const Color.fromARGB(255, 54, 225, 244),
                    size: 40,
                  ),
                  label: AppConstants.HomeText,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.map,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.map,
                    color: const Color.fromARGB(255, 54, 225, 244),
                    size: 40,
                  ),
                  label: AppConstants.mapsText,
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
