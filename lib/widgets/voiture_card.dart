
import 'package:flutter/material.dart';

 class CarCard extends StatelessWidget {
  final String name;
  final String brand;
  final String price;
  final String imageUrl;

   CarCard({
    Key? key,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                imageUrl, // Replace with the actual image path
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.directions_car, size: 16),
                const SizedBox(width: 4),
                Text(brand),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.monetization_on, size: 16),
                const SizedBox(width: 4),
                Text(price),
              ],
            ),
            const SizedBox(height: 4),
          const  Row(
              children:  [
                Icon(Icons.av_timer, size: 16),
                SizedBox(width: 4),
                Text('Disponible'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}