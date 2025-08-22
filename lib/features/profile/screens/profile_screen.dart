import 'package:complex_ui_openai/features/profile/widgets/profile_actions.dart';
import 'package:complex_ui_openai/features/profile/widgets/profile_header.dart';
import 'package:complex_ui_openai/features/profile/widgets/profile_photo_grid.dart';
import 'package:complex_ui_openai/features/profile/widgets/profile_tab_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 44),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const ProfileHeader(),
                  const SizedBox(height: 31),
                  const ProfileActions(),
                  const SizedBox(height: 16),
                  const ProfilePhotoGrid(),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'SEE MORE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 0.52,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ProfileTabBar(),
    );
  }
}
