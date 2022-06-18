import 'dart:io';

import 'package:chat_app/constants/firebase_messaging_constants.dart';
import 'package:chat_app/helper/firebase_messaging_data_source.dart';
import 'package:chat_app/helper/local_push_notification_helper.dart';
import 'package:chat_app/models/app_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/providers/home_provider.dart';
import 'package:chat_app/providers/profile_provider.dart';
import 'package:chat_app/screens/splash_page.dart';
import 'package:chat_app/utilities/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await FirebaseMessagingHelper.instance.init();
  await FirebaseMessagingHelper.instance.requestPermission();
  await LocalPushNotificationHelper.instance.init();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    FirebaseMessagingHelper.instance.onMessage.listen((event) {
      LocalPushNotificationHelper.instance.notify(
        AppNotification(
          title: event.notification?.title ?? '',
          message: event.notification?.body ?? '',
          image: event.data[FirebaseMessagingConstants.firebaseKeyImage] ?? '',
          isAndroid: event.notification?.android != null,
          data: event.data,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            firebaseFirestore: firebaseFirestore,
            prefs: widget.prefs,
            googleSignIn: GoogleSignIn(),
            firebaseAuth: FirebaseAuth.instance,
          ),
        ),
        Provider<ProfileProvider>(
          create: (_) => ProfileProvider(
            prefs: widget.prefs,
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),
        Provider<HomeProvider>(
          create: (_) => HomeProvider(
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: widget.prefs,
            firebaseStorage: firebaseStorage,
            firebaseFirestore: firebaseFirestore,
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Talk',
        theme: appTheme,
        home: const SplashPage(),
      ),
    );
  }
}
