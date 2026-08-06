import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/widgets/location_maison.dart';
import 'package:yade_bus/widgets/location_voiture.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Maison',
      'icon': Icons.home_rounded,
      'page': LocationMaison(),
      'color': const Color(0xFF2967FF),
    },
    {
      'title': 'Voiture',
      'icon': Icons.directions_car_rounded,
      'page': LocationScreen(),
      'color': const Color(0xFF2967FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2967FF), Color(0xFF1A56DB)],
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, top + 14, 20, 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: List.generate(_pages.length, (index) {
                final selected = _selectedIndex == index;
                final color = _pages[index]['color'] as Color;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                          right: index < _pages.length - 1 ? 10 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: selected ? color : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? color
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _pages[index]['icon'] as IconData,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF6B7280),
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            _pages[index]['title'] as String,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF6B7280),
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(child: _pages[_selectedIndex]['page'] as Widget),
        ],
      ),
    );
  }
}
