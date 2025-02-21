import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:provider/provider.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/divertissement.dart';
import 'package:yade_bus/screens/home.dart';
import 'package:yade_bus/screens/map.dart';
import 'package:yade_bus/widgets/colis_form.dart';
import 'package:yade_bus/widgets/voyage_form.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

const d_color = Color(0xFFFFFFFF);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);
const d_colorOr = Color.fromRGBO(254, 243, 231, 1);

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int activePageIndex = 0;
  Future<bool> _onBackPressed() async {
    // Essayez de revenir en arrière dans la pile de navigation actuelle
    final NavigatorState? navigator =
        _navigatorKeys[activePageIndex].currentState;
    if (navigator != null && navigator.canPop()) {
      // S'il y a une page précédente, pop la page
      navigator.pop();
      return false; // Indiquez que l'événement de retour a été géré
    }
    return true; // Indiquez que l'application peut se fermer
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  List pages = <Widget>[
    VoyageForm(),
    ColisTab(),
    DivertissementScreen(),
    DivertissementScreen(),
    // const MapSreen()
  ];

  void _changeActivePageValue(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  void changeIndex(int value) {
    if (value != _pageIndex) {
      _pageIndex = value;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // void _onBackPressed(bool isBackPressed) async {
  //   if (!isBackPressed) {
  //     // Essayez de revenir en arrière dans la pile de navigation actuelle
  //     final NavigatorState? navigator =
  //         _navigatorKeys[activePageIndex].currentState;
  //     if (navigator != null && navigator.canPop()) {
  //       // S'il y a une page précédente, pop la page
  //       navigator.pop();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_colorPage,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body:
          // Consumer<BottomNavigationService>(
          // builder: (context, bottomService, child) {

          Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          _buildOffstageNavigator(3)
        ],
      ),
      // },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 5.0,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: d_color,
            icon: Icon(Icons.travel_explore_outlined),
            label: "Voyage",
          ),
          BottomNavigationBarItem(
            backgroundColor: d_color,
            icon: Icon(FeatherIcons.package),
            label: "Colis",
          ),
          BottomNavigationBarItem(
            backgroundColor: d_color,
            icon: Icon(FeatherIcons.volume2),
            label: "Events",
          ),
          BottomNavigationBarItem(
            backgroundColor: d_color,
            icon: Icon(CupertinoIcons.map),
            label: "Map",
          ),
        ],
        unselectedItemColor: Colors.black,
        selectedItemColor: bleu,
        iconSize: 30,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        currentIndex: activePageIndex,
        onTap: _changeActivePageValue,
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          VoyageForm(),
          ColisTab(),
          DivertissementScreen(),
          DivertissementScreen(),
          // const MapSreen()
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: activePageIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
