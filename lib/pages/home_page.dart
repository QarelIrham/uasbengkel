import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_motor/pages/about_page.dart';
import 'package:inventory_motor/pages/form_entry_page.dart';
import 'package:inventory_motor/pages/form_exit_page.dart';
import 'package:inventory_motor/pages/history_page.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:inventory_motor/widgets/appbar_widget.dart';
import 'package:inventory_motor/widgets/banner_widget.dart';
import 'package:inventory_motor/widgets/button_widget.dart';
import 'package:inventory_motor/widgets/item_data_card_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<GetAllProductProvider>(context, listen: false);
      productProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget.myAppBar([
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutPage(),
            ),
          ),
          icon: const Icon(Icons.info),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryPage(),
            ),
          ),
          icon: const Icon(Icons.history),
        ),
      ], "MotorParts Inventory"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12,
            top: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerWidget.myBanner(),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Produk Kamu",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const ItemDataCardWidget(),
Padding(
  padding: const EdgeInsets.only(bottom: 10), // Memberikan jarak bawah antar tombol
  child: SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,      // Hitam
            Color(0xFF0A7D07), // Hijau
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ButtonWidget.myButton(
        "Tambah Stok Masuk Produk",
        Colors.transparent, // Warna tombol dibuat transparan agar gradasi terlihat
        Colors.white,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FormEntryPage(),
          ),
        ),
      ),
    ),
  ),
),
SizedBox(height: 10),  // Memberikan jarak antar tombol
Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,      // Hitam
            Color(0xFF0A7D07), // Hijau
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ButtonWidget.myButton(
        "Tambah Stok Keluar Produk",
        Colors.transparent, // Warna tombol dibuat transparan agar gradasi terlihat
        Colors.white,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FormExitPage(),
          ),
        ),
      ),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
