import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _current = 0;

  final List<dynamic> _movies = [
    {
      'title': 'Spider-Man',
      'image': 'https://m.media-amazon.com/images/I/71hvoqd-X3L._AC_SL1357_.jpg',
      'description': 'Spider-Man'
    },
    {
      'title': 'The Amazing Spiderman 2',
      'image': 'https://wallpapers.moviemania.io/phone/movie/102382/bee9ae/the-amazing-spider-man-2-phone-wallpaper.jpg?w=820&h=1459',
      'description': 'The Amazing Spider-Man 2'
    },
    {
      'title': 'Spider-Man No Way Home',
      'image': 'https://9mmwallpapers.com/wp-content/uploads/Spider-Man-No-Way-Home-iPhone-Wallpaper-4k.jpg',
      'description': 'Spider-Man No Way Home'
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,  // Limiter la hauteur totale à 100 pixels
      child: CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(
          height: 100,  // Hauteur du slider limitée
          viewportFraction: 0.7,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: _movies.map((movie) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50, // Limiter la hauteur de l'image
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Image.network(
                         loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.3),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          ),
                        );
                      }
                    },
                        movie['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5), // Ajuster les espaces
                    Text(
                      movie['title'],
                      style: const TextStyle(
                        fontSize: 10.0,  // Réduire la taille de la police
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      movie['description'],
                      style: TextStyle(
                        fontSize: 8.0,  // Réduire la taille de la police
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}