import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, -0.5),
            blurRadius: 13.59,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TabItem(
                  icon: SvgPicture.asset(
                    'assets/icons/home.svg',
                    width: 15.56,
                    height: 14.06,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 1.0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                _TabItem(
                  icon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 15.85,
                    height: 15.85,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 1.0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const _UploadButton(),
                _TabItem(
                  icon: SvgPicture.asset(
                    'assets/icons/chatBubble.svg',
                    width: 18,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 1.0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                _TabItem(
                  icon: SvgPicture.asset(
                    'assets/icons/person.svg',
                    width: 10.43,
                    height: 15,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 1.0),
                      BlendMode.srcIn,
                    ),
                  ),
                  isSelected: true,
                ),
              ],
            ),
          ),
          Container(
            width: 135,
            height: 5,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final Widget icon;
  final bool isSelected;
  const _TabItem({required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 40, height: 40, child: Center(child: icon));
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF00D6), Color(0xFFFF4D00)],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/add.svg',
          width: 13,
          height: 13,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
