import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                'https://api.builder.io/api/v1/image/assets/TEMP/94c919f2342ab04e21aaa64c5ed2946245a48043',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Jane',
          style: GoogleFonts.comfortaa(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: -0.54,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'SAN FRANCISCO, CA',
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: 0.52,
          ),
        ),
      ],
    );
  }
}
