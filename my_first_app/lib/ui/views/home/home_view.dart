import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/global/global_var.dart';
import 'package:my_first_app/ui/custom_widget/app2_button.dart';
import 'package:my_first_app/ui/custom_widget/app_body.dart';
import 'package:my_first_app/ui/custom_widget/user_profile.dart';
import 'package:stacked/stacked.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_constants.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return AppBody(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                    name: viewModel.user.name,
                    imagePath: viewModel.user.image,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: PageView(
              controller: viewModel.pageController,
              onPageChanged: viewModel.onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        width: 300,
                        height: 600,
                        child: viewModel.isBusy
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: <Widget>[
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation:
                                        4.0, // Adjust the elevation for a shadow effect
                                    color: Colors
                                        .red, // You can change the color to match your design
                                    child: InkWell(
                                      onTap: viewModel.showDescribeDialog,
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
                                    child: App2Button(
                                      text: AppConstants.medText,
                                      onClick: viewModel.medPressed,
                                      isSelected: viewModel.btnMedSelected,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    child: App2Button(
                                      text: AppConstants.fireText,
                                      onClick: viewModel.firePressed,
                                      isSelected: viewModel.btnFireSelected,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    child: App2Button(
                                      text: AppConstants.policeText,
                                      onClick: viewModel.policePressed,
                                      isSelected: viewModel.btnPoliceSelected,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 400, // Set a specific height for the GoogleMap
                        child: GoogleMap(
                          markers: viewModel.markers.values.toSet(),
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: googlePlexInitialPosition,
                          onMapCreated: viewModel.mapCreated,
                        ),
                      ),
                    ],
                  ),
                ),
                // New page added below
              SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Bilar Search and Rescue Unit: 09380948412',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 60, // Increase the height of the button here
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                const phoneNumber = '09380948412';
                                final url = 'tel:$phoneNumber';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              icon: Icon(Icons.phone),
                              label: Text('Call'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            )

                        ),
                        Text(
                          'Bilar Search and Rescue Unit: 09985986406',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 60, // Increase the height of the button here
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              const phoneNumber = '09985986406';
                              final url = 'tel:$phoneNumber';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(Icons.phone),
                            label: Text('Call'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),

                        ),
                         SizedBox(height: 25),
                        Text(
                          'Bureau of Fire Protection: 09171358528',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 60, // Increase the height of the button here
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              const phoneNumber = '09171358528';
                              final url = 'tel:$phoneNumber';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(Icons.phone),
                            label: Text('Call'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(height: 25),
                        Text(
                          'PNP Bilar: 09985986406',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 60, // Increase the height of the button here
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              const phoneNumber = '09985986406';
                              final url = 'tel:$phoneNumber';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(Icons.phone),
                            label: Text('Call'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),Text(
                          'RHU Bilar: 0968635215',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 60, // Increase the height of the button here
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              const phoneNumber = '0968635215';
                              final url = 'tel:$phoneNumber';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(Icons.phone),
                            label: Text('Call'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
              shadowColor: const Color(0xFF948D8D),
              selectedIndex: viewModel.currentPageIndex,
              onDestinationSelected: viewModel.onDestinationSelected,
              destinations: [
                const NavigationDestination(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 54, 244, 216),
                    size: 40,
                  ),
                  label: AppConstants.HomeText,
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.map,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.map,
                    color: Color.fromARGB(255, 54, 244, 216),
                    size: 40,
                  ),
                  label: AppConstants.mapsText,
                ),
                // You can add a new destination icon for the new page if needed
                const NavigationDestination(
                  icon: Icon(
                    Icons.contact_phone,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.contact_phone,
                    color: Color.fromARGB(255, 54, 244, 216),
                    size: 40,
                  ),
                  label: 'Contact', // Label for the new page
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel(context);

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.init();
  }
}
