import 'package:flutter/material.dart';
import 'package:gym_bro/core/constatnts/app_constants.dart';

class BodyPartGridCard extends StatelessWidget {
  final String bodyPart;
  final BodyPartMeta meta;
  final VoidCallback onTap;

  const BodyPartGridCard({
    super.key,
    required this.bodyPart,
    required this.meta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [meta.color, meta.color.withOpacity(0.7)],
            ),
            boxShadow: [
              BoxShadow(
                color: meta.color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background icon (decorative)
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  meta.icon,
                  size: 80,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(meta.icon, color: Colors.white, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      meta.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
