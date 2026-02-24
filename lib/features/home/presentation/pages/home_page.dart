import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/core/constatnts/app_constants.dart';
import '../widgets/body_part_grid_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyParts = AppConstants.bodyPartMeta.entries.toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/workouts'),
        icon: const Icon(Icons.fitness_center),
        label: const Text('My Workouts'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: [
          // ── Compact pinned app bar ──────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 0,
            toolbarHeight: 64,
            backgroundColor: const Color(0xFF0A0A0A),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Logo mark
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBF360C), Color(0xFFFF4500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'GymBro',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => context.push('/search'),
              ),
              const SizedBox(width: 4),
            ],
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
              child: Text(
                'BROWSE BY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _BrowseButton(
                    label: 'Equipment',
                    icon: Icons.sports_gymnastics,
                    onTap: () => context.push('/equipment'),
                  ),
                  const SizedBox(width: 10),
                  _BrowseButton(
                    label: 'Target Muscle',
                    icon: Icons.accessibility_new,
                    onTap: () => context.push('/target-muscle'),
                  ),
                  const SizedBox(width: 10),
                  _BrowseButton(
                    label: 'All Exercises',
                    icon: Icons.list_alt,
                    onTap: () => context.push('/exercises'),
                  ),
                ],
              ),
            ),
          ),

          // ── Body Parts header ───────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
              child: Text(
                'BODY PARTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // ── Body part grid ──────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final entry = bodyParts[index];
                return BodyPartGridCard(
                  bodyPart: entry.key,
                  meta: entry.value,
                  onTap: () => context.push('/body-part/${entry.key}'),
                );
              }, childCount: bodyParts.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BrowseButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFFFF4500)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
