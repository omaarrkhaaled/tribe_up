import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/feed/presentation/cubit/create_post/create_post_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/create_post/create_post_states.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

class CreatePostSheet extends StatefulWidget {
  final List<Group> groups;
  final bool startAsPost;

  const CreatePostSheet({
    super.key,
    required this.groups,
    this.startAsPost = true,
  });

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostCubit>(
      create: (_) => getIt<CreatePostCubit>(),
      child: _CreatePostContent(
        groups: widget.groups,
        startAsPost: widget.startAsPost,
      ),
    );
  }
}

class _CreatePostContent extends StatefulWidget {
  final List<Group> groups;
  final bool startAsPost;

  const _CreatePostContent({required this.groups, this.startAsPost = true});

  @override
  State<_CreatePostContent> createState() => _CreatePostContentState();
}

class _CreatePostContentState extends State<_CreatePostContent> {
  final TextEditingController _captionController = TextEditingController();
  final List<File> _selectedFiles = [];
  late bool _isPost;
  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _isPost = widget.startAsPost;
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
        } else if (state is CreateStorySuccess) {
          UIUtils.showPremiumMessage(context, 'Story shared successfully');
          Navigator.pop(context, state.story);
        } else if (state is CreatePostError) {
          UIUtils.showPremiumMessage(
            context,
            state.errorMessage ?? UiConstants.failedToCreatePost,
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
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12, top: 4),
                    width: 40,
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
                        Icons.close_rounded,
                        color: ColorManager.black,
                        size: 26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      _isPost
                          ? UiConstants.createPost
                          : UiConstants.createStory,
                      style: _textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGrey.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPost = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
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
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              UiConstants.post,
                              style: _textTheme.titleMedium?.copyWith(
                                color: _isPost
                                    ? ColorManager.primary
                                    : ColorManager.grey,
                                fontWeight: _isPost
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPost = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
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
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              UiConstants.story,
                              style: _textTheme.titleMedium?.copyWith(
                                color: !_isPost
                                    ? ColorManager.primary
                                    : ColorManager.grey,
                                fontWeight: !_isPost
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: ColorManager.primary.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Group>(
                        value: _selectedGroup,
                        dropdownColor: ColorManager.white,
                        borderRadius: BorderRadius.circular(16),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: ColorManager.primary,
                        ),
                        hint: Text(
                          UiConstants.selectAGroup,
                          style: _textTheme.bodyMedium?.copyWith(
                            color: ColorManager.primary,
                            fontWeight: FontWeight.bold,
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.groups_rounded,
                                      color: ColorManager.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      g.groupName ?? '',
                                      style: _textTheme.bodyMedium?.copyWith(
                                        color: ColorManager.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGrey.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _captionController,
                    maxLines: 6,
                    minLines: 4,
                    style: _textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: ColorManager.black,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintText: _isPost
                          ? UiConstants.whatIsInYourMind
                          : UiConstants.writeStoryCaption,
                      hintStyle: _textTheme.bodyLarge?.copyWith(
                        color: ColorManager.grey.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (!_isPost && _selectedFiles.isEmpty)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ColorManager.primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: ColorManager.primary,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            UiConstants.addStoryMedia,
                            style: _textTheme.titleSmall?.copyWith(
                              color: ColorManager.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            UiConstants.storiesRequireMedia,
                            style: _textTheme.bodySmall?.copyWith(
                              color: ColorManager.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_selectedFiles.isNotEmpty)
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
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: ColorManager.lightGrey.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 1,
                                ),
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
                                    size: 14,
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
                if (_selectedFiles.isNotEmpty ||
                    (!_isPost && _selectedFiles.isEmpty))
                  const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorManager.lightGrey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: ColorManager.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    BlocBuilder<CreatePostCubit, CreatePostState>(
                      builder: (context, state) {
                        final isLoading = state is CreatePostLoading;
                        final bool isValid =
                            _selectedGroup != null &&
                            _selectedGroup!.id != null &&
                            (_isPost
                                ? (_captionController.text.trim().isNotEmpty ||
                                      _selectedFiles.isNotEmpty)
                                : _selectedFiles.isNotEmpty);

                        return SizedBox(
                          width: 140,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: (isLoading || !isValid)
                                ? null
                                : () {
                                    if (_isPost) {
                                      context
                                          .read<CreatePostCubit>()
                                          .createPost(
                                            groupId: _selectedGroup!.id!,
                                            caption: _captionController.text,
                                            mediaFiles: _selectedFiles,
                                          );
                                    } else {
                                      context
                                          .read<CreatePostCubit>()
                                          .createStory(
                                            groupId: _selectedGroup!.id!,
                                            caption: _captionController.text,
                                            mediaFiles: _selectedFiles,
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                gradient: (isLoading || !isValid)
                                    ? null
                                    : LinearGradient(
                                        colors: [
                                          ColorManager.primary,
                                          ColorManager.primary.withValues(
                                            alpha: 0.8,
                                          ),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                color: (isLoading || !isValid)
                                    ? ColorManager.lightGrey.withValues(
                                        alpha: 0.5,
                                      )
                                    : null,
                                boxShadow: isValid
                                    ? [
                                        BoxShadow(
                                          color: ColorManager.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _isPost
                                          ? UiConstants.sharePost
                                          : UiConstants.shareStory,
                                      style: _textTheme.titleMedium?.copyWith(
                                        color: ColorManager.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
