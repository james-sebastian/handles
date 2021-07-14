import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handles/config/config.dart';
import 'package:handles/provider/providers.dart';
import 'package:handles/screen/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

    Future<dynamic> onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title!),
          content: Text(body!),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
        // );
      }
    );

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
