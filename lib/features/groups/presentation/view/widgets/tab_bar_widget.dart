import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_states.dart';

class TabBarWidget extends StatelessWidget {
  final TribesListCubit cubit;
  final TribesState state;
  const TabBarWidget({super.key, required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorManager.lightGrey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: TribesTab.values
            .map(
              (tab) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    cubit.doIntent(SwitchTribesTabIntent(tab));
                    if (tab == TribesTab.discover &&
                        state.discoverTribes.isEmpty) {
                      cubit.doIntent(const LoadDiscoverTribesIntent());
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: state.currentTab == tab
                          ? ColorManager.white
                          : ColorManager.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: state.currentTab == tab
                          ? [
                              BoxShadow(
                                color: ColorManager.black.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      tab == TribesTab.joined
                          ? UiConstants.joinedIn
                          : UiConstants.discover,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: state.currentTab == tab
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: state.currentTab == tab
                            ? ColorManager.black
                            : ColorManager.grey,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
