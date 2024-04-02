import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  Future<bool> hasInternetConnection() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.vpn) {
      return true;
    } else {
      return false;
    }
  }
}
