import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/controller/nbplace_st_up.dart';
import 'package:yade_bus/services/orange_money_service.dart';
import 'package:yade_bus/services/reservation_service.dart';
import 'package:yade_bus/widgets/custom_btn.dart';

class DetailMaison extends StatefulWidget {
  final Map<String, dynamic> details;
  final List<Map<String, dynamic>>? imageUrls;

  DetailMaison({required this.details, this.imageUrls});

  @override
  _DetailMaisonState createState() => _DetailMaisonState();
}

class _DetailMaisonState extends State<DetailMaison> {
  // Track the number of adults, children, and rooms
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;
  DateTime? _startDate;
  DateTime? _endDate;
  int _numberOfDays = 0;

  List<String> imageUrls = [];

  // Method to calculate the number of days between the selected dates
  String getNumberOfDays() {
    if (_startDate != null && _endDate != null) {
      _numberOfDays = _endDate!.difference(_startDate!).inDays;
      return '$_numberOfDays nuits';
    } else {
      return 'Sélectionnez des dates pour voir la durée';
    }
  }

// Custom widget for increment/decrement counter
  Widget _buildCounter(
      String label, int value, int min, int max, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              IconButton(
                onPressed: value > min
                    ? () => onChanged(value - 1)
                    : null, // Disable if value <= min
                icon: Icon(Icons.remove,
                    color: value > min ? Colors.blue : Colors.grey),
              ),

              // Display the current value
              Text(
                value.toString(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),

              // Increment Button
              IconButton(
                onPressed: () => onChanged(value + 1),
                // Disable if value >= max
                icon: Icon(Icons.add,
                    color: value < max ? Colors.blue : Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // final List<String> imageUrls = [
  //   'https://q-xx.bstatic.com/xdata/images/hotel/max500/199267059.jpg?k=30bda31cbe81e5f84a295bfd7fa1d6e2abf68e87714767ec1dff97291f6b6d04&o=',
  //   'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/64/64/81/azalai-grand-hotel.jpg?w=1200&h=-1&s=1',
  //   'https://i0.wp.com/ivonomad.com/wp-content/uploads/2018/12/Bamako-Azalai-Hotel-Ivonomad-Mali-50-1.jpg?fit=1181%2C886&ssl=1',
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Detail ${widget.details}");
    imageUrls =
        (widget.imageUrls as List).map((e) => e['img'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Accéder aux données du détail via widget.details
    final String? nom = widget.details['nom'] as String?;
    final String? adresse = widget.details['adresse'] as String?;
    final String? details = widget.details['details'] as String?;
    final String? bedType = widget.details['bed_type'] as String?;
    final String? bathroom = widget.details['bathroom'] as String?;
    final int? hasAC = widget.details['AC'] as int?;
    final int? hasResto = widget.details['resto'] as int?;
    final int? hasBreakfast = widget.details['breakfast'] as int?;
    final int? hasBalcon = widget.details['balcon'] as int?;
    final String? typeLogement = widget.details['typeLogement'] as String?;
    final int? hasTV = widget.details['TV'] as int?;
    final int? nbPers = widget.details['nb_pers'] as int?;
    final int? isDispo = widget.details['dispo'] as int?;
    final int? hasCuisine = widget.details['cuisine'] as int?;
    final String? isMeuble = widget.details['meuble'] as String?;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: bleuFoncer,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: blanc,
            )),
        title: Text(
          widget.details['nom'],
          style: TextStyle(color: blanc),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.favorite_border),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: blanc,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel of hotel images
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 1.0,
                  ),
                  items: imageUrls.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.grey),
                          child: Image.network(i, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                height: 120,
                                width: double.infinity,
                                color: Colors.grey.withOpacity(0.3),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                    value: loadingProgress.expectedTotalBytes !=
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
                          }, errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_outlined,
                                  size: 40, color: Colors.grey),
                            );
                          }, fit: BoxFit.cover),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    // Nom de l'établissement
                    Text(
                      nom ?? 'Nom inconnu',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    // Adresse de l'établissement
                    if (adresse != null && adresse.isNotEmpty)
                      Text(
                        adresse,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    SizedBox(height: 16),

                    // Points forts de l'établissement
                    Text('Commodités',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildAmenityRow(
                        Icons.king_bed, 'Type de lit', bedType ?? "inconnu"),
                    _buildAmenityRow(
                        Icons.bathtub, 'Salle de bain', bathroom ?? "inconnu"),
                    if (hasAC == 1)
                      _buildAmenityRow(
                          Icons.ac_unit, 'Climatisation', 'Disponible'),
                    if (hasResto == 1)
                      _buildAmenityRow(
                          Icons.restaurant, 'Restaurant', 'Sur place'),
                    if (hasBreakfast == 1)
                      _buildAmenityRow(
                          Icons.free_breakfast, 'Petit-déjeuner', 'Inclus'),
                    if (hasBalcon == 1)
                      _buildAmenityRow(Icons.balcony, 'Balcon', 'Disponible'),
                    _buildAmenityRow(Icons.home, 'Type de logement',
                        typeLogement ?? "inconnu"),
                    if (hasTV == 1)
                      _buildAmenityRow(Icons.tv, 'Télévision', 'Disponible'),
                    if (nbPers != null)
                      _buildAmenityRow(
                          Icons.people, 'Nombre de personnes', '$nbPers'),
                    if (isDispo == 1)
                      _buildAmenityRow(
                          Icons.check_circle_outline, 'Disponibilité', 'Oui'),
                    if (hasCuisine == 1)
                      _buildAmenityRow(Icons.kitchen, 'Cuisine', 'Équipée'),
                    if (isMeuble == 1)
                      _buildAmenityRow(Icons.chair, 'Meublé', 'Oui'),
                    SizedBox(height: 16),

                    // Description avec "Read More Text"
                    if (details != null && details.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          ReadMoreText(
                            details,
                            trimLines: 3,
                            colorClickableText: Colors.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Lire la suite',
                            trimExpandedText: 'Réduire',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),

                    SizedBox(height: 5),

                    // Date range selection with DatePicker
                    // _buildDateSelection(context),

                    // SizedBox(height: 16),

                    // // Calculated number of days
                    // Text(
                    //   'Nombre de nuits: ${getNumberOfDays()}',
                    //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    // ),
                    SizedBox(height: 10),

                    // Résumé de la recherche

                    // Dropdowns for number of adults, children, rooms
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCounter("Adultes", _adults, 1, 5, (val) {
                          setState(() {
                            _adults = val;
                          });
                        }),
                        _buildCounter("Enfants", _children, 0, 3, (val) {
                          setState(() {
                            _children = val;
                          });
                        }),
                        _buildCounter("Chambres", _rooms, 1, 3, (val) {
                          setState(() {
                            _rooms = val;
                          });
                        }),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Résumé de la recherche
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Votre recherche : $_adults adultes, $_children enfant(s), $_rooms chambre(s), ${getNumberOfDays()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionButton(
                              width: 120,
                              FontAwesomeIcons.whatsapp,
                              'WhatsApp',
                              Colors.green,
                              () => _launchURL(
                                  'https://wa.me/?text=Check%20this%20car')),
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
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: btnLarge("Reserver", rouge, blanc, () {}),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modifiez vos dates pour voir les chambres disponibles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.range,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is PickerDateRange) {
              setState(() {
                _startDate = args.value.startDate;
                _endDate = args.value.endDate;
              });
            }
          },
          monthViewSettings: DateRangePickerMonthViewSettings(
            firstDayOfWeek: 1, // Monday as first day
          ),
          selectionColor: Colors.blue,
          startRangeSelectionColor: Colors.blueAccent,
          endRangeSelectionColor: Colors.blueAccent,
          rangeTextStyle: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed,
      {double? width}) {
    return SizedBox(
      width: width != null ? width : 120,
      height: 35,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 15, color: Colors.white),
        label: Text(
          overflow: TextOverflow.ellipsis, 
          maxLines: 1,
          label,
          // overflow: TextOverflow.ellipsis,
          // maxLines: 1,
          style: TextStyle(color: Colors.white, fontSize: 11),
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
