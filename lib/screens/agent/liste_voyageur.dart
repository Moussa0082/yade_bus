import 'package:flutter/material.dart';

class ListeVoyageursPage extends StatefulWidget {
  const ListeVoyageursPage({super.key});

  @override
  State<ListeVoyageursPage> createState() => _ListeVoyageursPageState();
}

class _ListeVoyageursPageState extends State<ListeVoyageursPage> {
  TextEditingController dateController = TextEditingController();

  List<Map<String, dynamic>> voyages = [
    {
      'depart': 'Bamako',
      'destination': 'Ségou',
      'date': '2024-06-01',
      'voyageurs': [
        {'nom': 'Alice', 'siege': 'A1'},
        {'nom': 'Bob', 'siege': 'B2'},
        {'nom': 'Charlie', 'siege': 'C3'},
      ],
    },
    {
      'depart': 'Ségou',
      'destination': 'Sikasso',
      'date': '2024-06-02',
      'voyageurs': [
        {'nom': 'David', 'siege': 'D4'},
        {'nom': 'Eve', 'siege': 'E5'},
      ],
    },
    {
      'depart': 'Sikasso',
      'destination': 'Kayes',
      'date': '2024-06-03',
      'voyageurs': [
        {'nom': 'Frank', 'siege': 'F6'},
        {'nom': 'Grace', 'siege': 'G7'},
        {'nom': 'Hannah', 'siege': 'H8'},
        {'nom': 'Ivy', 'siege': 'I9'},
      ],
    },
  ];

  String? selectedDepart;
  String? selectedDestination;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2100),
      helpText: 'Sélectionner une date ',
      cancelText: 'Annuler',
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != currentDate && picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // ── Custom top bar ──────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 12,
              left: 8,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF111827),
                    size: 20,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Liste des voyageurs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Blue header banner ──────────────────────────────────────
          Container(
            width: double.infinity,
            color: const Color(0xFF2967FF),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: const Text(
              'Filtrez par trajet et date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ── Filter card ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF111827).withValues(alpha: 0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Departure dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.directions_bus_rounded,
                        color: Color(0xFF2967FF),
                        size: 20,
                      ),
                      hintText: 'Départ',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF2967FF), width: 1.5),
                      ),
                    ),
                    value: selectedDepart,
                    style: const TextStyle(
                        color: Color(0xFF111827), fontSize: 14),
                    dropdownColor: Colors.white,
                    items: voyages.map((voyage) {
                      return DropdownMenuItem<String>(
                        value: voyage['depart'] as String,
                        child: Text(voyage['depart'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepart = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Destination dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF2967FF),
                        size: 20,
                      ),
                      hintText: 'Destination',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF2967FF), width: 1.5),
                      ),
                    ),
                    value: selectedDestination,
                    style: const TextStyle(
                        color: Color(0xFF111827), fontSize: 14),
                    dropdownColor: Colors.white,
                    items: voyages.map((voyage) {
                      return DropdownMenuItem<String>(
                        value: voyage['destination'] as String,
                        child: Text(voyage['destination'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDestination = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Date field
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateController,
                        style: const TextStyle(
                            color: Color(0xFF111827), fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFF2967FF),
                            size: 20,
                          ),
                          hintText: 'Sélectionner une date',
                          hintStyle:
                              const TextStyle(color: Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: const Color(0xFFF5F7FA),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF2967FF), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Voyager list ────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: voyages
                  .where((voyage) =>
                      (selectedDepart == null ||
                          voyage['depart'] == selectedDepart) &&
                      (selectedDestination == null ||
                          voyage['destination'] == selectedDestination) &&
                      (selectedDate == null ||
                          voyage['date'] ==
                              "${selectedDate!.toLocal()}".split(' ')[0]))
                  .fold<int>(
                      0,
                      (sum, voyage) =>
                          sum + (voyage['voyageurs'].length as int)),
              itemBuilder: (_, voyageurIndex) {
                final filteredVoyages = voyages
                    .where((voyage) =>
                        (selectedDepart == null ||
                            voyage['depart'] == selectedDepart) &&
                        (selectedDestination == null ||
                            voyage['destination'] == selectedDestination) &&
                        (selectedDate == null ||
                            voyage['date'] ==
                                "${selectedDate!.toLocal()}".split(' ')[0]))
                    .toList();

                if (filteredVoyages.isEmpty) {
                  return const SizedBox.shrink();
                }

                int currentVoyageIndex = 0;
                num currentVoyageurIndex = voyageurIndex;

                while (currentVoyageurIndex >=
                    filteredVoyages[currentVoyageIndex]['voyageurs'].length) {
                  currentVoyageurIndex -=
                      filteredVoyages[currentVoyageIndex]['voyageurs'].length;
                  currentVoyageIndex++;
                }

                final voyage = filteredVoyages[currentVoyageIndex];
                final voyageur =
                    voyage['voyageurs'][currentVoyageurIndex];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF111827).withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2967FF),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Name + destination
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voyageur['nom'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Color(0xFF9CA3AF),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    voyage['destination'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Seat chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            voyageur['siege'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2967FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
