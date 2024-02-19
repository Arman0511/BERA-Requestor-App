import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/ui/common/app_constants.dart';
import 'package:stacked_services/stacked_services.dart';

class CommonMethods{
  final _snackBarService = locator<SnackbarService>();
 checkConnectivity() async
 {
  var connectionResult = await Connectivity().checkConnectivity();

  if(connectionResult!= ConnectivityResult.mobile && connectionResult!= ConnectivityResult.wifi)
  {
     _snackBarService.showSnackbar(
            message: AppConstants.noInternetText,
            duration: const Duration(seconds: 2));
  }
 }
}