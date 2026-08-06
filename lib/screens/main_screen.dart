import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/screens/accueil.dart';
import 'package:yade_bus/screens/divertissement.dart';
import 'package:yade_bus/screens/profil_page.dart';
import 'package:yade_bus/widgets/logements_screen.dart';
import 'package:yade_bus/widgets/voitures_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  static const _primary = Color(0xFF2967FF);
  static const _gray = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: const [
                HomeTab(),
                BusTab(),
                LogementsScreen(),
                VoituresScreen(),
                EventsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, top + 10, 16, 10),
      child: Row(
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            height: 38,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          // Bell icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF6B7280), size: 26),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Person icon
          GestureDetector(
            onTap: () =>
                Get.to(const ProfilPage(), transition: Transition.rightToLeft),
            child: const Icon(Icons.person_outline_rounded,
                color: Color(0xFF6B7280), size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Accueil'),
              _navItem(1, Icons.directions_bus_rounded,
                  Icons.directions_bus_outlined, 'Bus'),
              _navItem(2, Icons.apartment_rounded, Icons.apartment_outlined,
                  'Logements'),
              _navItem(3, Icons.directions_car_rounded,
                  Icons.directions_car_outlined, 'Voitures'),
              _navItem(4, Icons.calendar_month_rounded,
                  Icons.calendar_month_outlined, 'Events'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? _primary : _gray,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _primary : _gray,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
