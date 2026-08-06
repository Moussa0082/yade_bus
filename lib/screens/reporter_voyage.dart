import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';

class ReporterVoyage extends StatefulWidget {
  const ReporterVoyage({super.key});

  @override
  State<ReporterVoyage> createState() => _ReporterVoyageState();
}

class _ReporterVoyageState extends State<ReporterVoyage> {
  static const _primary = Color(0xFF2967FF);

  final _oldDateController = TextEditingController();
  final _newDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? confirmationNumber;
  String? userNumber;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldDateController.dispose();
    _newDateController.dispose();
    super.dispose();
  }

  Future<void> _reporterVoyage() async {
    if (_newDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner la nouvelle date')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final body = json.encode({
        'numConfirmation': confirmationNumber,
        'telephone': userNumber,
        'oldDate': _oldDateController.text,
        'newDate': _newDateController.text,
      });
      final response = await http.post(
        Uri.parse('$apiUrl/reporter_reservation.php'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      final data = json.decode(utf8.decode(response.bodyBytes));
      final msg = data['message'] ?? data['error'] ?? 'Réponse inattendue';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if (response.statusCode == 200 && data['error'] == null) {
        _formKey.currentState?.reset();
        _oldDateController.clear();
        _newDateController.clear();
        setState(() {
          confirmationNumber = null;
          userNumber = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur réseau : ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController ctrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
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
      ctrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            color: _primary,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reporter un voyage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Choisissez une nouvelle date pour votre trajet',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Numéro de confirmation',
                    hint: 'Ex: YADE-123456',
                    icon: Icons.confirmation_number_outlined,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Veuillez entrer le numéro de confirmation'
                        : null,
                    onSaved: (v) => confirmationNumber = v,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: "Numéro de l'utilisateur",
                    hint: 'Ex: +223 XX XX XX XX',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.isEmpty)
                        ? "Veuillez entrer votre numéro d'utilisateur"
                        : null,
                    onSaved: (v) => userNumber = v,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    label: 'Date du voyage actuelle',
                    controller: _oldDateController,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    label: 'Nouvelle date souhaitée',
                    controller: _newDateController,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                await _reporterVoyage();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text(
                              'Reporter le voyage',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, controller),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              style:
                  const TextStyle(color: Color(0xFF111827), fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_today_rounded,
                    color: _primary, size: 20),
                suffixIcon: const Icon(Icons.calendar_month_outlined,
                    color: Color(0xFF9CA3AF), size: 20),
                hintText: 'Sélectionner une date',
                hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
          style: const TextStyle(color: Color(0xFF111827), fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _primary, size: 20),
            hintText: hint,
            hintStyle:
                const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
              borderSide: const BorderSide(color: _primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
