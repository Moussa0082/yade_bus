import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yade_bus/widgets/shimmer_effect.dart';
import 'package:yade_bus/widgets/voiture_card.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
   
     bool isLoading = true;

  
    final List<Map<String, String>> cars = [
    {
      'name': 'Toyota Corolla',
      'brand': 'Toyota',
      'price': '\$50 / day',
      'image': 'assets/images/images1.jpeg',
    },
    {
      'name': 'Honda Civic',
      'brand': 'Honda',
      'price': '\$45 / day',
      'image': 'assets/images/images3.jpeg',
    },
    {
      'name': 'BMW Series 3',
      'brand': 'BMW',
      'price': '\$70 / day',
      'image': 'assets/images/images2.jpeg',
    },
    {
      'name': 'Audi A4',
      'brand': 'Audi',
      'price': '\$65 / day',
      'image': 'assets/images/images4.jpeg',
    },
  ];

   
  @override
  void initState() {
    super.initState();
    // Timer de 3 secondes pour simuler le chargement
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Location de voitures'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
        isLoading
            ? buildShimmerLocationCard() :
        GridView.builder(
          
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8, // Adjust ratio for card height
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return CarCard(
              
              name: car['name']!,
              brand: car['brand']!,
              price: car['price']!,
              imageUrl: car['image']!,
            );
          },
        ),
      ),
    );
  }
}
