import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/constantes.dart';
import '../screens/voyage.dart';

class NewVoyageForm extends StatefulWidget {
  const NewVoyageForm({super.key});

  @override
  State<NewVoyageForm> createState() => _NewVoyageFormState();
}

class _NewVoyageFormState extends State<NewVoyageForm> {
  static const _primary = Color(0xFF2967FF);
  static const _orange = Color(0xFFF59E0B);

  final TextEditingController dateAllerController = TextEditingController();
  final TextEditingController dateRetourController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? idDepart;
  String? nomDepart;
  String? nomDest;
  String? idDest;
  int? id;
  int? idD;
  String? voyageType = 'allerSimple';
  DateTime? retourDate;

  List<Map<String, dynamic>> departList = [];
  List<Map<String, dynamic>> destinationList = [];

  @override
  void initState() {
    super.initState();
    fetchZoneDepart();
  }

  @override
  void dispose() {
    dateAllerController.dispose();
    dateRetourController.dispose();
    super.dispose();
  }

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

  Future<List<Map<String, dynamic>>> fetchZoneDestination(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$apiUrl/zone_destination.php?idDepart=$id'));
      if (response.statusCode == 200) {
        final List<dynamic> levelsJson = json.decode(response.body);
        destinationList = levelsJson.cast<Map<String, dynamic>>();
        return destinationList;
      }
    } catch (_) {}
    return [];
  }

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
          colorScheme: const ColorScheme.light(primary: Color(0xFF2967FF)),
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
          colorScheme: const ColorScheme.light(primary: Color(0xFF2967FF)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        retourDate = picked;
        dateRetourController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Widget _buildAutocomplete({
    required List<Map<String, dynamic>> options,
    required String hint,
    required IconData icon,
    required Color iconColor,
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
            e['libelle']
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
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.white, width: 1.5),
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
                separatorBuilder: (_, __) => const Divider(
                    height: 1, color: Color(0xFFF3F4F6)),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Blue search area
          Container(
            color: _primary,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip type chips
                  Row(
                    children: [
                      _tripChip('Aller simple', voyageType == 'allerSimple',
                          () => setState(() => voyageType = 'allerSimple')),
                      const SizedBox(width: 10),
                      _tripChip('Aller retour', voyageType == 'allerRetour',
                          () => setState(() => voyageType = 'allerRetour')),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Depart
                  _buildAutocomplete(
                    options: departList,
                    hint: 'Ville de départ',
                    icon: Icons.location_on_rounded,
                    iconColor: Colors.white70,
                    validator: (val) => (val == null || val.isEmpty)
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
                          setState(() => destinationList = list);
                        });
                      }
                    },
                  ),

                  // Swap button
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5)),
                        ),
                        child: const Icon(Icons.swap_vert_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),

                  // Destination
                  _buildAutocomplete(
                    options: destinationList,
                    hint: 'Destination',
                    icon: Icons.location_on_rounded,
                    iconColor: _orange,
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Veuillez choisir une ville de destination'
                        : null,
                    onSelected: (selection) {
                      final el = destinationList.firstWhere(
                        (e) => e['libelle'] == selection,
                        orElse: () => <String, dynamic>{},
                      );
                      if (el.isNotEmpty) {
                        setState(() => nomDest = selection);
                        idDest = el['idLevel'].toString();
                        idD = int.tryParse(idDest!);
                      }
                    },
                  ),
                  const SizedBox(height: 14),

                  // Date aller + search button row
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
                                    color: Colors.white60, fontSize: 14),
                                suffixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white70,
                                    size: 20),
                                filled: true,
                                fillColor:
                                    Colors.white.withValues(alpha: 0.15),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.white
                                          .withValues(alpha: 0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.white
                                          .withValues(alpha: 0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Orange search button
                      GestureDetector(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            Get.to(
                              VoyageScreen(
                                idDepart: id,
                                idDest: idD,
                                dateDepart: dateAllerController.text,
                                dateRetour: dateRetourController.text,
                                nomDepart: nomDepart!,
                                nomDest: nomDest!,
                                idVoyageRetour: idD,
                                type: voyageType == 'allerSimple' ? 0 : 1,
                              ),
                              transition: Transition.rightToLeftWithFade,
                            );
                          }
                        },
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.search_rounded,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),

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
                            fillColor: Colors.white.withValues(alpha: 0.15),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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

          // Results hint
          Container(
            color: const Color(0xFFF5F7FA),
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.search_rounded,
                      size: 56, color: Color(0xFFD1D5DB)),
                  SizedBox(height: 16),
                  Text(
                    'Remplissez le formulaire\net appuyez sur Rechercher',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF9CA3AF), height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
