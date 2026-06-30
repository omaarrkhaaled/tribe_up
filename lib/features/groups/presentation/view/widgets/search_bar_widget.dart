import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_states.dart';

class SearchBarWidget extends StatelessWidget {
  final TribesListCubit cubit;
  final TribesState state;
  const SearchBarWidget({super.key, required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDiscover = state.currentTab == TribesTab.discover;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: !isDiscover
          ? const SizedBox.shrink()
          : TextField(
              onChanged: (query) => cubit.doIntent(SearchTribesIntent(query)),
              decoration: InputDecoration(
                hintText: UiConstants.searchTribes,
                prefixIcon: Icon(Icons.search, color: ColorManager.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ColorManager.lightGrey.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
    );
  }
}
