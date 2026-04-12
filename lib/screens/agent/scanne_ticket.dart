// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

// class ScannerTicketPage extends StatefulWidget {
//   @override
//   _ScannerTicketPageState createState() => _ScannerTicketPageState();
// }

// class _ScannerTicketPageState extends State<ScannerTicketPage> {
//   String ticketCode = '';
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool isScanning = false;

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Scanner un ticket")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // TextField(
//             //   decoration: InputDecoration(labelText: "Entrez le code du ticket"),
//             //   onChanged: (value) => setState(() => ticketCode = value),
//             // ),
//             // SizedBox(height: 20),
//             // ElevatedButton(onPressed: () {}, child: Text("Valider")),
//             // SizedBox(height: 20),
//             Expanded(
//               child: isScanning
//                   ? QRView(
//                       key: qrKey,
//                       onQRViewCreated: _onQRViewCreated,
//                     )
//                   : Container(
//                       height: 70,
//                       width: double.infinity,
//                       color: Colors.grey[200],
//                       child: Center(
//                           child: IconButton(
//                         icon: Icon(Icons.qr_code_scanner,
//                             size: 100, color: Colors.grey),
//                         onPressed: _startScan,
//                       )),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _startScan() {
//     setState(() {
//       isScanning = true;
//     });
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         ticketCode = scanData.code!;
//         isScanning = false;
//       });
//       controller.pauseCamera();
//     });
//   }
// }

import 'package:flutter/material.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:yade_bus/constant/constantes.dart';

class ScannerTicketPage extends StatefulWidget {
  @override
  _ScannerTicketPageState createState() => _ScannerTicketPageState();
}

class _ScannerTicketPageState extends State<ScannerTicketPage> {
  String ticketCode = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // QRViewController? controller;
  bool isScanning = false;
  bool ticketValidated =
      false; // Ajout d'une variable pour l'état de validation du ticket

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner un ticket", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Couleur de l'app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isScanning)
            //   Expanded(
            //     flex: 2,
            //     child: QRView(
            //       key: qrKey,
            //       onQRViewCreated: _onQRViewCreated,
            //       overlay: QrScannerOverlayShape(
            //         borderColor: Colors.blue,
            //         borderRadius: 10,
            //         borderLength: 30,
            //         borderWidth: 10,
            //         cutOutSize: 250,
            //       ),
            //     ),
            //   )
            // else
            //   Container(
            //     height: 100, // Hauteur ajustée
            //     margin: EdgeInsets.symmetric(vertical: 20),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[200],
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Center(
            //       child: Column(
            //         children: [
            //           Text(
            //             "Cliqué ici ",
            //             style: TextStyle(color: bleuFoncer, fontSize: 14),
            //           ),
            //           IconButton(
            //             icon: Icon(Icons.qr_code_scanner,
            //                 size: 50, color: Colors.grey),
            //             onPressed: _startScan,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            SizedBox(height: 20),
            if (ticketCode.isNotEmpty)
              Text(
                "Code du ticket: $ticketCode",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ticketCode.isNotEmpty ? _validateTicket : null,
              child:
                  Text(ticketValidated ? "Ticket validé" : "Valider le ticket"),
              style: ElevatedButton.styleFrom(
                backgroundColor: ticketValidated ? Colors.green : Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(height: 10),
            if (ticketValidated)
              Text(
                "Le ticket a été validé avec succès.",
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  void _startScan() {
    setState(() {
      isScanning = true;
    });
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       ticketCode = scanData.code!;
  //       isScanning = false;
  //     });
  //     controller.pauseCamera();
  //   });
  // }

  void _validateTicket() {
    // Ajoutez ici la logique de validation de votre ticket
    // Par exemple, vérifiez si le code du ticket existe dans votre base de données
    setState(() {
      ticketValidated = true;
    });
  }
}
