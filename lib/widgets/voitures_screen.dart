import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http; // TODO: restore when API is ready
import 'package:shimmer/shimmer.dart';
// import 'package:yade_bus/constant/constantes.dart'; // TODO: restore when API is ready
import 'package:yade_bus/screens/detail_voiture.dart';
// import 'package:yade_bus/services/voiture_servce.dart'; // TODO: restore when API is ready
// import 'dart:convert'; // TODO: restore when API is ready

class VoituresScreen extends StatefulWidget {
  const VoituresScreen({super.key});

  @override
  State<VoituresScreen> createState() => _VoituresScreenState();
}

class _VoituresScreenState extends State<VoituresScreen> {
  static const _primary = Color(0xFF2967FF);

  bool _isLoading = true;
  bool _isLoadingCat = true;
  List<Map<String, dynamic>> _cars = [];
  List<Map<String, dynamic>> _carImgs = [];
  List<Map<String, dynamic>> _carsImgAll = [];
  List<dynamic> _categories = [];
  String _selectedFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    // _fetchCategories(); // TODO: restore when API is ready
    // _loadData();        // TODO: restore when API is ready
    _loadStaticData();
  }

  /* TODO: restore when API is ready
  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/categorie_voiture.php'));
      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes)) as List;
        body.insert(0, {'taille': 'Tous'});
        if (mounted) setState(() { _categories = body; _isLoadingCat = false; });
      } else { if (mounted) setState(() => _isLoadingCat = false); }
    } catch (_) { if (mounted) setState(() => _isLoadingCat = false); }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final cardData = await VoitureService().fetchAllvehicule();
      final cars = cardData.cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> firstImgs = [];
      List<Map<String, dynamic>> allImgs = [];
      for (var car in cars) {
        final imgs = await VoitureService().fetchAllImageByVehicule(car['id']);
        final imageList = imgs.cast<Map<String, dynamic>>();
        firstImgs.add(imageList.isNotEmpty ? imageList[0] : {'img': ''});
        allImgs.add({ for (int i = 0; i < imageList.length; i++) 'img$i': imageList[i]['img'] });
      }
      if (mounted) setState(() { _cars = cars; _carImgs = firstImgs; _carsImgAll = allImgs; _isLoading = false; });
    } catch (_) { if (mounted) setState(() => _isLoading = false); }
  }

  Future<void> _filterByType(String taille) async {
    setState(() => _isLoading = true);
    try {
      if (taille == 'Tous') { await _loadData(); return; }
      final result = await VoitureService().fetchAllVehiculeByType(taille);
      final filtered = result.cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> imgs = [];
      List<Map<String, dynamic>> allImgs = [];
      for (var car in filtered) {
        final il = await VoitureService().fetchAllImageByVehicule(car['id']);
        final imageList = il.cast<Map<String, dynamic>>();
        imgs.add(imageList.isNotEmpty ? imageList[0] : {'img': ''});
        allImgs.add({ for (int i = 0; i < imageList.length; i++) 'img$i': imageList[i]['img'] });
      }
      if (mounted) setState(() { _cars = filtered; _carImgs = imgs; _carsImgAll = allImgs; _isLoading = false; });
    } catch (_) { if (mounted) setState(() => _isLoading = false); }
  }
  */

  void _filterByType(String taille) {
    setState(() {
      _selectedFilter = taille;
      _cars = taille == 'Tous'
          ? _allStaticCars
          : _allStaticCars.where((c) => c['taille'] == taille).toList();
      _carImgs = _cars.map((c) => {'img': c['_img'] as String}).toList();
      _carsImgAll = _cars.map((c) => {'img0': c['_img'] as String}).toList();
    });
  }

  static const List<Map<String, dynamic>> _allStaticCars = [
    {
      'id': 1, 'marque': 'Toyota Land Cruiser 200', 'ville': 'Bamako',
      'seat': 7, 'carburant': 'Diesel', 'transmission': 'Automatique',
      'priceday': '75 000', 'taille': 'SUV',
      'description': 'Idéal pour les longs trajets et pistes africaines. Full options.',
      '_img': 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&q=80',
    },
    {
      'id': 2, 'marque': 'Toyota Corolla 2023', 'ville': 'Bamako',
      'seat': 5, 'carburant': 'Essence', 'transmission': 'Automatique',
      'priceday': '35 000', 'taille': 'Berline',
      'description': 'Berline confortable et économique pour vos déplacements urbains.',
      '_img': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&q=80',
    },
    {
      'id': 3, 'marque': 'Mitsubishi L200', 'ville': 'Bamako',
      'seat': 5, 'carburant': 'Diesel', 'transmission': 'Manuelle',
      'priceday': '55 000', 'taille': 'Pick-up',
      'description': 'Pick-up robuste pour les zones difficiles d\'accès.',
      '_img': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    },
    {
      'id': 4, 'marque': 'Hyundai Tucson', 'ville': 'Sikasso',
      'seat': 5, 'carburant': 'Essence', 'transmission': 'Automatique',
      'priceday': '45 000', 'taille': 'SUV',
      'description': 'SUV moderne, confort et style pour vos sorties.',
      '_img': 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80',
    },
    {
      'id': 5, 'marque': 'Mercedes Sprinter', 'ville': 'Bamako',
      'seat': 15, 'carburant': 'Diesel', 'transmission': 'Manuelle',
      'priceday': '90 000', 'taille': 'Minibus',
      'description': 'Parfait pour groupes, transferts aéroport et événements.',
      '_img': 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&q=80',
    },
  ];

  void _loadStaticData() {
    _categories = [
      {'taille': 'Tous'}, {'taille': 'SUV'}, {'taille': 'Berline'},
      {'taille': 'Pick-up'}, {'taille': 'Minibus'},
    ];
    _cars = List.from(_allStaticCars);
    _carImgs = _cars.map((c) => {'img': c['_img'] as String}).toList();
    _carsImgAll = _cars.map((c) => {'img0': c['_img'] as String}).toList();
    if (mounted) {
      setState(() { _isLoading = false; _isLoadingCat = false; });
    }
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
            'Location de voitures',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Pour vos séjours et événements',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = _isLoadingCat
        ? ['Toutes']
        : _categories.map((c) => c['taille'].toString()).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 14),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (_, i) {
            final label = filters[i];
            final selected = _selectedFilter == label;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedFilter = label);
                _filterByType(label);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? _primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          selected ? _primary : const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
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
        itemCount: 4,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 300,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
    }
    if (_cars.isEmpty) {
      return const Center(
        child: Text('Aucun véhicule disponible',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _cars.length,
      itemBuilder: (_, index) {
        final car = _cars[index];
        final imgUrl =
            index < _carImgs.length ? _carImgs[index]['img'] ?? '' : '';
        return _buildCarCard(car, imgUrl, index);
      },
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car, String imgUrl, int index) {
    return GestureDetector(
      onTap: () => Get.to(
        CarDetailScreen(
          details: car,
          imagesUrl: index < _carsImgAll.length ? _carsImgAll[index] : {},
        ),
        transition: Transition.rightToLeftWithFade,
      ),
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: imgUrl.isNotEmpty
                      ? Image.network(
                          imgUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imgPlaceholder(),
                          loadingBuilder: (_, child, progress) =>
                              progress == null ? child : _imgPlaceholder(),
                        )
                      : _imgPlaceholder(),
                ),
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
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6)
                      ],
                    ),
                    child: const Icon(Icons.favorite_border_rounded,
                        size: 18, color: Color(0xFF9CA3AF)),
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
                    car['marque'] ?? 'Véhicule',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          car['ville'] ?? car['localisation'] ?? '',
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
                      _specBadge(
                          Icons.people_outline, '${car['seat'] ?? '-'} places'),
                      const SizedBox(width: 12),
                      _specBadge(Icons.local_gas_station_outlined,
                          car['carburant'] ?? car['type'] ?? 'Essence'),
                      const SizedBox(width: 12),
                      _specBadge(Icons.settings_outlined,
                          car['transmission'] ?? 'Auto'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${car['priceday'] ?? '---'} ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2967FF),
                            ),
                          ),
                          const TextSpan(
                            text: 'Fcfa / jour',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF9CA3AF)),
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

  Widget _imgPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: const Color(0xFFF5F7FA),
      child: const Icon(Icons.directions_car_rounded,
          size: 48, color: Color(0xFFD1D5DB)),
    );
  }
}
