

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  void show(BuildContext context) {
    Get.bottomSheet(
      this,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Share',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(
                Icons.link,
                'Copy link',
                    () {
                  Get.back();
                  Get.snackbar('Link Copied', 'Link copied to clipboard');
                },
              ),
              _buildShareOption(
                Icons.music_note,
                'TikTok',
                    () {
                  Get.back();
                  Get.snackbar('Share', 'Opening TikTok...');
                },
              ),
              _buildShareOption(
                Icons.facebook,
                'Facebook',
                    () {
                  Get.back();
                  Get.snackbar('Share', 'Opening Facebook...');
                },
              ),
              _buildShareOption(
                Icons.camera_alt,
                'Instagram',
                    () {
                  Get.back();
                  Get.snackbar('Share', 'Opening Instagram...');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
