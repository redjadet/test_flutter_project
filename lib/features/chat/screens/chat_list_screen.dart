import 'package:complex_ui/core/ui/layout.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isNarrow = screenWidth < narrowWidth;
            final isTablet = screenWidth >= 900;

            // Responsive padding
            const horizontalPadding = 0.0;
            final verticalPadding = isNarrow ? 16.0 : 24.0;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status bar time
                  Text(
                    '9:27',
                    style: TextStyle(
                      fontSize: isNarrow ? 18 : (isTablet ? 22 : 20),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: isNarrow ? 16 : 20),

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: isNarrow ? 40 : (isTablet ? 48 : 44),
                      height: isNarrow ? 40 : (isTablet ? 48 : 44),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(isNarrow ? 12 : 14),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: isNarrow ? 20 : (isTablet ? 24 : 22),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: isNarrow ? 24 : 32),

                  // Title
                  Center(
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: isNarrow ? 24 : (isTablet ? 28 : 26),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: isNarrow ? 24 : 32),

                  // Chat list
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 600 : double.infinity,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top separator
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                            height: 1,
                          ),
                          SizedBox(height: isNarrow ? 16 : 20),
                          // Chat list
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            separatorBuilder: (context, index) => Column(
                              children: [
                                SizedBox(height: isNarrow ? 16 : 20),
                                Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                  height: 1,
                                ),
                                SizedBox(height: isNarrow ? 16 : 20),
                              ],
                            ),
                            itemBuilder: (context, index) {
                              final chats = [
                                {
                                  'profileImage':
                                      'https://api.builder.io/api/v1/image/assets/TEMP/8559e2f24399725da9df6bbf3cebc8440bda9b07?placeholderIfAbsent=true',
                                  'name': 'James',
                                  'message':
                                      'Thank you! That was very helpful!',
                                },
                                {
                                  'profileImage':
                                      'https://api.builder.io/api/v1/image/assets/TEMP/65765b6b57a9d6f9a7bb8b902e1f7e6af78e04ea?placeholderIfAbsent=true',
                                  'name': 'Will Kenny',
                                  'message':
                                      'I know... I\'m trying to get the funds.',
                                },
                                {
                                  'profileImage':
                                      'https://api.builder.io/api/v1/image/assets/TEMP/b4e9d4e5fed60bf93a9d3d5d4f92f5c66da225fe?placeholderIfAbsent=true',
                                  'name': 'Beth Williams',
                                  'message':
                                      'I\'m looking for tips around capturing the milky way. I have a 6D with a 24-100mm...',
                                },
                                {
                                  'profileImage':
                                      'https://api.builder.io/api/v1/image/assets/TEMP/58d289dc74c2e7da84a70af75c3f7ccc87aee1f3?placeholderIfAbsent=true',
                                  'name': 'Rev Shawn',
                                  'message':
                                      'Wanted to ask if you\'re available for a portrait shoot next week.',
                                },
                              ];

                              final chat = chats[index];
                              return _buildChatItem(
                                profileImage: chat['profileImage']!,
                                name: chat['name']!,
                                message: chat['message']!,
                                isNarrow: isNarrow,
                                isTablet: isTablet,
                              );
                            },
                          ),
                          // Bottom separator
                          SizedBox(height: isNarrow ? 16 : 20),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatItem({
    required String profileImage,
    required String name,
    required String message,
    required bool isNarrow,
    required bool isTablet,
  }) {
    final profileSize = isNarrow ? 56.0 : (isTablet ? 64.0 : 60.0);
    final horizontalSpacing = isNarrow ? 16.0 : (isTablet ? 20.0 : 18.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image
          Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(profileSize / 2),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(profileSize / 2),
              child: Image.network(
                profileImage,
                width: profileSize,
                height: profileSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: profileSize * 0.5,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: horizontalSpacing),

          // Chat content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: isNarrow ? 4 : 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: isNarrow ? 14 : (isTablet ? 16 : 15),
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  maxLines: isTablet ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
