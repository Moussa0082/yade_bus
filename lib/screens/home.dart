import 'package:flutter/material.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/widgets/colis_form.dart';
import 'package:yade_bus/widgets/location_page.dart';
import 'package:yade_bus/widgets/voyage_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Use your logo image here
              height: 40,
            ),
           const SizedBox(width: 10),
            const Text('DjaamYadee'),
          ],
        ),
        bottom: TabBar(
          dividerColor: bleu,
          indicatorColor: bleu,
          labelStyle: const TextStyle(color: bleu),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Voyage'),
            Tab(text: 'Colis'),
            Tab(text: 'Location'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Voyage Tab content
          VoyageForm(),
         ColisTabScreen(),
        const LocationScreen()
        ],
      ),
    );
  }
}
