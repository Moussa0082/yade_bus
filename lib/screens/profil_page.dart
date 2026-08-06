import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yade_bus/provider/AuthProvider.dart';
import 'package:yade_bus/screens/login/login.dart';
import 'package:yade_bus/screens/profil_pages.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  static const _primary = Color(0xFF2967FF);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top bar
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16, top + 10, 16, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: Color(0xFF374151)),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Mon profil',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                ],
              ),
            ),

            // Blue profile header
            Container(
              color: _primary,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 60),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null
                              ? '${user.prenom} ${user.nom}'.trim()
                              : 'Utilisateur YadeBus',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (user != null)
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  color: Colors.white70, size: 13),
                              const SizedBox(width: 4),
                              Text(user.telephone,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        const SizedBox(height: 2),
                        if (user != null)
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded,
                                  color: Colors.white70, size: 13),
                              const SizedBox(width: 4),
                              Text(user.username,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats card (floating)
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem('12', 'Voyages', const Color(0xFF2967FF)),
                      _divider(),
                      _statItem('5', 'Colis', const Color(0xFFF59E0B)),
                      _divider(),
                      _statItem('3', 'Locations', const Color(0xFF16A34A)),
                    ],
                  ),
                ),
              ),
            ),

            // Menu items
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Transform.translate(
                offset: const Offset(0, -22),
                child: Column(
                  children: [
                    _menuItem(Icons.confirmation_number_outlined,
                        const Color(0xFF2967FF),
                        const Color(0xFFEFF6FF),
                        'Mes réservations',
                        'Billets et voyages',
                        () => Get.to(const MesReservationsPage(),
                            transition: Transition.rightToLeft)),
                    _menuItem(Icons.inventory_2_outlined,
                        const Color(0xFFF59E0B),
                        const Color(0xFFFFFBEB),
                        'Mes colis',
                        'Suivi et historique',
                        () => Get.to(const MesReservationsPage(initialTab: 1),
                            transition: Transition.rightToLeft)),
                    _menuItem(Icons.apartment_outlined,
                        const Color(0xFF16A34A),
                        const Color(0xFFF0FDF4),
                        'Mes logements',
                        'Réservations d\'hébergement',
                        () => Get.to(const MesReservationsPage(initialTab: 2),
                            transition: Transition.rightToLeft)),
                    _menuItem(Icons.directions_car_outlined,
                        const Color(0xFF7C3AED),
                        const Color(0xFFF5F3FF),
                        'Mes locations',
                        'Voitures louées',
                        () => Get.to(const MesReservationsPage(initialTab: 3),
                            transition: Transition.rightToLeft)),
                    _menuItem(Icons.notifications_outlined,
                        const Color(0xFFE11D48),
                        const Color(0xFFFFF1F2),
                        'Notifications',
                        'Alertes et promotions',
                        () => Get.to(const NotificationsPage(),
                            transition: Transition.rightToLeft)),
                    _menuItem(Icons.settings_outlined,
                        const Color(0xFF6B7280),
                        const Color(0xFFF9FAFB),
                        'Paramètres',
                        'Compte et préférences',
                        () => Get.to(const ParametresPage(),
                            transition: Transition.rightToLeft)),
                    _menuItem(Icons.help_outline_rounded,
                        const Color(0xFF0891B2),
                        const Color(0xFFECFEFF),
                        'Aide & Support',
                        'FAQ et contact',
                        () => Get.to(const AideSupportPage(),
                            transition: Transition.rightToLeft)),
                    const SizedBox(height: 16),

                    // Login / Logout button
                    if (user == null)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Get.to(const LoginPage(),
                              transition: Transition.leftToRight),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Se connecter',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          auth.logout();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded,
                                  color: Color(0xFFE11D48), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Se déconnecter',
                                style: TextStyle(
                                  color: Color(0xFFE11D48),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'YadeBus v2.0 • © 2026',
                      style:
                          TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _divider() {
    return Container(
        width: 1, height: 40, color: const Color(0xFFF3F4F6));
  }

  Widget _menuItem(IconData icon, Color iconColor, Color iconBg, String title,
      String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}
