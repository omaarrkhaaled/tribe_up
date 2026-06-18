import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/create_tribe_sheet.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/search_bar_widget.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tab_bar_widget.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribes_header.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribes_list.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_ui_intents.dart';

class TribesScreen extends StatefulWidget {
  const TribesScreen({super.key});

  @override
  State<TribesScreen> createState() => _TribesScreenState();
}

class _TribesScreenState extends State<TribesScreen> {
  final ScrollController _scrollController = ScrollController();
  late final TribesListCubit _cubit;
  late final StreamSubscription<TribesUiIntents> _uiSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _cubit = getIt<TribesListCubit>()..doIntent(const LoadJoinedTribesIntent());
    _uiSubscription = _cubit.uiIntents.listen((intent) {
      if (!mounted) return;
      _handleUiIntent(context, intent, _cubit);
    });
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      _cubit.doIntent(const LoadMoreTribesIntent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _uiSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TribesListCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<TribesListCubit, TribesState>(
        builder: (context, state) {
          final cubit = _cubit;
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  TribesHeader(cubit: cubit),
                  SearchBarWidget(cubit: cubit, state: state),
                  TabBarWidget(cubit: cubit, state: state),
                  Expanded(
                    child: TribesList(cubit: cubit, state: state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleUiIntent(
    BuildContext context,
    TribesUiIntents intent,
    TribesListCubit cubit,
  ) async {
    switch (intent) {
      case NavigateToTribeProfileUiIntent(:final group):
        final didChange = await context.pushNamed<bool>(
          AppRoutesConstants.tribeProfile,
          extra: group,
        );
        if (didChange == true) {
          cubit.doIntent(const LoadJoinedTribesIntent());
          cubit.doIntent(const LoadDiscoverTribesIntent());
        }
      case ShowCreateTribeSheetUiIntent():
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: ColorManager.transparent,
          builder: (_) => CreateTribeSheet(
            onTribeCreated: (tribe) {
              // Reload joined after creation
              cubit.doIntent(const LoadJoinedTribesIntent());
            },
          ),
        );
      case ShowErrorUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
        );
    }
  }
}
