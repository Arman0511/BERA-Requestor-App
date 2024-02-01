import 'package:stacked/stacked.dart';
import 'package:my_first_app/local_notifications.dart';

class ResponderHomepageViewModel extends BaseViewModel {
  Future<void> helpPressed() async {
     LocalNotifications.showSimpleNotification(title: "Simple Notification",
      body: "This is a simple notification",
      payload: "This is a simple data");
  }
}
