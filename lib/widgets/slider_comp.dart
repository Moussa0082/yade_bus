import 'dart:async';

import 'package:flutter/material.dart';

class AgencySlider extends StatefulWidget {
  @override
  _AgencySliderState createState() => _AgencySliderState();
}

class _AgencySliderState extends State<AgencySlider> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollOffset = 200.0; // Valeur de défilement par intervalle

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel(); // Annulez le timer lors de la suppression du widget
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + _scrollOffset,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        // Défilement infini (revenir au début si à la fin)
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  void _scroll(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => _scroll(-200.0),
        ),
        Expanded(
          child: SizedBox(
            height: 100.0,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: agencies.length,
              itemBuilder: (context, index) {
                final agency = agencies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Image.network(
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                              height: 70,
                              width: 100.0,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_outlined,
                                  size: 40, color: Colors.grey),
                            );
                        },
                        agency.imageUrl,
                        width: 100.0,
                        height: 70.0,
                        fit: BoxFit.cover,
                         loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          height: 70,
                          width: 100.0,
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
                      ),
                      SizedBox(height: 5.0),
                      Text(agency.name),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () => _scroll(200.0),
        ),
      ],
    );
  }
}

class Agency {
  final String imageUrl;
  final String name;

  Agency({required this.imageUrl, required this.name});
}

final List<Agency> agencies = [
  Agency(
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBg4GcaqAT202SHG6dd4GCGPKTDJYwHmIIEA&s', // Remplacez par l'URL de l'image
    name: 'Rimbo',
  ),
  Agency(
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTrCnP1a0J7rCWkBwPL4pnojK6L06gjngxWw&s',
    name: 'Diarra',
  ),
  Agency(
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnUvLzNOVYWxLqYdLge7HN2ZmPvrjwtasLvw&s',
    name: 'Sonef',
  ),
  // Ajoutez d'autres agences...
];
