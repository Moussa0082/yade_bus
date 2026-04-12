

// class NetworkController extends GetxController {
//   final RxBool isConnectedToInternet = false.obs;
//   bool firstCheckDone = false;

//   late StreamSubscription<InternetStatus> _internetConnectionStreamSubscription;

//   final Completer<void> _initialCheckCompleter = Completer<void>();
//   Future<void> get initialCheckComplete => _initialCheckCompleter.future;

//   @override
//   void onInit() {
//     super.onInit();
//     _checkInitialConnection();

//     // Écoute les changements d'état internet
//     _internetConnectionStreamSubscription =
//         InternetConnection().onStatusChange.listen(_handleConnectionChange);
//   }

//   /// ✅ Gère le changement de connexion avec logique de synchronisation
//   Future<void> _handleConnectionChange(InternetStatus event) async {
//     final context = Get.context;
//     if (context == null) return;

//     // Récupération de l'utilisateur pour la sync
//     final userProvider =
//         Provider.of<UtilisateurProvider>(context, listen: false);
//     final currentUser = userProvider.user;

//     switch (event) {
//       case InternetStatus.connected:
//         // Si on passe de Déconnecté -> Connecté
//         if (!isConnectedToInternet.value && firstCheckDone) {
//           Snack.showToatSucces("Connexion internet rétablie");

//           // 🔥 INITIALISATION DYNAMIQUE
//           FirebaseInitializer.setup();

//           // Lancement de la synchronisation (Style Meta : en arrière-plan)
//           if (currentUser != null && currentUser.numero != null) {
//             print(
//                 "🔄 Reprise de connexion : Lancement Sync pour ${currentUser.numero}");
//             SyncManager.sendPendingMessages(currentUser.numero!);
//           }
//         }

//         isConnectedToInternet.value = true;
//         print("🌐 Connecté");
//         break;

//       case InternetStatus.disconnected:
//         // Si on passe de Connecté -> Déconnecté
//         if (isConnectedToInternet.value && firstCheckDone) {
//           Snack.showToatError("Connexion internet perdue");
//         }

//         isConnectedToInternet.value = false;
//         print("❌ Déconnecté");
//         break;
//     }
//   }

//   /// ✅ Vérification initiale au lancement (Unique méthode conservée)
//   Future<void> _checkInitialConnection() async {
//     try {
//       // Timeout de 10s pour ne pas bloquer l'app en cas de 2G très faible
//       final hasInternet = await InternetConnection()
//           .hasInternetAccess
//           .timeout(const Duration(seconds: 10), onTimeout: () => false);

//       isConnectedToInternet.value = hasInternet;
//     } catch (_) {
//       isConnectedToInternet.value = false;
//     }

//     firstCheckDone = true;

//     // Débloque les futurs qui attendent l'initialisation
//     if (!_initialCheckCompleter.isCompleted) {
//       _initialCheckCompleter.complete();
//     }

//     print(
//       isConnectedToInternet.value
//           ? '🌐 Initial connection: Connected'
//           : '📴 Initial connection: Disconnected',
//     );

//     // Alerte si pas d'internet au démarrage
//     if (!isConnectedToInternet.value) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (Get.context != null) {
//           Snack.showToatError('Vérifiez votre connexion');
//         }
//       });
//     }
//   }
 
   
//   /// ✅ MÉTHODE SÛRE À UTILISER AU DÉMARRAGE (Splash Screen par exemple) 
//   Future<bool> waitForInitialCheck() async {
//     await _initialCheckCompleter.future;
//     return isConnectedToInternet.value;
//   }

//   /// ✅ Exécution sécurisée d'une action uniquement si connecté
//   Future<bool> executeWithConnectionCheck(
//     Future<void> Function() function, {
//     bool showError = true,
//     String? customErrorMessage,
//   }) async {
//     if (!isConnectedToInternet.value) {
//       if (showError && Get.context != null) {
//         Snack.showToatError(
//           customErrorMessage ?? 'Connexion internet requise pour cette action',
//         );
//       }
//       return false;
//     }

//     try {
//       await function();
//       return true;
//     } catch (e) {
//       print('❌ Erreur lors de l\'exécution: $e');
//       return false;
//     }
//   }

//   @override
//   void onClose() {
//     _internetConnectionStreamSubscription.cancel();
//     super.onClose();
//   }
// }
