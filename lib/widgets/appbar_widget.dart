import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color.dart';

class AppbarWidget {
  const AppbarWidget(this.icon, this.title);
  final List<Widget>? icon;
  final String title;

  static PreferredSizeWidget myAppBar(icon, title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,      // Hitam
            Color(0xFF0A7D07), // Hijau
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent, // Agar gradasi terlihat
        elevation: 0, // Hilangkan bayangan AppBar
        foregroundColor: Colors.white,
        actions: icon,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white, // Pastikan teks tetap terlihat
          ),
        ),
      ),
    ),
  );
}
}
