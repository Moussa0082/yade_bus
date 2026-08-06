import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierReservationPage extends StatefulWidget {
  const ModifierReservationPage({super.key});

  @override
  State<ModifierReservationPage> createState() =>
      _ModifierReservationPageState();
}

class _ModifierReservationPageState extends State<ModifierReservationPage> {
  final TextEditingController _reservationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isModif = false;

  static const Color _primaryBlue = Color(0xFF2967FF);
  static const Color _background = Color(0xFFF5F7FA);
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGray = Color(0xFF9CA3AF);
  static const Color _errorRed = Color(0xFFEF4444);

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      helpText: 'Sélectionner une date',
      cancelText: 'Annuler',
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: _primaryBlue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGray, fontSize: 14),
      filled: true,
      fillColor: _background,
      prefixIcon: Icon(prefixIcon, color: _textGray, size: 20),
      suffixIcon: suffixIcon,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _textGray.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _textGray.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.8),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: _textGray,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reservationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Custom top bar ──────────────────────────────────────────────
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
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: _textDark, size: 20),
                ),
                const Expanded(
                  child: Text(
                    'Modifier / Annuler',
                    style: TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Placeholder to center the title
                const SizedBox(width: 44),
              ],
            ),
          ),

          // ── Blue subtitle banner ────────────────────────────────────────
          Container(
            color: _primaryBlue,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Gérez la réservation d\'un client',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // ── Form body ───────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reservation number field
                  _sectionLabel('NUMÉRO DE RÉSERVATION'),
                  TextFormField(
                    controller: _reservationController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _fieldDecoration(
                      hint: 'Ex. RES-2025-00123',
                      prefixIcon: Icons.confirmation_number_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date field — shown only when isModif is true
                  if (isModif) ...[
                    _sectionLabel('NOUVELLE DATE'),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateController,
                          style: const TextStyle(
                            color: _textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _fieldDecoration(
                            hint: 'Sélectionner une date',
                            prefixIcon: Icons.calendar_today_outlined,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _textGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else
                    const SizedBox(height: 24),

                  // ── Action buttons ──────────────────────────────────────
                  Row(
                    children: [
                      // Annuler button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Réservation annulée'),
                                  backgroundColor: _errorRed,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.cancel_outlined,
                                color: _errorRed, size: 18),
                            label: const Text(
                              'Annuler la réservation',
                              style: TextStyle(
                                color: _errorRed,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFF1F2),
                              side: const BorderSide(
                                  color: _errorRed, width: 1.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Modifier button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isModif = true;
                              });
                            },
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.white, size: 18),
                            label: const Text(
                              'Modifier',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBlue,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
