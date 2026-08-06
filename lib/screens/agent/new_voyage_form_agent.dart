import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constant/constantes.dart';
import '../../controller/deeplink_controller.dart';
import '../voyage.dart';

class NewVoyageFormAgent extends StatefulWidget {
  const NewVoyageFormAgent({super.key});

  @override
  State<NewVoyageFormAgent> createState() => _NewVoyageFormAgentState();
}

class _NewVoyageFormAgentState extends State<NewVoyageFormAgent> {
  static const _primary = Color(0xFF2967FF);
  static const _orange = Color(0xFFF59E0B);

  final TextEditingController dateAllerController = TextEditingController();
  final TextEditingController dateRetourController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? idDepart;
  String? idDest;
  String? nomDepart;
  String? nomDest;
  int? id;
  int? idD;
  String? detectedCountryCode;
  String? voyageType = 'allerSimple';
  DateTime? retourDate;

  List<Map<String, dynamic>> departList = [];
  List<Map<String, dynamic>> destinationList = [];

  // ── Location ──────────────────────────────────────────────────────────────

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      if (placemarks.isNotEmpty && mounted) {
        final Placemark place = placemarks[0];
        setState(() {
          detectedCountryCode = place.isoCountryCode ?? '';
        });
      }
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  // ── Data fetching ─────────────────────────────────────────────────────────

  Future<void> fetchZoneDepart() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/zone_depart.php'));
      if (response.statusCode == 200) {
        final List<dynamic> levelsJson = json.decode(response.body);
        if (mounted) {
          setState(() {
            departList = levelsJson.cast<Map<String, dynamic>>();
          });
        }
      }
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> fetchZoneDestination(int depId) async {
    try {
      final response = await http
          .get(Uri.parse('$apiUrl/zone_destination.php?idDepart=$depId'));
      if (response.statusCode == 200) {
        final List<dynamic> levelsJson = json.decode(response.body);
        destinationList = levelsJson.cast<Map<String, dynamic>>();
        return destinationList;
      }
    } catch (_) {}
    return [];
  }

  // ── Date pickers ──────────────────────────────────────────────────────────

  Future<void> _selectDateAller(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      helpText: 'Sélectionner une date',
      cancelText: 'Annuler',
      confirmText: 'OK',
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dateAllerController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _selectDateRetour(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      cancelText: 'Annuler',
      confirmText: 'OK',
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        retourDate = picked;
        dateRetourController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    fetchZoneDepart();
  }

  @override
  void dispose() {
    dateAllerController.dispose();
    dateRetourController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _tripChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _primary : Colors.white,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAutocomplete({
    required List<Map<String, dynamic>> options,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String) onSelected,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return options.map((e) => e['libelle'] as String);
        }
        final filtered = options.where((e) =>
            e['libelle'] != null &&
            (e['libelle'] as String)
                .toLowerCase()
                .contains(value.text.toLowerCase()));
        if (filtered.isEmpty) return ['Aucun résultat'];
        return filtered.map((e) => e['libelle'] as String);
      },
      fieldViewBuilder: (ctx, ctrl, focus, onSubmit) {
        return TextFormField(
          validator: validator,
          controller: ctrl,
          focusNode: focus,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white70, size: 20),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.orangeAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.orangeAccent, width: 1.5),
            ),
          ),
        );
      },
      optionsViewBuilder: (ctx, onSel, opts) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.88,
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: opts.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                itemBuilder: (ctx, i) {
                  final opt = opts.elementAt(i);
                  return ListTile(
                    dense: true,
                    leading: Icon(icon, color: _primary, size: 18),
                    title: Text(opt,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF111827))),
                    onTap: () => onSel(opt),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: onSelected,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    Get.put(DeepLinkController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // ── Custom header ──────────────────────────────────────────────────
          Container(
            color: _primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 4),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Réserver un billet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pour un client',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable body ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Blue form section ──────────────────────────────────────
                  Container(
                    color: _primary,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trip type chips
                          Row(
                            children: [
                              _tripChip(
                                'Aller simple',
                                voyageType == 'allerSimple',
                                () => setState(
                                    () => voyageType = 'allerSimple'),
                              ),
                              const SizedBox(width: 10),
                              _tripChip(
                                'Aller retour',
                                voyageType == 'allerRetour',
                                () => setState(
                                    () => voyageType = 'allerRetour'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Departure autocomplete
                          _buildAutocomplete(
                            options: departList,
                            hint: 'Ville de départ',
                            icon: Icons.location_on_rounded,
                            validator: (val) =>
                                (val == null || val.isEmpty)
                                    ? 'Veuillez choisir une ville de départ'
                                    : null,
                            onSelected: (selection) {
                              final el = departList.firstWhere(
                                (e) => e['libelle'] == selection,
                                orElse: () => <String, dynamic>{},
                              );
                              if (el.isNotEmpty) {
                                idDepart = el['idLevel'].toString();
                                setState(() {
                                  nomDepart = selection;
                                  id = int.tryParse(idDepart!);
                                  destinationList = [];
                                });
                                fetchZoneDestination(id!).then((list) {
                                  if (mounted) {
                                    setState(() => destinationList = list);
                                  }
                                });
                              }
                            },
                          ),

                          // Swap icon
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Colors.white.withValues(alpha: 0.2),
                                  border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.5)),
                                ),
                                child: const Icon(
                                    Icons.swap_vert_rounded,
                                    color: Colors.white,
                                    size: 18),
                              ),
                            ),
                          ),

                          // Destination autocomplete
                          _buildAutocomplete(
                            options: destinationList,
                            hint: 'Destination',
                            icon: Icons.location_on_rounded,
                            validator: (val) =>
                                (val == null || val.isEmpty)
                                    ? 'Veuillez choisir une ville de destination'
                                    : null,
                            onSelected: (selection) {
                              final el = destinationList.firstWhere(
                                (e) => e['libelle'] == selection,
                                orElse: () => <String, dynamic>{},
                              );
                              if (el.isNotEmpty) {
                                idDest = el['idLevel'].toString();
                                setState(() {
                                  nomDest = selection;
                                  idD = int.tryParse(idDest!);
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 14),

                          // Date aller + orange search button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDateAller(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: dateAllerController,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Icons.calendar_today_rounded,
                                            color: Colors.white70,
                                            size: 20),
                                        hintText: 'Date de départ',
                                        hintStyle: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 14),
                                        suffixIcon: const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.white70,
                                            size: 20),
                                        filled: true,
                                        fillColor: Colors.white
                                            .withValues(alpha: 0.15),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.white
                                                  .withValues(alpha: 0.3)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.white
                                                  .withValues(alpha: 0.3)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Orange search button (54×54)
                              GestureDetector(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    Get.to(
                                      VoyageScreen(
                                        idDepart: id,
                                        idDest: idD,
                                        dateDepart: dateAllerController.text,
                                        dateRetour: dateRetourController.text,
                                        nomDepart: nomDepart ?? '',
                                        nomDest: nomDest ?? '',
                                        idVoyageRetour: idD,
                                        type: voyageType == 'allerSimple'
                                            ? 0
                                            : 1,
                                      ),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                    );
                                  }
                                },
                                child: Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: _orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.search_rounded,
                                      color: Colors.white, size: 24),
                                ),
                              ),
                            ],
                          ),

                          // Date retour (aller retour only)
                          if (voyageType == 'allerRetour') ...[
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () => _selectDateRetour(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: dateRetourController,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.white70,
                                        size: 20),
                                    hintText: 'Date de retour',
                                    hintStyle: const TextStyle(
                                        color: Colors.white60, fontSize: 14),
                                    filled: true,
                                    fillColor:
                                        Colors.white.withValues(alpha: 0.15),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.white
                                              .withValues(alpha: 0.3)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.white
                                              .withValues(alpha: 0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ── Results hint area ──────────────────────────────────────
                  Container(
                    color: const Color(0xFFF5F7FA),
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_rounded,
                            size: 56, color: Color(0xFFD1D5DB)),
                        SizedBox(height: 16),
                        Text(
                          'Remplissez le formulaire\net appuyez sur Rechercher',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                            height: 1.6,
                          ),
                        ),
                      ],
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
}
