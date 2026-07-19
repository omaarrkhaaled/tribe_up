import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/use_cases/groups/create_group_use_case.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/create_tribe/create_tribe_ui_intents.dart';

@injectable
class CreateTribeCubit extends Cubit<CreateTribeState> {
  final CreateGroupUseCase _createGroupUseCase;

  final StreamController<CreateTribeUiIntents> _uiController =
      StreamController.broadcast();
  Stream<CreateTribeUiIntents> get uiIntents => _uiController.stream;

  CreateTribeCubit(this._createGroupUseCase) : super(const CreateTribeState());

  void doIntent(CreateTribeIntents intent) {
    switch (intent) {
      case CreateTribeIntent(
        :final groupName,
        :final description,
        :final accessibility,
        :final profilePicture,
      ):
        _createTribe(groupName, description, accessibility, profilePicture);
    }
  }

  Future<void> _createTribe(
    String groupName,
    String description,
    int accessibility,
    dynamic profilePicture,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final response = await _createGroupUseCase(
      groupName: groupName,
      description: description,
      accessibility: accessibility.toString(),
      profilePicture: profilePicture,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(isLoading: false, clearError: true));
        _uiController.add(TribeCreatedUiIntent(data));
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
