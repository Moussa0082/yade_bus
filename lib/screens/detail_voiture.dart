import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final top = MediaQuery.of(context).padding.top;
    final bool hasImages =
        widget.imagesUrl != null && widget.imagesUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          Column(
            children: [
              // Image carousel
              SizedBox(
                height: 280,
                child: hasImages
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: 280,
                          viewportFraction: 1.0,
                          autoPlay: imageList.length > 1,
                        ),
                        items: imageList.map((url) {
                          return Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                _imagePlaceholder(280),
                            loadingBuilder: (_, child, p) {
                              if (p == null) return child;
                              return _imagePlaceholder(280);
                            },
                          );
                        }).toList(),
                      )
                    : _imagePlaceholder(280),
              ),

              // Details panel
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.details['marque'] ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ),
                            Text(
                              '${widget.details['priceday']} F/j',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2967FF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildDetailGrid(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Back button overlay
          Positioned(
            top: top + 14,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ),

          // Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _actionBtn(
                    icon: FontAwesomeIcons.whatsapp,
                    label: 'WhatsApp',
                    color: const Color(0xFF2967FF),
                    onTap: () =>
                        _launchURL('https://wa.me/?text=Check%20this%20car'),
                  ),
                  const SizedBox(width: 10),
                  _actionBtn(
                    icon: Icons.call_rounded,
                    label: 'Appel',
                    color: const Color(0xFF2967FF),
                    onTap: () => _launchURL('tel:82511723'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2967FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Réserver',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailGrid() {
    final specs = [
      {
        'icon': Icons.settings_rounded,
        'label': 'Boîte',
        'value': widget.details['transmission'] ?? '-',
        'color': const Color(0xFF2967FF),
      },
      {
        'icon': Icons.directions_car_rounded,
        'label': 'Type',
        'value': widget.details['taille'] ?? '-',
        'color': const Color(0xFF2967FF),
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'label': 'Disponible',
        'value': widget.details['dispo'] == 1 ? 'Oui' : 'Non',
        'color': const Color(0xFF2967FF),
      },
      {
        'icon': Icons.speed_rounded,
        'label': 'Vitesse',
        'value': widget.details['Mileage'] ?? '-',
        'color': const Color(0xFF2967FF),
      },
      {
        'icon': Icons.ac_unit_rounded,
        'label': 'Clim',
        'value': widget.details['AC'] == 1 ? 'Oui' : 'Non',
        'color': const Color(0xFF2967FF),
      },
      {
        'icon': Icons.ev_station_rounded,
        'label': 'Réservoir',
        'value': widget.details['fuel'] ?? '-',
        'color': const Color(0xFF2967FF),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: specs.length,
      itemBuilder: (_, i) {
        final s = specs[i];
        final color = s['color'] as Color;
        return Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(s['icon'] as IconData, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                s['value'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                s['label'] as String,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF9CA3AF)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFF5F7FA),
      alignment: Alignment.center,
      child: const Icon(Icons.directions_car_rounded,
          size: 60, color: Color(0xFFD1D5DB)),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
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
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
