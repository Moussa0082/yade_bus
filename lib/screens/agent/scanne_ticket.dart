import 'package:flutter/material.dart';

class ScannerTicketPage extends StatefulWidget {
  const ScannerTicketPage({super.key});

  @override
  State<ScannerTicketPage> createState() => _ScannerTicketPageState();
}

class _ScannerTicketPageState extends State<ScannerTicketPage> {
  String ticketCode = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;
  bool ticketValidated = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _startScan() {
    setState(() {
      isScanning = true;
    });
  }

  void _validateTicket() {
    setState(() {
      ticketValidated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom top bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Scanner un ticket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Blue header section
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF2967FF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Validation de ticket',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Scannez ou entrez le code du ticket',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // QR scan zone
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: isScanning
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF2967FF),
                                      strokeWidth: 3,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.qr_code_scanner_rounded,
                                          size: 80,
                                          color: Color(0xFFD1D5DB),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Zone de scan QR',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Divider with "ou entrez manuellement"
                          Row(
                            children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'ou entrez manuellement',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Manual code entry
                          TextFormField(
                            onChanged: (value) =>
                                setState(() => ticketCode = value),
                            decoration: InputDecoration(
                              hintText: 'Code du ticket',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.qr_code_rounded,
                                color: Color(0xFF2967FF),
                              ),
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
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2967FF),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Success card
                          if (ticketCode.isNotEmpty && ticketValidated)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF16A34A).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF16A34A)
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Ticket validé avec succès !',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 20),

                          // Camera button (outlined)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: _startScan,
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: Color(0xFF2967FF),
                              ),
                              label: const Text(
                                'Scanner avec la caméra',
                                style: TextStyle(
                                  color: Color(0xFF2967FF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF2967FF),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Validate button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  ticketCode.isNotEmpty ? _validateTicket : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2967FF),
                                disabledBackgroundColor:
                                    const Color(0xFF2967FF).withValues(alpha: 0.4),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Valider le ticket',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
