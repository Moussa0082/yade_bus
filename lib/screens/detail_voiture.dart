import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yade_bus/constant/constantes.dart';

class CarDetailScreen extends StatefulWidget {
  Map<String, dynamic> details;
  Map<String, dynamic>? imagesUrl;
  CarDetailScreen({super.key, required this.details, this.imagesUrl});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[100],
  // appBar: AppBar(
  //   backgroundColor: bleuFoncer,
  //   title: Text('Porsche 911 Carrera', style: TextStyle(color: blanc)),
  //   leading: IconButton(
  //     icon: Icon(Icons.arrow_back_ios, color: blanc),
  //     onPressed: () => Navigator.pop(context),
  //   ),
  //   actions: [
  //     IconButton(
  //       icon: Icon(Icons.favorite_border, color: blanc),
  //       onPressed: () {},
  //     ),
  //   ],
  // ),

  List<String> imageList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // imageList =
    //     (widget.imagesUrl as List).map((e) => e['img'] as String).toList();

    super.initState();
    if (widget.imagesUrl != null && widget.imagesUrl is Map) {
      imageList = (widget.imagesUrl as Map<String, dynamic>)
          .values
          .map((e) => e.toString())
          .toList();
    }
    // imageList = widget.imagesUrl?.values.map((e) => e.toString()).toList() ?? [];
  }

  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkc3Cya8bQnPu8OPdwzDna1nz0JU9b4icpAA&s',
  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkc3Cya8bQnPu8OPdwzDna1nz0JU9b4icpAA&s',
  // ];

  @override
  Widget build(BuildContext context) {
// final List<String> imageList = (imagesUrl ?? {}).values.map((e) => e.toString()).toList();
// final List<String> imageList = (imagesUrl ?? {})
//     .entries
//     .map((e) => e.value.toString())
//     .where((url) => url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true)
//     .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bleuFoncer,
        title: Text(widget.details['marque'],
            style: const TextStyle(color: blanc)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blanc),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: blanc),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.imagesUrl != null || widget.imagesUrl!.isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 1.0,
                        autoPlay: true,
                      ),
                      items: imageList.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.network(
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Container(
                                    height: 250,
                                    // width: double.infinity,
                                    color: Colors.grey.withOpacity(0.3),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    ),
                                  );
                                }
                              },
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 250,
                                  // width: 120,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_outlined,
                                      size: 40, color: Colors.grey),
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    )

                  // CarouselSlider(
                  //     options: CarouselOptions(
                  //       height: 250,
                  //       viewportFraction: 1.0,
                  //       autoPlay: true,
                  //     ),
                  //     items: imagesUrl!.entries.map((imageUrl) {
                  //       final image = imageUrl.value;
                  //       return Builder(
                  //         builder: (BuildContext context) {
                  //           return Image.network(
                  //             image,
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             errorBuilder: (context, error, stackTrace) {
                  //               return Icon(Icons.error);
                  //             },
                  //           );
                  //         },
                  //       );
                  //     }).toList(),
                  //   )
                  : Container(
                      height: 250,
                      // width: 120,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_outlined,
                          size: 40, color: Colors.grey),
                    ), //

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "${widget.details['priceday']} F",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildCarDetailRow('Boite',
                            widget.details['transmission'], Icons.settings),
                        const SizedBox(height: 10),
                        _buildCarDetailRow(' Type', widget.details['taille'],
                            Icons.directions_car),
                        const SizedBox(height: 10),
                        _buildCarDetailRow(
                            'Disponible',
                            widget.details['dispo'] == 1 ? "Oui" : "Non",
                            Icons.check_circle_outline),
                        const SizedBox(height: 10),
                        _buildCarDetailRow(
                            'Vitesse', widget.details['Mileage'], Icons.speed),
                        const SizedBox(height: 10),
                        _buildCarDetailRow(
                            'Climatisation',
                            widget.details['AC'] == 1 ? "Oui" : "Non",
                            Icons.ac_unit),
                        const SizedBox(height: 10),
                        _buildCarDetailRow('Reservoir', widget.details['fuel'],
                            Icons.ev_station),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                      width: 120,
                      FontAwesomeIcons.whatsapp,
                      'WhatsApp',
                      Colors.green,
                      () =>
                          _launchURL('https://wa.me/?text=Check%20this%20car')),
                  _buildActionButton(
                      Icons.call,
                      'Appel',
                      bleu,
                      width: 94,
                      () => _launchURL('tel:82511723')),
                  _buildActionButton(
                      Icons.assignment_turned_in,
                      'Reserver',
                      bleu,
                      width: 112,
                      () {}),
                  //      _buildActionButton(
                  //     Icons.calendar_today,
                  //     'Reserver',
                  //     width: 90,
                  //     Colors.blue, () {
                  //   Get.to(VoitureReservation());
                  // }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed,
      {double? width}) {
    return SizedBox(
      width: width ?? 120,
      height: 35,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 15, color: Colors.white),
        label: Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          label,
          // overflow: TextOverflow.ellipsis,
          // maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
      ),
    );
  }

  whatsapp() async {
    String contact = "+22382511723";
    String text = 'Je suis interessé';
    String androidUrl = "whatsapp://send?phone=$contact&text=$text";
    String iosUrl = "https://wa.me/$contact?text=${Uri.parse(text)}";

    String webUrl = 'https://api.whatsapp.com/send/?phone=$contact&text=hi';

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(iosUrl))) {
          await launchUrl(Uri.parse(iosUrl));
        }
      } else {
        if (await canLaunchUrl(Uri.parse(androidUrl))) {
          await launchUrl(Uri.parse(androidUrl));
        }
      }
    } catch (e) {
      print('object');
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
