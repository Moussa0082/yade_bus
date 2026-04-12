import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:uni_links3/uni_links.dart';
import 'package:yade_bus/controller/deeplink_controller.dart';
import 'package:yade_bus/provider/AuthProvider.dart';
import 'package:yade_bus/screens/accueil.dart';
import 'package:yade_bus/screens/splash.dart';
import 'package:yade_bus/services/events_service.dart';
import 'package:yade_bus/services/logement_service.dart';
import 'package:yade_bus/services/messaging_service.dart';
import 'package:yade_bus/services/notification_service.dart';
import 'package:yade_bus/services/orange_money_service.dart';
import 'package:yade_bus/services/paiement_service.dart';
import 'package:yade_bus/services/reservation_service.dart';
// import 'package:yade_bus/widgets/nav_bar.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase               
  await Firebase.initializeApp();                             
  await FirebaseMessaging.instance.getInitialMessage();             
  await NotificationService.instance.initialize();    
   
  runApp(   
    MultiProvider(  
      providers: [           
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReservationService()),
        ChangeNotifierProvider(create: (_) => OrangeMoneyService()),
        ChangeNotifierProvider(create: (_) => EventsService()),
        ChangeNotifierProvider(create: (_) => LogementService()),

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
  StreamSubscription? _sub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messagingService.init();
    // _initDeepLinks(); 
  }

   
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  //   Future<void> _initDeepLinks() async {
  //   _sub = linkStream.listen((String? link) {
  //     if (link == 'https://yadebus.com/webpaydev/cancel') {
  //       // Naviguer vers l'écran d'annulation
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => CancelConfirmationScreen()),
  //       );
  //     }
  //   }, onError: (err) {
  //     print('Erreur lors de la réception du lien : $err');
  //   });
  // }

  // This widget is the root of your application.
  final DeepLinkController deepLinkController = Get.put(DeepLinkController());
  @override
  Widget build(BuildContext context) {
    // Initialise l'écoute des liens profonds
    deepLinkController.initListener();

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return GetMaterialApp(
            initialBinding: BindingsBuilder(() {
              Get.put(DeepLinkController()); // Initialisez le contrôleur
            }),
            getPages: [
              // Définissez les routes
              GetPage(
                  name: '/',
                  page: () => Accueil(
                      )),
              GetPage(name: '/cancel', page: () => CancelConfirmationScreen()),
            ],
            debugShowCheckedModeBanner: false,
            defaultTransition:
                Transition.fade, // Ou n'importe quelle autre transition
            theme: ThemeData(
              fontFamily:
                  'Poppins', // Définir la police Poppins comme police par défaut
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

class CancelConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Annulation confirmée')),
      body: Center(child: Text('L\'annulation a été confirmée.')),
    );
  }
}
