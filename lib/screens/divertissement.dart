// import 'dart:convert'; // TODO: restore when API is ready

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http; // TODO: restore when API is ready

// import 'package:yade_bus/constant/constantes.dart'; // TODO: restore when API is ready
import 'package:yade_bus/screens/detail_divertissement.dart';
// import 'package:yade_bus/services/categorie_service.dart'; // TODO: restore when API is ready

// ─── Events Tab ──────────────────────────────────────────────────────────────

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  static const _primary = Color(0xFF2967FF);

  List<dynamic> _events = [];
  List<Map<String, dynamic>> _categories = [];
  String _selectedCategory = 'all';
  bool _isLoading = true;
  bool _isCatLoading = true;

  @override
  void initState() {
    super.initState();
    // _loadCategories(); // TODO: restore when API is ready
    // _loadEvents();     // TODO: restore when API is ready
    _loadStaticData();
  }

  /* TODO: restore when API is ready
  Future<void> _loadCategories() async {
    try {
      final cats = await CategorieProduitService().fetchCategorie();
      if (mounted) {
        setState(() {
          _categories = [
            {'idCategory': 'all', 'nom': 'Tous'},
            ...cats.map((c) => {'idCategory': c.idCategory, 'nom': c.nom}),
          ];
          _isCatLoading = false;
        });
      }
    } catch (_) { if (mounted) setState(() => _isCatLoading = false); }
  }

  Future<void> _loadEvents({String categoryId = 'all'}) async {
    setState(() => _isLoading = true);
    try {
      final url = categoryId == 'all'
          ? '$apiUrl/events.php'
          : '$apiUrl/events_by_categorie.php?idCategory=$categoryId';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes)) as List;
        if (mounted) setState(() { _events = body; _isLoading = false; });
      } else { if (mounted) setState(() => _isLoading = false); }
    } catch (_) { if (mounted) setState(() => _isLoading = false); }
  }
  */

  static const List<Map<String, dynamic>> _allStaticEvents = [
    {
      'id': 1, 'nom': 'Concert Salif Keïta – Hommage au Malien',
      'categorie': 'Concert', 'date': '15 Août 2026', 'heure': '20h00',
      'localisation': 'Palais de la Culture, Bamako', 'tarif': '10 000',
      'capacite': 2000,
      'img': 'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=800&q=80',
      'description': 'Une soirée inoubliable avec la voix d\'or du Mali.',
    },
    {
      'id': 2, 'nom': 'Festival Kayes en Fête',
      'categorie': 'Festival', 'date': '20 Juil 2026', 'heure': '18h00',
      'localisation': 'Place du gouvernorat, Kayes', 'tarif': '0',
      'capacite': 5000,
      'img': 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800&q=80',
      'description': 'Célébration culturelle avec musique, danse et artisanat local.',
    },
    {
      'id': 3, 'nom': 'Foire Internationale de Bamako 2026',
      'categorie': 'Foire', 'date': '01 Sep 2026', 'heure': '09h00',
      'localisation': 'Parc des Expositions, Bamako', 'tarif': '5 000',
      'capacite': 10000,
      'img': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80',
      'description': 'La plus grande foire commerciale d\'Afrique de l\'Ouest.',
    },
    {
      'id': 4, 'nom': 'Nuit Hip-Hop Bamako',
      'categorie': 'Concert', 'date': '01 Août 2026', 'heure': '21h00',
      'localisation': 'Stade Modibo Keïta, Bamako', 'tarif': '7 500',
      'capacite': 8000,
      'img': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800&q=80',
      'description': 'Les meilleurs artistes hip-hop maliens et invités spéciaux.',
    },
    {
      'id': 5, 'nom': 'Exposition Artisanat & Textile',
      'categorie': 'Exposition', 'date': '25 Juil 2026', 'heure': '10h00',
      'localisation': 'Maison des Artisans, Bamako', 'tarif': '2 000',
      'capacite': 500,
      'img': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'description': 'Bogolan, bijoux, sculptures et vêtements made in Mali.',
    },
    {
      'id': 6, 'nom': 'Match de Gala – Étoiles du Mali',
      'categorie': 'Sport', 'date': '10 Août 2026', 'heure': '16h00',
      'localisation': 'Stade du 26 Mars, Bamako', 'tarif': '3 000',
      'capacite': 50000,
      'img': 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80',
      'description': 'Match amical entre les légendes du football malien.',
    },
  ];

  void _loadStaticData() {
    _categories = [
      {'idCategory': 'all', 'nom': 'Tous'},
      {'idCategory': '1', 'nom': 'Concert'},
      {'idCategory': '2', 'nom': 'Festival'},
      {'idCategory': '3', 'nom': 'Foire'},
      {'idCategory': '4', 'nom': 'Exposition'},
      {'idCategory': '5', 'nom': 'Sport'},
    ];
    _events = List.from(_allStaticEvents);
    if (mounted) {
      setState(() { _isLoading = false; _isCatLoading = false; });
    }
  }

  void _filterStaticEvents(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _events = categoryId == 'all'
          ? List.from(_allStaticEvents)
          : _allStaticEvents.where((e) {
              final cat = _categories.firstWhere(
                (c) => c['idCategory'] == categoryId,
                orElse: () => <String, dynamic>{},
              );
              return cat.isNotEmpty && e['categorie'] == cat['nom'];
            }).toList();
    });
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
            'Événements',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Découvrez les événements à venir',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<Map<String, dynamic>> filters = _isCatLoading
        ? [{'idCategory': 'all', 'nom': 'Tous'}]
        : _categories;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 14),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (_, i) {
            final cat = filters[i];
            final catId = cat['idCategory'].toString();
            final selected = _selectedCategory == catId;
            return GestureDetector(
              onTap: () => _filterStaticEvents(catId),
              // onTap: () { setState(() => _selectedCategory = catId); _loadEvents(categoryId: catId); }, // TODO: restore when API is ready
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? _primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selected ? _primary : const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  cat['nom'] as String,
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
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2967FF)));
    }
    if (_events.isEmpty) {
      return const Center(
        child: Text('Aucun événement trouvé',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _events.length,
      itemBuilder: (_, i) => EventCard(event: _events[i]),
    );
  }
}

// ─── Event Card ───────────────────────────────────────────────────────────────

class EventCard extends StatelessWidget {
  final dynamic event;
  const EventCard({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    final category = event['categorie'] ?? event['category'] ?? '';

    return GestureDetector(
      onTap: () => Get.to(
        DetailDivertissement(evenement: event),
        transition: Transition.downToUp,
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
            // Image with overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    event['img'] ?? '',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 180,
                      color: const Color(0xFF1A1A2E),
                      child: const Icon(Icons.music_note_rounded,
                          size: 48, color: Color(0xFF2967FF)),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                          height: 180, color: const Color(0xFFF5F7FA));
                    },
                  ),
                ),
                // Dark overlay at bottom of image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(0)),
                    ),
                  ),
                ),
                // Category badge
                if (category.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2967FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Title on image
                Positioned(
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Text(
                    event['nom'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(
                        event['date'] ?? '',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B7280)),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(
                        event['heure'] ?? event['time'] ?? '',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(
                        event['localisation'] ?? event['lieu'] ?? '',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${event['tarif'] ?? '---'} ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2967FF),
                                ),
                              ),
                              const TextSpan(
                                text: 'Fcfa',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF9CA3AF)),
                              ),
                            ]),
                          ),
                          if (event['capacite'] != null) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.people_outline,
                                size: 14, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 4),
                            Text(
                              '${event['capacite']}',
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2967FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.confirmation_number_outlined,
                                color: Colors.white, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'Acheter',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
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
}

// ─── Legacy wrapper (kept for backward compatibility) ─────────────────────────

class DivertissementScreen extends StatelessWidget {
  const DivertissementScreen({super.key});

  @override
  Widget build(BuildContext context) => const EventsTab();
}
