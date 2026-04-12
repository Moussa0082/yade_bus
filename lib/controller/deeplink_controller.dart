import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
// import 'package:uni_links/uni_links.dart';
class DeepLinkController extends GetxController {
  final _returnLink = RxnString();
  StreamSubscription<Uri>? _sub;
  final _appLinks = AppLinks();

  // Getter pour récupérer le lien de retour
  String? get returnLink => _returnLink.value;

  // Initialise l'écoute des liens profonds
  void initListener() {
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      if (uri != null) {
        final path = uri.path;

        if (path == '/webpaydev/cancel') {
          Get.toNamed('/cancel'); // Redirige vers la page d'annulation
        }
        // else if (path.startsWith('/products')) {
        //   final productId = uri.pathSegments[1];
        //   Get.toNamed('/products/$productId'); // Redirige vers la page du produit
        // }
        else {
          Get.toNamed(
              '/'); // Redirige vers l'accueil si aucune route ne correspond
        }

        // Enregistre le lien pour un éventuel traitement
        _returnLink.value = uri.toString();
      }
    }, onError: (err) {
      print("Erreur lors de l'écoute des liens profonds : $err");
    });
  }

  // Nettoie l'écoute des liens lors de la destruction du contrôleur
  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}