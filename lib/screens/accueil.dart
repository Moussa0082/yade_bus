import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/screens/bus.dart';
import 'package:yade_bus/screens/cancel_voyage.dart';
import 'package:yade_bus/screens/map.dart';
import 'package:yade_bus/screens/reporter_voyage.dart';
import 'package:yade_bus/widgets/my_reservation_tab.dart';
import 'package:yade_bus/widgets/new_voyage_form.dart';

// ─── Home Tab ────────────────────────────────────────────────────────────────

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  static const _primary = Color(0xFF2967FF);
  static const _orange = Color(0xFFF59E0B);

  String _tripType = 'allerSimple';
  int _selectedSearchTab = 0; // 0=Billets, 1=Colis

  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _dateController = TextEditingController();
  final _colisFromController = TextEditingController();
  final _colisToController = TextEditingController();
  final _colisDateController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _colisFromController.dispose();
    _colisToController.dispose();
    _colisDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
      ctrl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  // Popular routes (static, matches web app)
  final List<Map<String, String>> _popularRoutes = const [
    {'from': 'Bamako', 'to': 'Dakar', 'duration': '14h', 'rating': '4.5', 'departures': '3 départs/jour', 'price': '15 000'},
    {'from': 'Bamako', 'to': 'Sikasso', 'duration': '5h', 'rating': '4.7', 'departures': '5 départs/jour', 'price': '7 500'},
    {'from': 'Bamako', 'to': 'Abidjan', 'duration': '18h', 'rating': '4.3', 'departures': '2 départs/jour', 'price': '20 000'},
    {'from': 'Bamako', 'to': 'Ouagadougou', 'duration': '12h', 'rating': '4.6', 'departures': '4 départs/jour', 'price': '12 000'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(context),
          _buildSearchCard(context),
          const SizedBox(height: 20),
          _buildPaymentMethods(),
          const SizedBox(height: 16),
          _buildBusUrbainCard(),
          const SizedBox(height: 24),
          _buildWhyYadeBus(),
          const SizedBox(height: 24),
          _buildFeatureCards(),
          const SizedBox(height: 28),
          _buildPopularRoutes(),
          const SizedBox(height: 28),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background image with overlay
        SizedBox(
          height: 220,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/homebg.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 36, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Planifiez votre voyage',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '+2 500 destinations en Afrique',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Transform.translate(
        offset: const Offset(0, -1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Tab row
              _buildSearchTabs(),
              // Form content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: _selectedSearchTab == 0
                    ? _buildBilletsForm()
                    : _buildColisForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBilletsForm() {
    return Column(
      children: [
        Row(
          children: [
            _radioChip('allerSimple', 'Aller simple'),
            const SizedBox(width: 20),
            _radioChip('allerRetour', 'Aller-retour'),
          ],
        ),
        const SizedBox(height: 14),
        _searchField(
            icon: Icons.location_on_outlined,
            iconColor: _primary,
            hint: 'Ville de départ',
            controller: _fromController),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: _primary.withValues(alpha: 0.4), width: 1.5),
                color: Colors.white,
              ),
              child: const Icon(Icons.swap_vert_rounded,
                  color: _primary, size: 18),
            ),
          ),
        ),
        _searchField(
            icon: Icons.location_on,
            iconColor: _orange,
            hint: 'Destination',
            controller: _toController),
        const SizedBox(height: 10),
        _searchField(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF6B7280),
            hint: 'jj/mm/aaaa',
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context, _dateController),
            trailing: const Icon(Icons.calendar_month_outlined,
                size: 20, color: Color(0xFF6B7280))),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Get.to(const NewVoyageForm(),
                transition: Transition.rightToLeftWithFade),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Rechercher',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildColisForm() {
    return Column(
      children: [
        _searchField(
            icon: Icons.location_on_outlined,
            iconColor: _primary,
            hint: 'Départ du colis',
            controller: _colisFromController),
        const SizedBox(height: 10),
        _searchField(
            icon: Icons.location_on,
            iconColor: _orange,
            hint: 'Destination du colis',
            controller: _colisToController),
        const SizedBox(height: 10),
        _searchField(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF6B7280),
            hint: 'jj/mm/aaaa',
            controller: _colisDateController,
            readOnly: true,
            onTap: () => _selectDate(context, _colisDateController),
            trailing: const Icon(Icons.calendar_month_outlined,
                size: 20, color: Color(0xFF6B7280))),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEA7C1F)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Envoyer un colis',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          _searchTabItem(0, Icons.search_rounded, 'Billets'),
          _searchTabItem(1, Icons.inventory_2_outlined, 'Colis'),
        ],
      ),
    );
  }

  Widget _searchTabItem(int index, IconData icon, String label) {
    final selected = _selectedSearchTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSearchTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? _primary : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? _primary : const Color(0xFF9CA3AF),
                  size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? _primary : const Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioChip(String value, String label) {
    final selected = _tripType == value;
    return GestureDetector(
      onTap: () => setState(() => _tripType = value),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: selected ? _primary : const Color(0xFF9CA3AF),
                  width: 2),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: _primary, shape: BoxShape.circle),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected ? const Color(0xFF111827) : const Color(0xFF6B7280),
              fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField({
    required IconData icon,
    required Color iconColor,
    required String hint,
    Widget? trailing,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              style: const TextStyle(
                color: Color(0xFF1A1A2E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'Paiements acceptés :',
            style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(width: 10),
          _paymentPill('Orange Money', const Color(0xFFF97316)),
          const SizedBox(width: 8),
          _paymentPill('Wave', const Color(0xFF2967FF)),
        ],
      ),
    );
  }

  Widget _paymentPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        color: color.withValues(alpha: 0.06),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBusUrbainCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Get.to(const Bus(), transition: Transition.rightToLeftWithFade),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2967FF), Color(0xFF1A56DB)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_bus_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bus Urbain',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Carte IC, lignes & arrêts en temps réel',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhyYadeBus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pourquoi YadeBus ?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _whyCard(
                  icon: Icons.wallet_outlined,
                  iconColor: const Color(0xFF2967FF),
                  iconBg: const Color(0xFFEFF6FF),
                  title: 'Meilleurs tarifs',
                  subtitle: 'Prix imbattables sur tous vos billets',
                  titleColor: const Color(0xFF2967FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _whyCard(
                  icon: Icons.weekend_outlined,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFFFBEB),
                  title: 'Confort garanti',
                  subtitle: 'WiFi gratuit et nourriture à bord',
                  titleColor: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _whyCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Color titleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _featureCard(
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFF16A34A),
              bg: const Color(0xFFF0FDF4),
              title: '+2 500 destinations',
              subtitle: 'Dans plus de 35 pays d\'Afrique',
              titleColor: const Color(0xFF16A34A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _featureCard(
              icon: Icons.apartment_outlined,
              iconColor: const Color(0xFFE11D48),
              bg: const Color(0xFFFFF1F2),
              title: 'Logements & Voitures',
              subtitle: 'Qualité et disponibilité garanties',
              titleColor: const Color(0xFFE11D48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required IconData icon,
    required Color iconColor,
    required Color bg,
    required String title,
    required String subtitle,
    required Color titleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: titleColor.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trajets populaires',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(const NewVoyageForm(),
                    transition: Transition.rightToLeftWithFade),
                child: const Text(
                  'Voir tout',
                  style: TextStyle(fontSize: 13, color: Color(0xFF2967FF)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...(_popularRoutes.map((route) => _buildRouteCard(route))),
      ],
    );
  }

  Widget _buildRouteCard(Map<String, String> route) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFF2967FF), size: 10),
                    const SizedBox(width: 6),
                    Text(
                      route['from']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward_rounded,
                          size: 16, color: Color(0xFF9CA3AF)),
                    ),
                    const Icon(Icons.circle, color: Color(0xFFF59E0B), size: 10),
                    const SizedBox(width: 6),
                    Text(
                      route['to']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 13, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(route['duration']!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(width: 10),
                    const Icon(Icons.star_rounded,
                        size: 13, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 2),
                    Text(route['rating']!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(width: 10),
                    Text(route['departures']!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                route['price']!,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2967FF),
                ),
              ),
              const Text(
                'Fcfa',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Bus Tab ─────────────────────────────────────────────────────────────────

class BusTab extends StatefulWidget {
  const BusTab({super.key});

  @override
  State<BusTab> createState() => _BusTabState();
}

class _BusTabState extends State<BusTab> {
  static const _primary = Color(0xFF2967FF);

  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _subTabs = [
    {'title': 'Billet', 'icon': Icons.travel_explore_rounded},
    {'title': 'Annuler', 'icon': Icons.cancel_outlined},
    {'title': 'Reporter', 'icon': Icons.edit_calendar_rounded},
    {'title': 'Agences', 'icon': Icons.location_on_rounded},
    {'title': 'Réservations', 'icon': Icons.receipt_long_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBusHeader(context),
        _buildSubTabBar(),
        Expanded(
          child: _buildSubTabContent(),
        ),
      ],
    );
  }

  Widget _buildBusHeader(BuildContext context) {
    return Container(
      color: _primary,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rechercher un trajet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_subTabs.length, (index) {
            final selected = _selectedTabIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? _primary : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _primary : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _subTabs[index]['icon'] as IconData,
                      color: selected ? Colors.white : const Color(0xFF6B7280),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _subTabs[index]['title'] as String,
                      style: TextStyle(
                        color: selected ? Colors.white : const Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSubTabContent() {
    // Import lazy to avoid circular deps — use the existing tab pages
    final pages = _getTabPages();
    return pages[_selectedTabIndex];
  }

  List<Widget> _getTabPages() {
    return [
      const NewVoyageForm(),
      const CancelVoyage(),
      const ReporterVoyage(),
      MapScreen(),
      TabbedPage(),
    ];
  }

}
