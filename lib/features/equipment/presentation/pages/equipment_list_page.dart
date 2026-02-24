import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/features/equipment/presentation/bloc/equipment_bloc.dart';
import 'package:gym_bro/features/equipment/presentation/bloc/equipment_event.dart';
import 'package:gym_bro/features/equipment/presentation/bloc/equipment_state.dart';

class EquipmentListPage extends StatefulWidget {
  const EquipmentListPage({super.key});

  @override
  State<EquipmentListPage> createState() => _EquipmentListPageState();
}

class _EquipmentListPageState extends State<EquipmentListPage> {
  @override
  void initState() {
    super.initState();
    context.read<EquipmentBloc>().add(const LoadEquipmentList());
  }

  IconData _iconForEquipment(String equipment) {
    return switch (equipment.toLowerCase()) {
      'barbell' => Icons.fitness_center,
      'dumbbell' => Icons.fitness_center,
      'cable' => Icons.cable,
      'machine' => Icons.precision_manufacturing,
      'body weight' => Icons.accessibility_new,
      'kettlebell' => Icons.sports_handball,
      'band' => Icons.circle_outlined,
      'medicine ball' => Icons.sports_soccer,
      'ez barbell' => Icons.fitness_center,
      'bosu ball' => Icons.circle,
      'roller' => Icons.lens,
      'rope' => Icons.timeline,
      String() => Icons.sports_gymnastics,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment'), centerTitle: true),
      body: BlocBuilder<EquipmentBloc, EquipmentState>(
        builder: (context, state) {
          if (state is EquipmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EquipmentListLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: state.equipmentList.length,
              itemBuilder: (context, index) {
                final equipment = state.equipmentList[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/equipment/$equipment'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _iconForEquipment(equipment),
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          equipment,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (state is EquipmentError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
