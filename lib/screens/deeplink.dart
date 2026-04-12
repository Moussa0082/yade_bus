
// import 'package:flutter/material.dart';
// // import 'package:uni_links/uni_links.dart';
// import 'dart:async';

// // import 'package:uni_links3/uni_links.dart';

// class DeepLinkScreen extends StatefulWidget {
//   @override
//   _DeepLinkScreenState createState() => _DeepLinkScreenState();
// }

// class _DeepLinkScreenState extends State<DeepLinkScreen> {
//   String _latestLink = 'Unknown';
//   StreamSubscription? _sub;

//   @override
//   void initState() {
//     super.initState();
//     // _initDeepLinks();
//   }

//   // Future<void> _initDeepLinks() async {
//   //   _sub = linkStream.listen((String? link) {
//   //     if (!mounted) return;
//   //     setState(() {
//   //       _latestLink = link ?? 'Unknown';
//   //     });
//   //   }, onError: (err) {
//   //     if (!mounted) return;
//   //     setState(() {
//   //       _latestLink = 'Failed to get link: $err';
//   //     });
//   //   });
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Deep Links')),
//       body: Center(child: Text('Latest Link: $_latestLink')),
//     );
//   }
// }