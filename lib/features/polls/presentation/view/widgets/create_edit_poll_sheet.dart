import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_cubit.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_states.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_intents.dart';

class CreateEditPollSheet extends StatefulWidget {
  final int? groupId;
  final Poll? pollToEdit;

  const CreateEditPollSheet({super.key, this.groupId, this.pollToEdit});

  @override
  State<CreateEditPollSheet> createState() => _CreateEditPollSheetState();
}

class _CreateEditPollSheetState extends State<CreateEditPollSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;

  // For Create
  final List<TextEditingController> _optionControllers = [];
  bool _allowMultipleAnswers = false;
  DateTime? _expiresAt;

  // For Edit
  final List<TextEditingController> _newOptionControllers = [];

  bool get isEdit => widget.pollToEdit != null;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(
      text: widget.pollToEdit?.question,
    );

    if (isEdit) {
      // Edit mode: starts with 0 new options
      _addNewOptionField();
    } else {
      // Create mode: starts with 2 empty options
      _optionControllers.add(TextEditingController());
      _optionControllers.add(TextEditingController());
      // Default expiration: 3 days from now
      _expiresAt = DateTime.now().add(const Duration(days: 3));
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    for (var controller in _newOptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOptionField() {
    if (_optionControllers.length >= 10) {
      UIUtils.showPremiumMessage(context, UiConstants.maxOptionsError);
      return;
    }
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOptionField(int index) {
    if (_optionControllers.length <= 2) return;
    setState(() {
      final controller = _optionControllers.removeAt(index);
      controller.dispose();
    });
  }

  void _addNewOptionField() {
    if ((widget.pollToEdit?.options?.length ?? 0) +
            _newOptionControllers.length >=
        10) {
      UIUtils.showPremiumMessage(context, UiConstants.maxOptionsTotalError);
      return;
    }
    setState(() {
      _newOptionControllers.add(TextEditingController());
    });
  }

  void _removeNewOptionField(int index) {
    setState(() {
      final controller = _newOptionControllers.removeAt(index);
      controller.dispose();
    });
  }

  Future<void> _selectExpiryDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManager.primary,
              onPrimary: ColorManager.white,
              onSurface: ColorManager.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_expiresAt ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorManager.primary,
                onPrimary: ColorManager.white,
                onSurface: ColorManager.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _expiresAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (isEdit) {
      final newOptionsText = _newOptionControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      context.read<PollsCubit>().doIntent(
        UpdatePollIntent(
          pollId: widget.pollToEdit!.pollId!,
          request: EditPollRequest(
            question: _questionController.text.trim(),
            newOptions: newOptionsText.isEmpty ? null : newOptionsText,
          ),
        ),
      );
    } else {
      // Validate options
      final optionsText = _optionControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      if (optionsText.length < 2) {
        UIUtils.showPremiumMessage(context, UiConstants.minOptionsError);
        return;
      }

      context.read<PollsCubit>().doIntent(
        CreatePollIntent(
          groupId: widget.groupId!,
          request: CreatePollRequest(
            question: _questionController.text.trim(),
            options: optionsText,
            allowMultipleAnswers: _allowMultipleAnswers,
            expiresAt: _expiresAt?.toUtc().toIso8601String(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<PollsCubit, PollsState>(
      listenWhen: (prev, curr) => prev.isActionLoading && !curr.isActionLoading,
      listener: (context, state) {
        if (state.errorMessage == null) {
          // Success! Pop the sheet
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: ColorManager.lightGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  isEdit ? UiConstants.editPoll : UiConstants.createPoll,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Question Input
                Text(
                  UiConstants.questionLabel,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _questionController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return UiConstants.enterQuestionError;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: UiConstants.questionHint,
                    filled: true,
                    fillColor: ColorManager.notificationReadBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: ColorManager.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Options Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit
                          ? UiConstants.existingAndNewOptionsLabel
                          : UiConstants.optionsLabel,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isEdit)
                      TextButton.icon(
                        onPressed: _addOptionField,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(UiConstants.addOption),
                        style: TextButton.styleFrom(
                          foregroundColor: ColorManager.primary,
                        ),
                      )
                    else if ((widget.pollToEdit?.options?.length ?? 0) +
                            _newOptionControllers.length <
                        10)
                      TextButton.icon(
                        onPressed: _addNewOptionField,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(UiConstants.addOption),
                        style: TextButton.styleFrom(
                          foregroundColor: ColorManager.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // If editing, list existing options first (non-editable)
                if (isEdit) ...[
                  ...widget.pollToEdit!.options!.map((opt) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.notificationReadBackground
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorManager.lightGrey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: ColorManager.lightGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              opt.optionText ?? '',
                              style: textTheme.bodyMedium?.copyWith(
                                color: ColorManager.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Text warning message
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      UiConstants.existingOptionsWarning,
                      style: textTheme.bodySmall?.copyWith(
                        color: ColorManager.lightGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  // New options list
                  ..._newOptionControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: UiConstants.newOptionHint(index + 1),
                                filled: true,
                                fillColor:
                                    ColorManager.notificationReadBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: ColorManager.red,
                            ),
                            onPressed: () => _removeNewOptionField(index),
                          ),
                        ],
                      ),
                    );
                  }),
                ] else ...[
                  // Create options list
                  ..._optionControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              validator: (val) {
                                if (index < 2 &&
                                    (val == null || val.trim().isEmpty)) {
                                  return UiConstants.optionRequiredErrorLabel(
                                    index + 1,
                                  );
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: UiConstants.optionHint(index + 1),
                                filled: true,
                                fillColor:
                                    ColorManager.notificationReadBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          if (_optionControllers.length > 2)
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: ColorManager.red,
                              ),
                              onPressed: () => _removeOptionField(index),
                            ),
                        ],
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 16),

                // Only show MultiAnswer and Expiry picker in Create mode
                if (!isEdit) ...[
                  // Allow Multiple Answers Switch
                  SwitchListTile(
                    title: Text(
                      UiConstants.allowMultipleAnswers,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(UiConstants.multipleAnswersSubtitle),
                    value: _allowMultipleAnswers,
                    activeThumbColor: ColorManager.primary,
                    onChanged: (val) {
                      setState(() {
                        _allowMultipleAnswers = val;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),

                  // Expiry Date Selection
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      UiConstants.expirationDateTime,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _expiresAt == null
                          ? UiConstants.neverExpires
                          : _expiresAt!.toLocal().toString().substring(0, 16),
                    ),
                    trailing: Icon(
                      Icons.calendar_today,
                      color: ColorManager.primary,
                    ),
                    onTap: _selectExpiryDateTime,
                  ),
                  const Divider(),
                ],

                const SizedBox(height: 24),

                // Submit Button
                BlocBuilder<PollsCubit, PollsState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isActionLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          foregroundColor: ColorManager.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: state.isActionLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                isEdit
                                    ? UiConstants.saveChanges
                                    : UiConstants.createPoll,
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
