import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribe_up/features/edit_profile/presentation/view/screens/image_cropper_screen.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/privacy_row.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_ui_intents.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

class CreateTribeSheet extends StatefulWidget {
  final ValueChanged<Group> onTribeCreated;

  const CreateTribeSheet({super.key, required this.onTribeCreated});

  @override
  State<CreateTribeSheet> createState() => _CreateTribeSheetState();
}

class _CreateTribeSheetState extends State<CreateTribeSheet> {
  late final CreateTribeCubit _cubit;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  int _accessibility = 0;
  File? _pickedImage;
  final _formKey = GlobalKey<FormState>();
  late final StreamSubscription<CreateTribeUiIntents> _uiSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CreateTribeCubit>();
    _uiSubscription = _cubit.uiIntents.listen((intent) {
      if (!mounted) return;
      switch (intent) {
        case TribeCreatedUiIntent(:final tribe):
          Navigator.pop(context);
          widget.onTribeCreated(tribe);
        case ShowErrorUiIntent(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: ColorManager.red),
          );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _uiSubscription.cancel();
    super.dispose();
  }

  late TextTheme textTheme;
  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateTribeCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<CreateTribeCubit, CreateTribeState>(
        builder: (context, state) {
          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 16),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: ColorManager.lightGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      Text(
                        UiConstants.createYOurOwnTribe,
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: _pickedImage != null
                              ? Image.file(
                                  _pickedImage!,
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 170,
                                  color: ColorManager.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: ColorManager.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        UiConstants.addCoverPhoto,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: ColorManager.black.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: UiConstants.tribeName,
                          hintText: UiConstants.enterTribeName,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? UiConstants.enterTribeName
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: UiConstants.description,
                          hintText: UiConstants.enterDescription,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? UiConstants.enterDescription
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        UiConstants.privacy,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrivacyRow(
                        selected: _accessibility,
                        onChanged: (v) => setState(() => _accessibility = v),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? () {} // this keep the primary backGround while loading
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _cubit.doIntent(
                                      CreateTribeIntent(
                                        groupName: _nameController.text.trim(),
                                        description: _descController.text
                                            .trim(),
                                        accessibility: _accessibility,
                                        profilePicture: _pickedImage,
                                      ),
                                    );
                                  }
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  UiConstants.createTribe,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        if (!mounted) return;
        final croppedFile = await Navigator.of(context).push<File>(
          MaterialPageRoute(
            builder: (context) =>
                ImageCropperScreen(imageFile: file, isCover: true),
          ),
        );

        if (croppedFile != null) {
          setState(() => _pickedImage = File(croppedFile.path));
        }
      }
    } finally {
      _isPickingImage = false;
    }
  }
}
