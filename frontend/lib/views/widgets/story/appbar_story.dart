import 'package:flutter/material.dart';
import 'package:frontend/data/user_data.dart';

class StoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserProfile user;
  final String materialTitle;
  final int totalMaterials;
  final VoidCallback onHomePressed;
  final VoidCallback? onHintPressed;
  final int currentLives;
  final int maxLives;

  const StoryAppBar({
    super.key,
    required this.user,
    required this.materialTitle,
    this.totalMaterials = 10,
    required this.onHomePressed,
    this.onHintPressed,
    required this.currentLives,
    this.maxLives = 5,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final completedMaterials =
        user.levelProgress.values.where((p) => p.isCompleted).length;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
      ),
      leading: IconButton(
        onPressed: onHomePressed,
        icon: const Icon(Icons.home_rounded, color: Colors.amber, size: 28),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: Colors.black.withOpacity(0.5),
          //     borderRadius: BorderRadius.circular(20),
          //     border: Border.all(
          //       color: Colors.amber.withOpacity(0.5),
          //       width: 1,
          //     ),
          //   ),
          //   child: Text(
          //     materialTitle,
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 14,
          //       fontWeight: FontWeight.w600,
          //       fontFamily: 'Quicksand',
          //     ),
          //   ),
          // ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //berada di center
            children: [
              _buildProgressIndicator(completedMaterials, totalMaterials),
              const SizedBox(width: 16),
              _buildLivesIndicator(currentLives, maxLives),
            ],
          ),

          //tambahkan outline
        ],
      ),
      centerTitle: true,
      actions: [
        if (onHintPressed != null)
          IconButton(
            onPressed: onHintPressed,
            icon: Icon(
              Icons.lightbulb_circle_rounded,
              color: Colors.amber,
              size: 28,
            ),
          ),
      ],
    );
  }

  Widget _buildProgressIndicator(int completed, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
          const SizedBox(width: 6),
          Text(
            '$completed/$total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivesIndicator(int current, int max) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 4),
          Text(
            '$current/$max',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Quicksand',
            ),
          ),
        ],
        // children: List.generate(max, (index) {
        //   return Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 2),
        //     child: Icon(
        //       Icons.favorite_rounded,
        //       color: index < current ? Colors.transparent : Colors.red,
        //       size: 20,
        //     ),
        //   );
        // }),
      ),
    );
  }
}
