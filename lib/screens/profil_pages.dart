import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Shared helpers ──────────────────────────────────────────────────────────

const _primary = Color(0xFF2967FF);
const _bg = Color(0xFFF5F7FA);

class _PageAppBar extends StatelessWidget {
  final String title;
  const _PageAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
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
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827))),
        ],
      ),
    );
  }
}

// ─── Mes Réservations ────────────────────────────────────────────────────────

class MesReservationsPage extends StatefulWidget {
  const MesReservationsPage({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<MesReservationsPage> createState() => _MesReservationsPageState();
}

class _MesReservationsPageState extends State<MesReservationsPage> {
  late int _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
  }
  final List<String> _tabs = ['Billets', 'Colis', 'Logements', 'Locations'];

  // Static data — TODO: replace with API calls
  // GET /api/v1/reservations?userId=...&type=billet
  final _billets = [
    {
      'from': 'Bamako',
      'to': 'Dakar',
      'date': '12 Juil 2026',
      'ref': 'YB-2024-001',
      'status': 'Confirmé',
      'price': '15 000 Fcfa',
      'statusColor': 0xFF16A34A,
    },
    {
      'from': 'Bamako',
      'to': 'Abidjan',
      'date': '20 Juil 2026',
      'ref': 'YB-2024-002',
      'status': 'En attente',
      'price': '20 000 Fcfa',
      'statusColor': 0xFFF59E0B,
    },
    {
      'from': 'Sikasso',
      'to': 'Bamako',
      'date': '03 Août 2026',
      'ref': 'YB-2024-003',
      'status': 'Confirmé',
      'price': '7 500 Fcfa',
      'statusColor': 0xFF16A34A,
    },
  ];

  // GET /api/v1/colis?userId=...
  final _colis = [
    {
      'from': 'Bamako',
      'to': 'Dakar',
      'date': '10 Juil 2026',
      'ref': 'COL-2024-001',
      'status': 'En transit',
      'weight': '2.5 kg',
      'statusColor': 0xFF2967FF,
    },
    {
      'from': 'Bamako',
      'to': 'Sikasso',
      'date': '05 Juil 2026',
      'ref': 'COL-2024-002',
      'status': 'Livré',
      'weight': '1.2 kg',
      'statusColor': 0xFF16A34A,
    },
  ];

  // GET /api/v1/logements/reservations?userId=...
  final _logements = [
    {
      'name': 'Résidence Amahoro',
      'city': 'Dakar',
      'dates': '12-15 Juil 2026',
      'ref': 'LOG-2024-001',
      'status': 'Confirmé',
      'price': '45 000 Fcfa',
      'statusColor': 0xFF16A34A,
    },
    {
      'name': 'Hôtel Le Plateau',
      'city': 'Abidjan',
      'dates': '20-22 Juil 2026',
      'ref': 'LOG-2024-002',
      'status': 'En attente',
      'price': '60 000 Fcfa',
      'statusColor': 0xFFF59E0B,
    },
  ];

  // GET /api/v1/voitures/locations?userId=...
  final _locations = [
    {
      'car': 'Toyota Corolla',
      'city': 'Bamako',
      'dates': '15-18 Juil 2026',
      'ref': 'VOI-2024-001',
      'status': 'Confirmé',
      'price': '90 000 Fcfa',
      'statusColor': 0xFF16A34A,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _PageAppBar('Mes réservations'),
          _buildTabBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final sel = _tab == i;
            return GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: sel ? _primary : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    color: sel ? _primary : const Color(0xFF9CA3AF),
                    fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final lists = [_billets, _colis, _logements, _locations];
    final items = lists[_tab];
    if (items.isEmpty) {
      return const Center(
        child: Text('Aucune réservation', style: TextStyle(color: Color(0xFF9CA3AF))),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildCard(items[i]),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final statusColor = Color(item['statusColor'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _tab == 2
                    ? item['name'] as String
                    : _tab == 3
                        ? item['car'] as String
                        : '${item['from']} → ${item['to']}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['status'] as String,
                  style: TextStyle(
                      fontSize: 12, color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.tag_rounded, size: 14, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(item['ref'] as String,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(
                  _tab == 2 || _tab == 3
                      ? item['dates'] as String
                      : item['date'] as String,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_tab == 0 || _tab == 2 || _tab == 3)
                Text(
                  item['price'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _primary,
                  ),
                ),
              if (_tab == 1)
                Row(
                  children: [
                    const Icon(Icons.scale_outlined,
                        size: 14, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(item['weight'] as String,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              if (_tab == 2 || _tab == 3)
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(item['city'] as String,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Notifications ───────────────────────────────────────────────────────────

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Static notifications — TODO: replace with API calls
  // GET /api/v1/notifications?userId=...
  final _notifications = [
    {
      'title': 'Voyage confirmé',
      'body': 'Votre billet Bamako → Dakar du 12 Juil est confirmé.',
      'time': 'Il y a 2h',
      'icon': Icons.confirmation_number_outlined,
      'color': 0xFF2967FF,
      'read': false,
    },
    {
      'title': 'Colis en transit',
      'body': 'Votre colis COL-2024-001 est en route pour Dakar.',
      'time': 'Il y a 5h',
      'icon': Icons.inventory_2_outlined,
      'color': 0xFFF59E0B,
      'read': false,
    },
    {
      'title': 'Promotion YadeBus',
      'body': '-20% sur tous les billets Bamako-Abidjan ce weekend.',
      'time': 'Hier',
      'icon': Icons.local_offer_outlined,
      'color': 0xFF16A34A,
      'read': true,
    },
    {
      'title': 'Réservation logement',
      'body': 'Résidence Amahoro vous confirme votre arrivée le 12 Juil.',
      'time': 'Hier',
      'icon': Icons.apartment_outlined,
      'color': 0xFF7C3AED,
      'read': true,
    },
    {
      'title': 'Bienvenue sur YadeBus',
      'body': 'Planifiez vos voyages, colis et logements en Afrique.',
      'time': '3 Jul 2026',
      'icon': Icons.directions_bus_rounded,
      'color': 0xFF2967FF,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _PageAppBar('Notifications'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: _notifications.length,
              itemBuilder: (_, i) => _buildNotif(_notifications[i], i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotif(Map<String, dynamic> n, int index) {
    final color = Color(n['color'] as int);
    final read = n['read'] as bool;
    return GestureDetector(
      onTap: () => setState(() => _notifications[index]['read'] = true),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: read ? Colors.white : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: read ? const Color(0xFFF3F4F6) : _primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(n['icon'] as IconData, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(n['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: read ? FontWeight.w500 : FontWeight.bold,
                            color: const Color(0xFF111827),
                          )),
                      if (!read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: _primary, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(n['body'] as String,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 5),
                  Text(n['time'] as String,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Paramètres ──────────────────────────────────────────────────────────────

class ParametresPage extends StatefulWidget {
  const ParametresPage({super.key});

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  // Static profile data — TODO: replace with user from AuthProvider
  final _prenomCtrl = TextEditingController(text: 'Mamadou');
  final _nomCtrl = TextEditingController(text: 'Traoré');
  final _telCtrl = TextEditingController(text: '+223 70 00 00 00');
  final _emailCtrl = TextEditingController(text: 'mamadou@yadebus.com');

  bool _notifVoyages = true;
  bool _notifColis = true;
  bool _notifPromos = false;

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageAppBar('Paramètres'),
            const SizedBox(height: 20),
            _section('Informations personnelles'),
            _inputField('Prénom', _prenomCtrl, Icons.person_outline_rounded),
            _inputField('Nom', _nomCtrl, Icons.person_outline_rounded),
            _inputField('Téléphone', _telCtrl, Icons.phone_outlined,
                type: TextInputType.phone),
            _inputField('Email', _emailCtrl, Icons.email_outlined,
                type: TextInputType.emailAddress),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: PATCH /api/v1/users/:id — save profile
                    Get.snackbar('Succès', 'Profil mis à jour',
                        backgroundColor: const Color(0xFF16A34A),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Enregistrer',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            _section('Notifications'),
            _switchItem('Voyages & billets', 'Alertes sur vos réservations',
                _notifVoyages, Icons.confirmation_number_outlined,
                const Color(0xFF2967FF), (v) => setState(() => _notifVoyages = v)),
            _switchItem('Colis', 'Suivi de vos envois',
                _notifColis, Icons.inventory_2_outlined,
                const Color(0xFFF59E0B), (v) => setState(() => _notifColis = v)),
            _switchItem('Promotions', 'Offres et réductions',
                _notifPromos, Icons.local_offer_outlined,
                const Color(0xFF16A34A), (v) => setState(() => _notifPromos = v)),
            const SizedBox(height: 24),
            _section('Sécurité'),
            _menuRow(Icons.lock_outline_rounded, const Color(0xFF7C3AED),
                const Color(0xFFF5F3FF), 'Changer le mot de passe', () {
              Get.snackbar('Info', 'Fonctionnalité à venir',
                  snackPosition: SnackPosition.BOTTOM);
            }),
            _menuRow(Icons.language_outlined, const Color(0xFF0891B2),
                const Color(0xFFECFEFF), 'Langue de l\'application', () {
              Get.snackbar('Info', 'Fonctionnalité à venir',
                  snackPosition: SnackPosition.BOTTOM);
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5)),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          prefixIcon: Icon(icon, color: _primary, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _switchItem(String title, String subtitle, bool value, IconData icon,
      Color color, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _primary,
          ),
        ],
      ),
    );
  }

  Widget _menuRow(IconData icon, Color iconColor, Color iconBg, String title,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                  color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Aide & Support ──────────────────────────────────────────────────────────

class AideSupportPage extends StatefulWidget {
  const AideSupportPage({super.key});

  @override
  State<AideSupportPage> createState() => _AideSupportPageState();
}

class _AideSupportPageState extends State<AideSupportPage> {
  // Static FAQ — TODO: replace with GET /api/v1/faq
  final _faqs = [
    {
      'q': 'Comment réserver un billet de bus ?',
      'a':
          'Allez dans l\'onglet "Bus", entrez votre ville de départ et destination, choisissez la date, puis cliquez sur "Rechercher". Sélectionnez le trajet qui vous convient et procédez au paiement.',
    },
    {
      'q': 'Quels modes de paiement sont acceptés ?',
      'a':
          'YadeBus accepte Orange Money et Wave. Le paiement est sécurisé et instantané.',
    },
    {
      'q': 'Comment envoyer un colis ?',
      'a':
          'Sur l\'accueil, sélectionnez l\'onglet "Colis", renseignez le départ, la destination et la date, puis cliquez sur "Envoyer un colis".',
    },
    {
      'q': 'Comment annuler une réservation ?',
      'a':
          'Dans l\'onglet "Bus", sélectionnez "Annuler", renseignez votre numéro de réservation. L\'annulation est possible 24h avant le départ.',
    },
    {
      'q': 'Comment suivre mon colis ?',
      'a':
          'Rendez-vous dans "Mes réservations" → onglet "Colis" pour voir le statut de vos envois en temps réel.',
    },
    {
      'q': 'YadeBus est disponible dans quels pays ?',
      'a':
          'YadeBus couvre 35+ pays en Afrique avec plus de 2 500 destinations. Mali, Sénégal, Côte d\'Ivoire, Burkina Faso et bien d\'autres.',
    },
  ];

  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _PageAppBar('Aide & Support'),
            // Contact card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2967FF), Color(0xFF1A56DB)],
                  ),
                  borderRadius: BorderRadius.circular(18),
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
                      child: const Icon(Icons.support_agent_rounded,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Support YadeBus',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          Text('Disponible 24h/7j',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _contactBtn(Icons.chat_bubble_outline_rounded, 'Chat'),
                        const SizedBox(height: 6),
                        _contactBtn(Icons.phone_outlined, 'Appel'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // FAQ
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: const [
                  Text('Questions fréquentes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827))),
                ],
              ),
            ),
            ...List.generate(
                _faqs.length, (i) => _buildFaqItem(i, _faqs[i])),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _contactBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int i, Map<String, String> faq) {
    final open = _expanded.contains(i);
    return GestureDetector(
      onTap: () => setState(() {
        if (open) {
          _expanded.remove(i);
        } else {
          _expanded.add(i);
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: open
                  ? _primary.withValues(alpha: 0.3)
                  : const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(faq['q']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: open ? _primary : const Color(0xFF111827),
                        )),
                  ),
                  Icon(
                    open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: open ? _primary : const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
            if (open)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Text(faq['a']!,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF6B7280), height: 1.5)),
              ),
          ],
        ),
      ),
    );
  }
}
