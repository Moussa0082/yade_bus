// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yade_bus/screens/reservation.dart';

// class ServiceCardModel {
//   final String title;
//   final String image;
//   final Widget widget;

//   ServiceCardModel({required this.title, required this.image, required this.widget});
// }

// class NewAccueil extends StatefulWidget {
//   const NewAccueil({super.key});

//   @override
//   State<NewAccueil> createState() => _NewAccueilState();
// }

// class _NewAccueilState extends State<NewAccueil> {
//  final List<ServiceCardModel> services = [
//     ServiceCardModel(title: 'Flight', image: '✈️', widget: ReservationForm()),
//     ServiceCardModel(title: 'Hotel', image: '🏨', widget:  ReservationForm()),
//     ServiceCardModel(title: 'Car', image: '🚗', widget:  ReservationForm()),
//     ServiceCardModel(title: 'Train', image: '🚆', widget:  ReservationForm()), // Exemple en plus
//   ];

//   void goTo(Widget route) {
//     Get.to(route);
//   }
//   // final NavigationController navController = Get.put(NavigationController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // User Info
//             ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[300],
//                 child: Icon(Icons.person),
//               ),
//               title: Text("Jhon Smith"),
//               subtitle: Text("example@gmail.com"),
//               trailing: Icon(Icons.lock),
//             ),

// // Horizontal scrollable cards
// Container(
//   height: 100,
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     padding: EdgeInsets.symmetric(horizontal: 12),
//     itemCount: services.length,
//     itemBuilder: (context, index) {
//       final service = services[index];
//       return GestureDetector(
//         onTap: () => goTo(service.widget),
//         child: Container(
//           width: 100,
//           margin: EdgeInsets.only(right: 12),
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.deepPurple[100],
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(service.image, style: TextStyle(fontSize: 32)),
//               SizedBox(height: 6),
//               Text(service.title, style: TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       );
//     },
//   ),
// ),

//             SizedBox(height: 24),

//             // Just placeholder
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.deepPurple[200],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Center(child: Text("Let’s Go – Your next journey", style: TextStyle(color: Colors.white, fontSize: 18))),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/bus.dart';
import 'package:yade_bus/screens/divertissement.dart';
import 'package:yade_bus/screens/reservation.dart';
import 'package:yade_bus/screens/track_bus.dart';
import 'package:yade_bus/widgets/location_tab.dart';
import 'package:yade_bus/widgets/voyage_tab.dart';

import 'login/login.dart';

// Define some custom colors that match the image
const Color lightPurple =
    Color(0xFFEDE7F6); // A very light purple for backgrounds
const Color textColor = Color(0xFF424242); // Dark grey for text
const Color hintColor = Color(0xFF9E9E9E); // Lighter grey for hints
const Color cardBackgroundColor = Colors.white;
const Color orangeAccent = Color(0xFFFF9800); // For "Fast Book"
const Color greenAccent = Color(0xFF8BC34A); // For "It's all about travel!"

class BookingItem {
  final String name;
  final String location;
  final double rating;
  final int reviewsCount;
  final double price;
  final String imageUrl;

  BookingItem({
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.imageUrl,
  });
}

class ServiceCardModel {
  final String title;
  final IconData image;
  final Widget widget;

  ServiceCardModel(
      {required this.title, required this.image, required this.widget});
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime(2023, 1, 12); // Initial date as per image
  bool _isLoading = true; // State for shimmer effect
  bool _isSwapped = false; // State for input swap animation

  // Controllers for the text fields to preserve text on swap
  final TextEditingController _fromController =
      TextEditingController(text: 'Bamako');
  final TextEditingController _toController =
      TextEditingController(text: 'Sénégal');

  // Define a constant height for the input fields for precise positioning
  static const double _inputHeight = 60.0;
  static const double _swapButtonHeight =
      40.0; // Approximate height of the swap button area

  @override
  void initState() {
    super.initState();
    _loadData(); // Simulate data loading
  }

  final List<ServiceCardModel> services = [
    ServiceCardModel(
        title: 'Voyage',
        image: CupertinoIcons.tickets,
        widget: const VoyageTab()),
    ServiceCardModel(
        title: 'Location',
        image: CupertinoIcons.cube_box,
        widget: const LocationTab()),
    ServiceCardModel(
        title: 'Events',
        image: FeatherIcons.volume2,
        widget: const DivertissementScreen()),
    ServiceCardModel(
      title: 'Bus',
      image: FeatherIcons.truck, // Ou FeatherIcons.map si c'est pour un trajet
      widget: const Bus(), // Vérifie si c'est bien l'écran voulu
    ),
    // ServiceCardModel(
    //     title: 'Train',
    //     image: '🚆',
    //     widget: ReservationForm()), // Exemple en plus
  ];

  void goTo(Widget route) {
    Get.to(route);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bleu,
              onPrimary: Colors.white,
              onSurface: textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: bleu,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _swapInputs() {
    setState(() {
      _isSwapped = !_isSwapped;
      // Swap the text in controllers
      String tempText = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = tempText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bleu,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                "assets/images/logo.png",
                height: 60,
                width: 60,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const LoginPage(), transition: Transition.leftToRight);
            },
            icon: const Icon(
              Icons.login,
              color: blanc,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: bleu),
          ),
          Positioned(
            top: 20,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 20, left: 16, right: 16, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal scrollable cards
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return GestureDetector(
                            onTap: () => goTo(service.widget),
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    service.image,
                                    size: 32,
                                  ),
                                  // Text(service.image,
                                  //     style: const TextStyle(fontSize: 32)),
                                  const SizedBox(height: 6),
                                  Text(service.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    _buildSearchCard(context),
                    const SizedBox(height: 25),
                    Text(
                      'Voyage disponibles',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                    ),
                    const SizedBox(height: 15),
                    _isLoading
                        ? _buildRecentBookingShimmer()
                        : _buildRecentBookingContent(),
                    const SizedBox(height: 25),
                    // Text(
                    //   'Special Offer',
                    //   style:
                    //       Theme.of(context).textTheme.headlineSmall?.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //             color: textColor,
                    //           ),
                    // ),
                    // const SizedBox(height: 15),
                    // _isLoading
                    //     ? _buildSpecialOfferShimmer()
                    //     : _buildSpecialOfferContent(),
                    // const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    // Calculate the total height needed for the input and swap section
    // 2 inputs + 1 swap button + 2 paddings for inputs + 1 padding for swap button
    const double swapSectionHeight = (_inputHeight * 2) +
        20 +
        _swapButtonHeight; // approx 20 padding inside input, 8.0 vertical padding for swap button

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Use SizedBox to constrain the height of the Stack
            // This prevents other elements from shifting when items in Stack animate
            SizedBox(
              height:
                  swapSectionHeight, // Fixed height for the animated input area
              child: Stack(
                children: [
                  // First input field (top position based on swap state)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    top: _isSwapped
                        ? _inputHeight + 20
                        : 0, // Position when swapped
                    left: 0,
                    right: 0,
                    child: _buildLocationInput(
                      controller: _fromController,
                      hint: 'Surat, Gujarat',
                      leadingIcon: Icons.location_on,
                      trailingIcon: Icons.search,
                      key: const ValueKey('from_input'),
                    ),
                  ),

                  // Second input field (bottom position based on swap state)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    top: _isSwapped
                        ? 0
                        : _inputHeight + 20, // Position when swapped
                    left: 0,
                    right: 0,
                    child: _buildLocationInput(
                      controller: _toController,
                      hint: 'Rajkot, Gujarat',
                      leadingIcon: Icons.location_on,
                      trailingIcon: Icons.search,
                      key: const ValueKey('to_input'),
                    ),
                  ),

                  // Swap button, positioned in the middle, always visible on top
                  // Positioned(
                  //   top: _inputHeight + 5, // Position it between the two inputs
                  //   right: 0,
                  //   child: InkWell(
                  //     onTap: _swapInputs,
                  //     child: Container(
                  //       padding: const EdgeInsets.all(6),
                  //       decoration: BoxDecoration(
                  //         color: bleu.withOpacity(0.1),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Icon(Icons.swap_vert, color: bleu),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // const SizedBox(height: 5), // Spacing below the animated section
            _buildDateSelection(context),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print(
                      'From: ${_fromController.text}, To: ${_toController.text}, Date: ${DateFormat('d/M/yyyy').format(_selectedDate)}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bleu,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Rechercher',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInput({
    required TextEditingController controller,
    required String hint,
    required IconData leadingIcon,
    required IconData trailingIcon,
    Key? key,
  }) {
    return SizedBox(
      // Wrap in SizedBox to ensure consistent height for positioning
      height: _inputHeight,
      child: Container(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: lightPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, color: bleu),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: hintColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(color: textColor),
              ),
            ),
            Icon(trailingIcon, color: hintColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: bleu, size: 20),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(color: hintColor, fontSize: 12),
                      ),
                      Text(
                        DateFormat('d/M/yyyy').format(_selectedDate),
                        style: const TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // const SizedBox(width: 10),
        // Expanded(
        //   flex: 1,
        //   child: Row(
        //     children: [
        //       _buildDateButton('Today', true),
        //       const SizedBox(width: 8),
        //       _buildDateButton('Tomorrow', false),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDateButton(String text, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? bleu : lightPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBookingShimmer() {
    return SizedBox(
      height: 150,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(right: 15),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 16, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 150, height: 14, color: Colors.white),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Container(width: 60, height: 12, color: Colors.white),
                        const SizedBox(width: 10),
                        Container(width: 20, height: 2, color: Colors.white),
                        const SizedBox(width: 10),
                        Container(width: 60, height: 12, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            width: 80, height: 16, color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentBookingContent() {
    final List<Map<String, String>> bookings = [
      {
        'busName': 'Maraliner',
        'type': 'AC Seater',
        'price': '\$25.38',
        'from': 'Kuala Lumpur',
        'to': 'Malacca',
        'depTime': '12:00 PM',
        'arrTime': '2:00 AM',
        'duration': '03h 15m',
      },
      {
        'busName': 'Suria Express',
        'type': 'Executive',
        'price': '\$30.00',
        'from': 'Penang',
        'to': 'Ipoh',
        'depTime': '10:00 AM',
        'arrTime': '1:00 PM',
        'duration': '03h 00m',
      },
      {
        'busName': 'Transnasional',
        'type': 'Standard',
        'price': '\$20.00',
        'from': 'Johor Bahru',
        'to': 'Singapore',
        'depTime': '09:00 AM',
        'arrTime': '11:00 AM',
        'duration': '02h 00m',
      },
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.only(right: 15),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['busName']!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          Text(
                            booking['type']!,
                            style:
                                const TextStyle(color: hintColor, fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        booking['price']!,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: bleu,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['from']!,
                              style: const TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['depTime']!,
                              style: const TextStyle(
                                  color: hintColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const Icon(Icons.arrow_right_alt, color: hintColor),
                            Text(
                              booking['duration']!,
                              style: const TextStyle(
                                  color: hintColor, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              booking['to']!,
                              style: const TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['arrTime']!,
                              style: const TextStyle(
                                  color: hintColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialOfferShimmer() {
    return SizedBox(
      height: 150,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Card(
                margin: const EdgeInsets.only(right: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 20, color: Colors.white),
                      const SizedBox(height: 10),
                      Container(width: 200, height: 14, color: Colors.white),
                      const SizedBox(height: 5),
                      Container(width: 180, height: 14, color: Colors.white),
                      const SizedBox(height: 20),
                      Container(width: 120, height: 16, color: Colors.white),
                    ],
                  ),
                ),
              );
            } else {
              return Card(
                margin: const EdgeInsets.only(right: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(height: 10),
                      Container(width: 80, height: 16, color: Colors.white),
                      const SizedBox(height: 5),
                      Container(width: 60, height: 14, color: Colors.white),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget _buildSpecialOfferContent() {
  //   return SizedBox(
  //     height: 150,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         Card(
  //           elevation: 2,
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           color: greenAccent,
  //           child: Container(
  //             width: 280,
  //             padding: const EdgeInsets.all(15),
  //             child: Row(
  //               children: [
  //                 Image.asset(
  //                   'assets/bus_illustration.png',
  //                   width: 80,
  //                   height: 80,
  //                   errorBuilder: (context, error, stackTrace) =>
  //                       const Icon(Icons.directions_bus, size: 80, color: Colors.white),
  //                 ),
  //                 const SizedBox(width: 15),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         "It's all about travel!",
  //                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                       ),
  //                       const SizedBox(height: 5),
  //                       const Text(
  //                         "Helping people book travel and accommodation for more than 20 years",
  //                         style: TextStyle(color: Colors.white70, fontSize: 12),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white.withOpacity(0.2),
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: const Text(
  //                           'VIEW BUSES WITH THIS OFFER',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 10,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 15),
  //         Card(
  //           elevation: 2,
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           color: orangeAccent,
  //           child: Container(
  //             width: 120,
  //             padding: const EdgeInsets.all(15),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Icon(Icons.local_activity, size: 50, color: Colors.white),
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   'Fast Book',
  //                   textAlign: TextAlign.center,
  //                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 const Text(
  //                   'Ticket',
  //                   style: TextStyle(color: Colors.white70, fontSize: 12),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 15),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: cardBackgroundColor,
          selectedItemColor: bleu,
          unselectedItemColor: hintColor,
          currentIndex: 0,
          onTap: (index) {
            // Handle tab changes
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'My Ticket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'My Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
