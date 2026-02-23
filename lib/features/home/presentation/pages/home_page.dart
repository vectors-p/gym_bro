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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'GymApp 💪',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFBF360C), Color(0xFFE64A19)],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => context.push('/search'),
              ),
              IconButton(
                icon: const Icon(Icons.fitness_center),
                tooltip: 'My Workouts',
                onPressed: () => context.push('/workouts'),
              ),
            ],
          ),

          // Quick-access row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Browse By',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QuickChip(
                        label: 'Equipment',
                        icon: Icons.sports_gymnastics,
                        onTap: () => context.push('/equipment'),
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        label: 'Target Muscle',
                        icon: Icons.accessibility_new,
                        onTap: () => context.push('/target-muscle'),
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        label: 'All Exercises',
                        icon: Icons.list,
                        onTap: () => context.push('/exercises'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Section header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Body Parts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Body part grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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

class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
    );
  }
}
