import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';

class TribesHeader extends StatefulWidget {
  final TribesListCubit cubit;

  const TribesHeader({super.key, required this.cubit});

  @override
  State<TribesHeader> createState() => _TribesHeaderState();
}

class _TribesHeaderState extends State<TribesHeader> {
  late TextTheme _textTheme;
  @override
  void didChangeDependencies() {
    _textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            UiConstants.tribes,
            style: _textTheme.headlineSmall?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => widget.cubit.doIntent(const OpenCreateTribeIntent()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    UiConstants.createYOurOwn,
                    style: _textTheme.titleLarge!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
