import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/competing_tribes.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/leaderboard_entry_row.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_states.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UiConstants.leaderboard,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompetingTribesCard(tribesCount: state.entries.length),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LeaderboardState state) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      );
    }
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: ColorManager.lightGrey),
            const SizedBox(height: 16),
            Text(
              UiConstants.failedToLoadLeaderboard,
              style: textTheme.bodyLarge?.copyWith(color: ColorManager.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<LeaderboardCubit>().doIntent(
                  LoadLeaderboardIntent(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
              ),
              child: Text(
                UiConstants.retry,
                style: textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    if (state.entries.isEmpty) {
      return Center(
        child: Text(
          'No entries yet',
          style: textTheme.bodyLarge?.copyWith(color: ColorManager.grey),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RefreshIndicator(
        color: ColorManager.primary,
        onRefresh: () async {
          context.read<LeaderboardCubit>().doIntent(LoadLeaderboardIntent());
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: state.entries.length,
          itemBuilder: (context, index) {
            final entry = state.entries[index];
            return LeaderboardEntryRow(entry: entry, index: index);
          },
        ),
      ),
    );
  }
}
