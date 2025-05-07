import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';

class CardKitab extends StatelessWidget {
  final LearningMaterial material;
  final VoidCallback? onTap;
  const CardKitab({super.key, required this.material, this.onTap});

 @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      material.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                material.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Progress and Score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressBar(),
                  if (material.score != null) _buildScoreBadge(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: material.isCompleted ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: material.isCompleted ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Text(
        material.isCompleted ? 'Completed' : 'In Progress',
        style: TextStyle(
          color: material.isCompleted ? Colors.green : Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: material.isCompleted ? 1.0 : 0.5,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              material.isCompleted ? Colors.green : Colors.orange,
            ),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 4),
          Text(
            material.isCompleted ? '100% completed' : '50% completed',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            'Score: ${material.score}',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
