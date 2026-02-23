import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/target_muscle_bloc.dart';
import '../bloc/target_muscle_event.dart';
import '../bloc/target_muscle_state.dart';

class TargetMuscleListPage extends StatefulWidget {
  const TargetMuscleListPage({super.key});

  @override
  State<TargetMuscleListPage> createState() => _TargetMuscleListPageState();
}

class _TargetMuscleListPageState extends State<TargetMuscleListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TargetMuscleBloc>().add(const LoadTargetMuscleList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Target Muscle'), centerTitle: true),
      body: BlocBuilder<TargetMuscleBloc, TargetMuscleState>(
        builder: (context, state) {
          if (state is TargetMuscleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TargetMuscleListLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.muscles.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final muscle = state.muscles[index];
                final display = muscle[0].toUpperCase() + muscle.substring(1);
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.accessibility_new, size: 18),
                  ),
                  title: Text(display),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/target-muscle/$muscle'),
                );
              },
            );
          }
          if (state is TargetMuscleError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
