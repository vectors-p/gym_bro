import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../../exercises/presentation/widgets/exercise_card.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({super.key, this.initialQuery = ''});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  late final SearchBloc _searchBloc; // ← declare the field

  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>(); // ← now this works
    _controller = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      _searchBloc.add(SearchQueryChanged(widget.initialQuery));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchBloc.add(const SearchCleared());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search exercises...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _searchBloc.add(const SearchCleared());
              },
            ),
          ),
          onChanged: (query) {
            _searchBloc.add(SearchQueryChanged(query));
          },
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Search by exercise name',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    '${state.results.length} results for "${state.query}"',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final exercise = state.results[index];
                      return ExerciseCard(
                        exercise: exercise,
                        onTap: () => context.push(
                          '/exercises/${exercise.id}',
                          extra: exercise,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is SearchEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No results for "${state.query}"'),
                ],
              ),
            );
          }
          if (state is SearchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Search unavailable, try again'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _searchBloc.add(SearchQueryChanged(_controller.text)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
