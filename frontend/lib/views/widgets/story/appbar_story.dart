import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/data/audio_provider.dart';
import 'package:provider/provider.dart';

class StoryAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<StoryAppBar> createState() => _StoryAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _StoryAppBarState extends State<StoryAppBar> {
  // @override
  // Size get preferredSize => const Size.fromHeight(80);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playAudio();
  }

  @override
  void dispose() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.pauseAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedMaterials =
        widget.user.levelProgress.values.where((p) => p.isCompleted).length;
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
        onPressed: widget.onHomePressed,
        icon: const Icon(Icons.home_rounded, color: Colors.amber, size: 28),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //berada di center
            children: [
              _buildProgressIndicator(
                completedMaterials,
                widget.totalMaterials,
              ),
              const SizedBox(width: 16),
              _buildLivesIndicator(widget.currentLives, widget.maxLives),
            ],
          ),

          //tambahkan outline
        ],
      ),
      centerTitle: true,
      actions: [
        if (widget.onHintPressed != null)
          IconButton(
            onPressed: widget.onHintPressed,
            icon: Icon(
              Icons.lightbulb_circle_rounded,
              color: Colors.amber,
              size: 28,
            ),
          ),
        Consumer<AudioProvider>(
          builder: (context, audioProvider, child) {
            return IconButton(
              icon: Icon(
                audioProvider.isMuted ? Icons.volume_off : Icons.volume_up,
              ),
              color: Colors.amber,
              onPressed: () {
                audioProvider.toggleMute();
              },
            );
          },
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
