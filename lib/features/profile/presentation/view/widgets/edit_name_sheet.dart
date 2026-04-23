import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_states.dart';

class EditNameSheet extends StatefulWidget {
  final EditProfileCubit cubit;

  const EditNameSheet({super.key, required this.cubit});

  @override
  State<EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<EditNameSheet> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.cubit.state.data?.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.cubit.state.data?.lastName,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorManager.grey.withValues(alpha: .4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    UiConstants.updateYourName,
                    style: textTheme.headlineSmall?.copyWith(
                      color: ColorManager.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    UiConstants.enterYourNewFirstAndLastNames,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorManager.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _firstNameController,
                    label: UiConstants.firstName,
                    onChanged: (value) => widget.cubit.doIntent(
                      FirstNameChangedIntent(firstName: value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _lastNameController,
                    label: UiConstants.lastName,
                    onChanged: (value) => widget.cubit.doIntent(
                      LastNameChangedIntent(lastName: value),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<EditProfileCubit, EditProfileStates>(
                builder: (context, state) {
                  final isEnabled =
                      _firstNameController.text.isNotEmpty &&
                      _lastNameController.text.isNotEmpty;

                  final isNameChanged =
                      state.data?.firstName != _firstNameController.text ||
                      state.data?.lastName != _lastNameController.text;

                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: ColorManager.lightGrey,
                      ),
                      onPressed:
                          state.isUpdatingName || !isEnabled || !isNameChanged
                          ? null
                          : () => widget.cubit.doIntent(
                              UpdateNameIntent(
                                name:
                                    '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
                              ),
                            ),
                      child: state.isUpdatingName
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: ColorManager.white,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: (val) {
        onChanged(val);
        setState(() {});
      },
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: ColorManager.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: ColorManager.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
