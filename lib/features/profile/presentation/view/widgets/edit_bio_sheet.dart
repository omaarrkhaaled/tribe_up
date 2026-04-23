import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_states.dart';

class EditBioSheet extends StatefulWidget {
  final EditProfileCubit cubit;

  const EditBioSheet({super.key, required this.cubit});

  @override
  State<EditBioSheet> createState() => _EditBioSheetState();
}

class _EditBioSheetState extends State<EditBioSheet> {
  late final TextEditingController _bioController;
  late final FocusNode _bioFocusNode;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.cubit.state.bio);
    _bioFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bioFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _bioFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider.value(
      value: widget.cubit,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: ColorManager.grey.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    UiConstants.updateYourBio,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    UiConstants.addAshortBioToTellPeopleMoreAboutYourself,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorManager.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _bioController,
                      focusNode: _bioFocusNode,
                      maxLines: 4,
                      maxLength: 150,
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: UiConstants.describeYourself,
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: ColorManager.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: ColorManager.lightGrey.withValues(
                          alpha: 0.05,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Update button
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<EditProfileCubit, EditProfileStates>(
                builder: (context, state) {
                  final isChanged =
                      state.data?.bio != _bioController.text.trim();
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isUpdatingBio || !isChanged
                          ? null
                          : () => widget.cubit.doIntent(
                              UpdateBioIntent(bio: _bioController.text.trim()),
                            ),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: state.isUpdatingBio
                            ? ColorManager.primary
                            : ColorManager.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: state.isUpdatingBio
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              UiConstants.update,
                              style: textTheme.titleLarge?.copyWith(
                                color: ColorManager.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
