import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yade_bus/screens/splash.dart';
import 'package:yade_bus/services/events_service.dart';
import 'package:yade_bus/services/messaging_service.dart';
import 'package:yade_bus/services/notification_service.dart';
import 'package:yade_bus/services/orange_money_service.dart';
import 'package:yade_bus/services/reservation_service.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  await NotificationService.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationService()),
        ChangeNotifierProvider(create: (_) => OrangeMoneyService()),
        ChangeNotifierProvider(create: (_) => EventsService()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final messagingService = MessagingService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messagingService.init();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition:
                Transition.fade, // Ou n'importe quelle autre transition
            theme: ThemeData(
              scaffoldBackgroundColor:
                  Colors.white, // Couleur de fond pour toutes les pages
              // colorScheme: ColorScheme.fromSeed(seedColor: vert),
              useMaterial3: true,
            ),
            home: const SplashScreen(), 
          );
        });
  }
}
