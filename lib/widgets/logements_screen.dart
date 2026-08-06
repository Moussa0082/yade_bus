import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yade_bus/screens/detail_maison.dart';
// import 'package:yade_bus/services/logement_service.dart'; // TODO: restore when API is ready

class LogementsScreen extends StatefulWidget {
  const LogementsScreen({super.key});

  @override
  State<LogementsScreen> createState() => _LogementsScreenState();
}

class _LogementsScreenState extends State<LogementsScreen> {
  static const _primary = Color(0xFF2967FF);

  bool _isLoading = true;
  List<Map<String, dynamic>> _accommodations = [];
  List<Map<String, dynamic>> _logementImgs = [];
  String _selectedFilter = 'Tous';

  final List<String> _filters = ['Tous', 'Bamako', 'Sikasso', 'Kayes', 'Mopti'];

  @override
  void initState() {
    super.initState();
    // _loadData(); // TODO: restore when API is ready
    _loadStaticData();
  }

  /* TODO: restore when API is ready
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await LogementService().fetchAllLogement();
      final List<Map<String, dynamic>> loaded = data.cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> firstImages = [];
      for (var logement in loaded) {
        final imgs = await LogementService().fetchAllImageByLogement(logement['id']);
        final imageList = imgs.cast<Map<String, dynamic>>();
        firstImages.add(imageList.isNotEmpty ? imageList[0] : {'img': ''});
      }
      if (mounted) {
        setState(() {
          _accommodations = loaded;
          _logementImgs = firstImages;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  */

  void _loadStaticData() {
    _accommodations = [
      {
        'id': 1, 'nom': 'Villa Moderne ACI 2000', 'adresse': 'Bamako, ACI 2000',
        'bed_type': '3 ch.', 'bathroom': '2', 'nb_pers': 6, 'prixnuit': '25 000',
        'description': 'Villa spacieuse avec piscine, WiFi, climatisation et parking sécurisé.',
      },
      {
        'id': 2, 'nom': 'Résidence du Fleuve', 'adresse': 'Bamako, Badalabougou',
        'bed_type': '2 ch.', 'bathroom': '2', 'nb_pers': 4, 'prixnuit': '18 000',
        'description': 'Vue imprenable sur le fleuve Niger, terrasse, cuisine équipée.',
      },
      {
        'id': 3, 'nom': 'Appartement Hippodrome', 'adresse': 'Bamako, Hippodrome',
        'bed_type': '1 ch.', 'bathroom': '1', 'nb_pers': 2, 'prixnuit': '12 000',
        'description': 'Appartement central, idéal pour voyageurs d\'affaires.',
      },
      {
        'id': 4, 'nom': 'Villa Sikasso Centre', 'adresse': 'Sikasso, Centre-ville',
        'bed_type': '2 ch.', 'bathroom': '2', 'nb_pers': 5, 'prixnuit': '10 000',
        'description': 'Villa calme avec jardin arboré, proche des commodités.',
      },
      {
        'id': 5, 'nom': 'Chambre d\'hôtes Kayes', 'adresse': 'Kayes, Plateau',
        'bed_type': '1 ch.', 'bathroom': '1', 'nb_pers': 2, 'prixnuit': '7 500',
        'description': 'Accueil chaleureux, petit-déjeuner inclus, ambiance familiale.',
      },
    ];
    _logementImgs = [
      {'img': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80'},
      {'img': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&q=80'},
      {'img': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&q=80'},
      {'img': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80'},
      {'img': 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800&q=80'},
    ];
    if (mounted) setState(() => _isLoading = false);
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 'Tous') return _accommodations;
    return _accommodations.where((a) {
      final adresse = (a['adresse'] ?? '').toString().toLowerCase();
      return adresse.contains(_selectedFilter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildFilterChips(),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Logements',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Appartements et résidences confortables',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 14),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (_, i) {
            final selected = _selectedFilter == _filters[i];
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = _filters[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? _primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _primary : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (_, __) => _shimmerCard(),
      );
    }
    final items = _filtered;
    if (items.isEmpty) {
      return const Center(
        child: Text('Aucun logement trouvé',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        final origIndex = _accommodations.indexOf(item);
        final imgUrl = origIndex >= 0 && origIndex < _logementImgs.length
            ? _logementImgs[origIndex]['img'] ?? ''
            : '';
        return _buildLogementCard(item, imgUrl);
      },
    );
  }

  Widget _buildLogementCard(Map<String, dynamic> item, String imgUrl) {
    return GestureDetector(
      onTap: () {
        final origIndex = _accommodations.indexOf(item);
        Get.to(
          DetailMaison(
            details: item,
            imageUrls: [origIndex >= 0 && origIndex < _logementImgs.length
                ? _logementImgs[origIndex]
                : {'img': ''}],
          ),
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: imgUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imgUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _imagePlaceholder(200),
                          errorWidget: (_, __, ___) => _imagePlaceholder(200),
                        )
                      : _imagePlaceholder(200),
                ),
                // Heart icon
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)
                      ],
                    ),
                    child: const Icon(Icons.favorite_border_rounded,
                        size: 18, color: Color(0xFF9CA3AF)),
                  ),
                ),
                // Rating badge
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                        SizedBox(width: 3),
                        Text('4.5',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['nom'] ?? 'Sans nom',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['adresse'] ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF6B7280)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _specBadge(Icons.bed_outlined, '${item['bed_type'] ?? '-'}'),
                      const SizedBox(width: 12),
                      _specBadge(Icons.bathtub_outlined,
                          '${item['bathroom'] ?? '-'}'),
                      const SizedBox(width: 12),
                      _specBadge(Icons.people_outline_rounded,
                          '${item['nb_pers'] ?? '-'} pers.'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${item['prix'] ?? item['prixnuit'] ?? '---'} ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2967FF),
                            ),
                          ),
                          const TextSpan(
                            text: 'Fcfa / nuitée',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Réserver',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _imagePlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFFF5F7FA),
      child: const Icon(Icons.home_outlined, size: 48, color: Color(0xFFD1D5DB)),
    );
  }

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 300,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
