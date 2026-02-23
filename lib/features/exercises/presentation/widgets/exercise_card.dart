import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({super.key, required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // GIF thumbnail
            CachedNetworkImage(
              imageUrl: exercise.gifUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 90,
                height: 90,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 90,
                height: 90,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Icon(Icons.fitness_center, size: 36),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _Tag(
                    color: Theme.of(context).colorScheme.primary,
                    label: exercise.primaryBodyPart,
                  ),
                  const SizedBox(height: 2),
                  _Tag(color: Colors.grey, label: exercise.primaryTarget),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final Color color;
  final String label;

  const _Tag({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
