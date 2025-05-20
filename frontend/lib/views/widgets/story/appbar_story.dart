import 'package:flutter/material.dart';
import 'package:frontend/data/user_data.dart';

class StoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserProfile user;
  final String materialTitle;
  final VoidCallback onHomePressed;
  final VoidCallback? onHintPressed;

  const StoryAppBar({
    super.key,
    required this.user,
    required this.onHomePressed,
    required this.materialTitle,
    this.onHintPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: onHomePressed,
                ),
                // Text(
                //   materialTitle,
                //   style: const TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                if (onHintPressed != null)
                  IconButton(
                    icon: const Icon(Icons.lightbulb_outline, color: Colors.amber),
                    onPressed: onHintPressed,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem('${user.completedMaterials}', 'Materi'),
                _buildInfoItem('${user.levelProgress.values.where((p) => p.isCompleted).length}', 'Level'),
                _buildInfoItem('${user.getLevelProgress('current').currentLives}', 'Nyawa',
                    icon: Icons.favorite, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String value, String label, {IconData? icon, Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(icon, color: color ?? Colors.white, size: 20)
        else
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}