import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/feed/presentation/cubit/create_post/create_post_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/create_post/create_post_states.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

class CreatePostSheet extends StatefulWidget {
  final List<Group> groups;

  const CreatePostSheet({super.key, required this.groups});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostCubit>(
      create: (_) => getIt<CreatePostCubit>(),
      child: _CreatePostContent(groups: widget.groups),
    );
  }
}

class _CreatePostContent extends StatefulWidget {
  final List<Group> groups;

  const _CreatePostContent({required this.groups});

  @override
  State<_CreatePostContent> createState() => _CreatePostContentState();
}

class _CreatePostContentState extends State<_CreatePostContent> {
  final TextEditingController _captionController = TextEditingController();
  final List<File> _selectedFiles = [];
  bool _isPost = true;
  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    if (widget.groups.isNotEmpty) {
      _selectedGroup = widget.groups.first;
    }
    _captionController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _captionController.removeListener(_onInputChanged);
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedFiles.add(File(picked.path));
      });
    }
  }

  late TextTheme _textTheme;
  @override
  void didChangeDependencies() {
    _textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostLoading) {
          EasyLoading.show(status: 'Posting...');
        } else {
          EasyLoading.dismiss();
        }

        if (state is CreatePostSuccess) {
          UIUtils.showPremiumMessage(
            context,
            UiConstants.postCreatedSuccessfully,
          );
          Navigator.pop(context, state.post);
        } else if (state is CreatePostError) {
          UIUtils.showPremiumMessage(
            context,
            UiConstants.failedToCreatePost,
            backgroundColor: ColorManager.red,
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: ColorManager.lightGrey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: ColorManager.black,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      UiConstants.createPost,
                      style: _textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.black,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGrey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPost = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isPost
                                  ? ColorManager.white
                                  : ColorManager.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _isPost
                                  ? [
                                      BoxShadow(
                                        color: ColorManager.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              UiConstants.post,
                              style: _textTheme.titleMedium?.copyWith(
                                color: _isPost
                                    ? ColorManager.black
                                    : ColorManager.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPost = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !_isPost
                                  ? ColorManager.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !_isPost
                                  ? [
                                      BoxShadow(
                                        color: ColorManager.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              UiConstants.story,
                              style: _textTheme.titleMedium?.copyWith(
                                color: !_isPost
                                    ? ColorManager.black
                                    : ColorManager.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (widget.groups.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: Text(
                      UiConstants.selectATribe,
                      style: _textTheme.bodyMedium?.copyWith(
                        color: ColorManager.grey,
                      ),
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Group>(
                          value: _selectedGroup,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: ColorManager.primary,
                          ),
                          hint: Text(
                            UiConstants.selectAGroup,
                            style: _textTheme.bodyMedium?.copyWith(
                              color: ColorManager.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onChanged: (group) {
                            setState(() {
                              _selectedGroup = group;
                            });
                          },
                          items: widget.groups
                              .where((g) => g.id != null)
                              .map(
                                (g) => DropdownMenuItem<Group>(
                                  value: g,
                                  child: Text(
                                    g.groupName ?? '',
                                    style: _textTheme.bodyMedium?.copyWith(
                                      color: ColorManager.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                TextField(
                  controller: _captionController,
                  maxLines: 10,
                  minLines: 4,
                  style: _textTheme.bodyLarge?.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: UiConstants.whatIsInYourMind,
                    hintStyle: _textTheme.bodyLarge?.copyWith(
                      color: ColorManager.grey.withValues(alpha: 0.5),
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),

                if (_selectedFiles.isNotEmpty)
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedFiles.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8, top: 8),
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorManager.black.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: FileImage(_selectedFiles[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 6,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFiles.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: ColorManager.black.withValues(
                                      alpha: 0.7,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ColorManager.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: ColorManager.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                if (_selectedFiles.isNotEmpty) const SizedBox(height: 16),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorManager.lightGrey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          color: ColorManager.primary,
                          size: 28,
                        ),
                      ),
                    ),

                    BlocBuilder<CreatePostCubit, CreatePostState>(
                      builder: (context, state) {
                        final isLoading = state is CreatePostLoading;
                        final bool isValid =
                            _selectedGroup != null &&
                            _selectedGroup!.id != null &&
                            (_captionController.text.trim().isNotEmpty ||
                                _selectedFiles.isNotEmpty);

                        return SizedBox(
                          width: 130,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: (isLoading || !isValid)
                                ? null
                                : () {
                                    context.read<CreatePostCubit>().createPost(
                                      groupId: _selectedGroup!.id!,
                                      caption: _captionController.text,
                                      mediaFiles: _selectedFiles,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              disabledBackgroundColor: ColorManager.primary
                                  .withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: isValid ? 4 : 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    UiConstants.post,
                                    style: _textTheme.titleMedium?.copyWith(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
