import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yade_bus/services/reservation_service.dart';
import 'package:yade_bus/widgets/voyage_reservation_detail.dart';

import '../constant/constantes.dart';

class ReservationsTab extends StatefulWidget {
  @override
  _ReservationsTabState createState() => _ReservationsTabState();
}

class _ReservationsTabState extends State<ReservationsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _reservations = [];
  bool _isLoading = false;

  Future<void> _searchReservations() async {
    setState(() {
      _isLoading = true;
      _reservations = [];
    });

    // Simuler le chargement + appel réseau réel ici
    ReservationService().fetchAllReservationVoyageByNumConfirmation(
        _searchController.text.toString()).then((val){
         setState(() {
            _isLoading = false;
            _reservations =  val;
         });
        });

    
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            child: ListTile(
              title: Container(height: 14, color: Colors.white),
              subtitle: Container(
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationItem(Map<String, dynamic> r) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blueAccent),
        title: Text(
          r['passager'] ?? "Passager inconnu",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconText(Icons.phone, r['telephone']),
              _iconText(
                  Icons.confirmation_number, "N° ${r['numConfirmation']}"),
              _iconText(Icons.event, r['dateReserv']),
              if (r['adresse'] != null)
                _iconText(Icons.location_on, r['adresse']),
              if (r['raisonSociale'] != null)
                _iconText(Icons.business, r['raisonSociale']),
              if (r['payment'] != null) _iconText(Icons.payment, r['payment']),
              _iconText(Icons.info_outline, "État: ${r['etat']}"),
              if (r['optionBillet'] != null)
                _iconText(Icons.directions_bus, "Billet: ${r['optionBillet']}"),
            ],
          ),
        ),
        onTap: () {
          // action au clic
        },
      ),
    );
  }

  Widget _iconText(IconData icon, String? text) {
    if (text == null || text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color rouge = Colors.red.shade700;
    final Color blanc = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Rechercher mes réservations',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: rouge,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _searchReservations,
              label: Text(
                'Rechercher',
                style: TextStyle(color: blanc),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? _buildShimmer()
                : _reservations.isEmpty
                    ? const Center(child: Text("Aucune réservation trouvée."))
                    : ListView.builder(
                        itemCount: _reservations.length,
                        itemBuilder: (context, index) {
                          return _buildReservationItem(_reservations[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
