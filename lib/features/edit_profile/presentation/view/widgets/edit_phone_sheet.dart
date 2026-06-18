import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:tribe_up/features/edit_profile/presentation/view_model/edit_profile_intents.dart';
import 'package:tribe_up/features/edit_profile/presentation/view_model/edit_profile_states.dart';

class EditPhoneSheet extends StatefulWidget {
  final EditProfileCubit cubit;

  const EditPhoneSheet({super.key, required this.cubit});

  @override
  State<EditPhoneSheet> createState() => _EditPhoneSheetState();
}

class _EditPhoneSheetState extends State<EditPhoneSheet> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.cubit.state.phoneNumber,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorManager.grey.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    UiConstants.updatePhoneNumber,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    UiConstants.enterPhoneToLinkWithAccount,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorManager.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      onChanged: (_) {
                        setState(() {}); // Immediate button state update
                      },
                      validator: (value) =>
                          Validator.validatePhoneNumber(value),
                      keyboardType: TextInputType.phone,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: UiConstants.phoneNumber,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: ColorManager.grey.withValues(alpha: 0.5),
                        ),
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
                  final length = _phoneController.text.trim().length;
                  final isNotEmpty = length == 11;
                  final isChanged =
                      state.data?.phoneNumber != _phoneController.text.trim();

                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          state.isLoading ||
                              state.isUpdatingPhone ||
                              !isNotEmpty ||
                              !isChanged
                          ? null
                          : () => widget.cubit.doIntent(
                              UpdatePhoneNumberIntent(
                                phoneNumber: _phoneController.text.trim(),
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: state.isUpdatingPhone
                            ? ColorManager.primary
                            : ColorManager.lightGrey.withValues(alpha: 0.6),
                      ),
                      child: state.isUpdatingPhone
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: ColorManager.white,
                                backgroundColor: ColorManager.white.withValues(
                                  alpha: 0.2,
                                ),
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
