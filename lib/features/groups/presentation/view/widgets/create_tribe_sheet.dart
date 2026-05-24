import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateTribeCubit>(
      create: (_) => _cubit,
      child: BlocListener<CreateTribeCubit, CreateTribeState>(
        listener: (context, state) {
          // handled in consumer below
        },
        child: BlocConsumer<CreateTribeCubit, CreateTribeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      children: [
                        // Handle
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
                          '+ Create your own',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: ColorManager.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Cover image picker
                        GestureDetector(
                          onTap: _pickImage,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: _pickedImage != null
                                ? Image.file(
                                    _pickedImage!,
                                    height: 160.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 160.h,
                                    color: ColorManager.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 48,
                                          color: ColorManager.primary
                                              .withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Add cover photo',
                                          style: TextStyle(
                                            color: ColorManager.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tribe name
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Tribe name',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Enter a tribe name'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        TextFormField(
                          controller: _descController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Enter a description'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Privacy
                        Text(
                          'Privacy',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        const SizedBox(height: 12),
                        PrivacyRow(
                          selected: _accessibility,
                          onChanged: (v) => setState(() => _accessibility = v),
                        ),
                        const SizedBox(height: 28),

                        // Create button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _cubit.doIntent(
                                        CreateTribeIntent(
                                          groupName: _nameController.text
                                              .trim(),
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
                                : const Text('Create Tribe'),
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
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }
}
