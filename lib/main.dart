import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:handles/config/config.dart';
import 'package:handles/provider/providers.dart';
import 'package:handles/screen/pages.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  AwesomeNotifications().initialize(
    'resource://mipmap/ic_launcher',
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.white,
          ledColor: Colors.white),
      NotificationChannel(
          channelKey: 'badge_channel',
          channelName: 'Badge indicator notifications',
          channelDescription: 'Notification channel to activate badge indicator',
          channelShowBadge: true,
          defaultColor: Colors.white,
          ledColor: Colors.yellow),
      NotificationChannel(
          channelKey: 'ringtone_channel',
          channelName: 'Ringtone Channel',
          channelDescription: 'Channel with default ringtone',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          defaultRingtoneType: DefaultRingtoneType.Ringtone),
      NotificationChannel(
          channelKey: 'updated_channel',
          channelName: 'Channel to update',
          channelDescription: 'Notifications with not updated channel',
          defaultColor: Colors.white,
          ledColor: Colors.white),
      NotificationChannel(
          channelKey: 'big_picture',
          channelName: 'Big pictures',
          channelDescription: 'Notifications with big and beautiful images',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          vibrationPattern: lowVibrationPattern),
      NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Alarm),
      NotificationChannel(
          icon: 'resource://mipmap/ic_launcher',
          channelKey: 'progress_bar',
          channelName: 'Progress bar notifications',
          channelDescription: 'Notifications with a progress bar layout',
          defaultColor: Palette.primary,
          ledColor: Palette.primary,
          vibrationPattern: lowVibrationPattern,
          onlyAlertOnce: true),
      NotificationChannel(
          channelKey: 'grouped',
          channelName: 'Grouped notifications',
          channelDescription: 'Notifications with group functionality',
          groupKey: 'grouped',
          groupSort: GroupSort.Desc,
          groupAlertBehavior: GroupAlertBehavior.Children,
          defaultColor: Palette.primary,
          ledColor: Palette.primary,
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High)
    ],
    debug: true
  );

  AwesomeNotifications().actionStream.listen((receivedNotification) async {
    if(receivedNotification.payload != null){
      if(receivedNotification.payload!['link'] != ""){
        await launch(receivedNotification.payload!['link']!);
      }
    }
  });

  runApp(
    ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Handles',
      theme: ThemeData(
        primarySwatch: MaterialColor(Palette.primaryIntForm, Palette.materialColorMap),
        primaryColor: Palette.primary,
        accentColor: Palette.primary,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Palette.secondary),
          trackColor: MaterialStateProperty.all(Palette.secondary.withOpacity(0.5)),
        ),
        splashColor: Palette.primary.withOpacity(0.25)
      ),
      home: Authenticator(),
    );
  }
}

class Authenticator extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {

    final authStateChanges = watch(authStateChangesProvider);

    return authStateChanges.when(
      data: (user){
        return user != null
          ? user.displayName == "" || user.displayName == null
            ? AccountCreationPage()
            : Homepage()
          : OnboardingPage();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
