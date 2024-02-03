import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:relative_time/relative_time.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'firebase_options.dart';

//function to listen to background changes

Future _firebaseBackgroundMessage(RemoteMessage message)async{
  if(message.notification!=null){
    print("Some Notification Received");
  }
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(environment: Environment.prod);
  setupDialogUi();
  setupBottomSheetUi();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // //listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
   PushNotifications.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.rubikTextTheme()),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        RelativeTimeLocalizations.delegate,
      ],
    );
  }
}
