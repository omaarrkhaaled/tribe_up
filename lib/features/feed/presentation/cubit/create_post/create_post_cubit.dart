import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/feed/domain/use_case/create_post_use_case.dart';
import 'package:tribe_up/features/story/domain/use_cases/create_story_use_case.dart';
import 'package:tribe_up/features/feed/presentation/cubit/create_post/create_post_states.dart';

@injectable
class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostUseCase _createPostUseCase;
  final CreateStoryUseCase _createStoryUseCase;

  CreatePostCubit(this._createPostUseCase, this._createStoryUseCase)
    : super(const CreatePostInitial());

  Future<void> createPost({
    required int groupId,
    required String caption,
    List<File>? mediaFiles,
  }) async {
    if (caption.trim().isEmpty && (mediaFiles == null || mediaFiles.isEmpty)) {
      emit(CreatePostError(UiConstants.postCannotBeEmpty));
      return;
    }

    emit(const CreatePostLoading());

    final response = await _createPostUseCase(
      groupId: groupId,
      caption: caption.trim(),
      accessibility: 0,
      mediaFiles: mediaFiles,
    );

    switch (response) {
      case SuccessResponse(:final data):
        emit(CreatePostSuccess(data));
      case ErrorResponse(:final error):
        emit(CreatePostError(error.message));
    }
  }

  Future<void> createStory({
    required int groupId,
    required String caption,
    required List<File> mediaFiles,
  }) async {
    if (mediaFiles.isEmpty) {
      emit(const CreatePostError('A story must contain a media file.'));
      return;
    }

    emit(const CreatePostLoading());

    final response = await _createStoryUseCase(
      groupId: groupId,
      caption: caption.trim(),
      accessibility: 0,
      mediaFile: mediaFiles.first,
    );

    switch (response) {
      case SuccessResponse(:final data):
        emit(CreateStorySuccess(data));
      case ErrorResponse(:final error):
        emit(CreatePostError(error.message));
    }
  }
}
