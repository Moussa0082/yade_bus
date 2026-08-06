import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/bus.dart';
import 'package:yade_bus/screens/divertissement.dart';
import 'package:yade_bus/widgets/location_tab.dart';
import 'package:yade_bus/widgets/slider_comp.dart';
import 'package:yade_bus/widgets/voyage_tab.dart';

import 'login/login.dart';

class ServiceCardModel {
  final String title;
  final IconData icon;
  final Widget widget;
  final Color color;

  ServiceCardModel({
    required this.title,
    required this.icon,
    required this.widget,
    required this.color,
  });
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isSwapped = false;
  String _tripType = 'allerSimple';

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  final List<ServiceCardModel> services = [
    ServiceCardModel(
      title: 'Voyage',
      icon: CupertinoIcons.tickets_fill,
      widget: const VoyageTab(),
      color: Color(0xFF2967FF),
    ),
    ServiceCardModel(
      title: 'Location',
      icon: Icons.directions_car_rounded,
      widget: const LocationTab(),
      color: Color(0xFF2967FF),
    ),
    ServiceCardModel(
      title: 'Events',
      icon: FeatherIcons.music,
      widget: const DivertissementScreen(),
      color: Color(0xFF2967FF),
    ),
    ServiceCardModel(
      title: 'Bus',
      icon: Icons.directions_bus_rounded,
      widget: const Bus(),
      color: Color(0xFF2967FF),
    ),
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _swapInputs() {
    setState(() {
      _isSwapped = !_isSwapped;
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildServiceCards(),
                  const SizedBox(height: 24),
                  _buildSearchCard(context),
                  const SizedBox(height: 28),
                  _buildPartnersSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2967FF), Color(0xFF1A56DB)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/logo.png', height: 36),
                  const SizedBox(width: 10),
                  const Text(
                    'YADE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () =>
                    Get.to(const LoginPage(), transition: Transition.leftToRight),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.login_rounded, color: Colors.white, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Connexion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Bienvenue !',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            'Où souhaitez-vous aller ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nos services',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: services.map((service) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(service.widget),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: service.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            service.icon,
                            color: service.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rechercher un billet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),

            // Type aller/retour selector
            Row(
              children: [
                _buildTripTypeChip('Aller simple', _tripType == 'allerSimple',
                    () => setState(() => _tripType = 'allerSimple')),
                const SizedBox(width: 10),
                _buildTripTypeChip('Aller retour', _tripType == 'allerRetour',
                    () => setState(() => _tripType = 'allerRetour')),
              ],
            ),
            const SizedBox(height: 16),

            // From field
            _buildInputField(
              controller: _fromController,
              hint: 'Ville de départ',
              icon: Icons.trip_origin_rounded,
              iconColor: primaryColor,
            ),
            const SizedBox(height: 4),

            // Swap button row
            Center(
              child: GestureDetector(
                onTap: _swapInputs,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: primaryColor.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Icon(Icons.swap_vert_rounded,
                      color: primaryColor, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // To field
            _buildInputField(
              controller: _toController,
              hint: 'Ville de destination',
              icon: Icons.location_on_rounded,
              iconColor: primaryColor,
            ),
            const SizedBox(height: 14),

            // Date picker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date de départ',
                          style: TextStyle(
                              color: Color(0xFF9CA3AF), fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('dd MMM yyyy', 'fr').format(_selectedDate),
                          style: const TextStyle(
                            color: Color(0xFF1A1A2E),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF9CA3AF), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Search button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Rechercher un billet',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Color(0xFF1A1A2E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryColor : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? primaryColor : const Color(0xFFE5E7EB),
          ),
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
  }

  Widget _buildPartnersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nos partenaires',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          AgencySlider(),
        ],
      ),
    );
  }
}
