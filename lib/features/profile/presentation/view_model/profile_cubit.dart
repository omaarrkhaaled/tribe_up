import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_states.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_ui_intents.dart';
import 'dart:async';

@injectable
class ProfileCubit extends Cubit<ProfileStates> {
  final GetProfileUseCase _getProfileUseCase;
  final StreamController<ProfileUiIntents> _uiIntentsController =
      StreamController<ProfileUiIntents>.broadcast();

  Stream<ProfileUiIntents> get uiIntents => _uiIntentsController.stream;

  ProfileCubit(this._getProfileUseCase) : super(const ProfileStates());

  void doIntent(ProfileIntents intent) {
    switch (intent) {
      case GetProfileDetailsIntent():
        _getProfileDetails(intent.userName);
      case GetPersonalPostsIntent():
        _getPersonalPosts(intent.userName);
    }
  }

  Future<void> _getProfileDetails(String userName) async {
    emit(state.copyWith(isLoadingProfile: true));
    final response = await _getProfileUseCase(userName);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isLoadingProfile: false, profile: response.data));
      case ErrorResponse():
        emit(state.copyWith(isLoadingProfile: false));
        _uiIntentsController.add(
          ShowErrorProfileIntent(message: response.error.message),
        );
    }
  }

  Future<void> _getPersonalPosts(String userName) async {
    emit(state.copyWith(isLoadingPosts: true));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(isLoadingPosts: false));
  }

  @override
  Future<void> close() {
    _uiIntentsController.close();
    return super.close();
  }
}
