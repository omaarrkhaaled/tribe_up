import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/domain/use_cases/edit_profile_use_cases.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile/edit_profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile/edit_profile_ui_intents.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/login_local_data_source.dart';
import 'package:tribe_up/features/auth/data/models/login_response/user_summary_model.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileStates> {
  final GetProfileInfoUseCase getProfileInfoUseCase;
  final UpdateCoverUseCase updateCoverUseCase;
  final UpdatePictureUseCase updatePictureUseCase;
  final UpdateNameUseCase updateNameUseCase;
  final UpdateBioUseCase updateBioUseCase;
  final UpdatePhoneUseCase updatePhoneNumberUseCase;
  final DeleteCoverUseCase deleteCoverUseCase;
  final DeleteBioUseCase deleteBioUseCase;
  final DeletePhoneUseCase deletePhoneNumberUseCase;
  final DeletePictureUseCase deletePictureUseCase;
  final LoginLocalDataSource loginLocalDataSource;

  EditProfileCubit({
    required this.getProfileInfoUseCase,
    required this.updateCoverUseCase,
    required this.updatePictureUseCase,
    required this.updateNameUseCase,
    required this.updateBioUseCase,
    required this.updatePhoneNumberUseCase,
    required this.deleteCoverUseCase,
    required this.deleteBioUseCase,
    required this.deletePhoneNumberUseCase,
    required this.deletePictureUseCase,
    required this.loginLocalDataSource,
  }) : super(const EditProfileStates());

  final StreamController<EditProfileUiIntents> _uiIntentsController =
      StreamController<EditProfileUiIntents>.broadcast();

  Stream<EditProfileUiIntents> get uiIntents => _uiIntentsController.stream;

  void doIntent(EditProfileIntents intent) {
    switch (intent) {
      case GetProfileInfoIntent():
        _getProfileInfo();
      case UploadCoverIntent():
        _uploadCover(intent.file);
      case RemoveCoverIntent():
        _removeCover();
      case UploadProfilePictureIntent():
        _uploadProfilePicture(intent.file);
      case RemoveProfilePictureIntent():
        _removeProfilePicture();
      case FirstNameChangedIntent():
        emit(state.copyWith(firstName: intent.firstName));
      case LastNameChangedIntent():
        emit(state.copyWith(lastName: intent.lastName));
      case UpdateNameIntent():
        _updateName();
      case UpdateBioIntent():
        _updateBio(intent.bio);
      case RemoveBioIntent():
        _deleteBio();
      case UpdatePhoneNumberIntent():
        _updatePhoneNumber(intent.phoneNumber);
      case RemovePhoneNumberIntent():
        _deletePhoneNumber();
    }
  }

  Future<void> _getProfileInfo({bool quiet = false}) async {
    if (!quiet) emit(state.copyWith(isLoading: true));
    final result = await getProfileInfoUseCase();
    switch (result) {
      case SuccessResponse(data: final data):
        final oldSummary = await loginLocalDataSource.getUserSummary();
        if (oldSummary != null) {
          await loginLocalDataSource.saveUserSummary(
            userSummary: UserSummaryModel(
              id: oldSummary.id,
              userName: data.userName,
              fullName: '${data.firstName} ${data.lastName}'.trim(),
              profilePicture: data.profilePicture,
            ),
          );
        }

        emit(
          state.copyWith(
            data: data,
            firstName: data.firstName,
            lastName: data.lastName,
            userName: data.userName,
            phoneNumber: data.phoneNumber,
            bio: data.bio,
            profilePictureUrl: data.profilePicture,
            coverPictureUrl: data.coverPicture,
            isLoading: false,
          ),
        );
      case ErrorResponse(error: final error):
        emit(state.copyWith(isLoading: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  // Cover

  Future<void> _uploadCover(File file) async {
    emit(state.copyWith(isUploadingCover: true));
    final result = await updateCoverUseCase(file);
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isUploadingCover: false));
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUploadingCover: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  Future<void> _removeCover() async {
    // Optimistic Update
    if (state.data != null) {
      emit(
        state.copyWith(
          isUploadingCover: true,
          coverPictureUrl: '',
          data: state.data!.copyWith(coverPicture: ''),
        ),
      );
    } else {
      emit(state.copyWith(isUploadingCover: true));
    }

    final result = await deleteCoverUseCase();
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isUploadingCover: false));
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUploadingCover: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  // Profile Picture

  Future<void> _uploadProfilePicture(File file) async {
    emit(state.copyWith(isUploadingPicture: true));
    final result = await updatePictureUseCase(file);
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isUploadingPicture: false));
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUploadingPicture: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  Future<void> _removeProfilePicture() async {
    // Optimistic Update
    if (state.data != null) {
      emit(
        state.copyWith(
          isUploadingPicture: true,
          profilePictureUrl: '',
          data: state.data!.copyWith(profilePicture: ''),
        ),
      );
    } else {
      emit(state.copyWith(isUploadingPicture: true));
    }

    final result = await deletePictureUseCase();
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isUploadingPicture: false));
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUploadingPicture: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  // Update Name

  Future<void> _updateName() async {
    emit(state.copyWith(isUpdatingName: true));
    final request = UpdateNameRequest(
      firstName: state.firstName,
      lastName: state.lastName,
    );
    final result = await updateNameUseCase(request);
    switch (result) {
      case SuccessResponse():
        // Optimistic update to local data
        if (state.data != null) {
          emit(
            state.copyWith(
              data: state.data!.copyWith(
                firstName: state.firstName,
                lastName: state.lastName,
              ),
            ),
          );
        }
        emit(state.copyWith(isUpdatingName: false));
        _uiIntentsController.add(DismissDialogIntent());
        _uiIntentsController.add(
          ShowSuccessIntent(message: UiConstants.nameUpdatedSuccessfully),
        );
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUpdatingName: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  // Update Bio

  Future<void> _updateBio(String bio) async {
    emit(state.copyWith(isUpdatingBio: true));
    final result = await updateBioUseCase(bio);
    switch (result) {
      case SuccessResponse():
        if (state.data != null) {
          emit(
            state.copyWith(
              bio: bio,
              data: state.data!.copyWith(bio: bio),
            ),
          );
        }
        emit(state.copyWith(isUpdatingBio: false));
        _uiIntentsController.add(DismissDialogIntent());
        _uiIntentsController.add(
          ShowSuccessIntent(message: UiConstants.bioUpdatedSuccessfully),
        );
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUpdatingBio: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  Future<void> _deleteBio() async {
    // Optimistic Update
    if (state.data != null) {
      emit(
        state.copyWith(
          isUpdatingBio: true,
          bio: '',
          data: state.data!.copyWith(bio: ''),
        ),
      );
    } else {
      emit(state.copyWith(isUpdatingBio: true));
    }

    final result = await deleteBioUseCase();
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isUpdatingBio: false));
        _uiIntentsController.add(
          ShowSuccessIntent(message: UiConstants.bioRemoved),
        );
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUpdatingBio: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  // Update Phone

  Future<void> _updatePhoneNumber(String phoneNumber) async {
    emit(state.copyWith(isUpdatingPhone: true));
    final result = await updatePhoneNumberUseCase(phoneNumber);
    switch (result) {
      case SuccessResponse():
        if (state.data != null) {
          emit(
            state.copyWith(
              phoneNumber: phoneNumber,
              data: state.data!.copyWith(phoneNumber: phoneNumber),
            ),
          );
        }
        emit(state.copyWith(isUpdatingPhone: false));
        _uiIntentsController.add(DismissDialogIntent());
        _uiIntentsController.add(
          ShowSuccessIntent(message: UiConstants.phoneUpdatedSuccessfully),
        );
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUpdatingPhone: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  Future<void> _deletePhoneNumber() async {
    // Optimistic Update
    if (state.data != null) {
      emit(
        state.copyWith(
          isUpdatingPhone: true,
          phoneNumber: '',
          data: state.data!.copyWith(phoneNumber: ''),
        ),
      );
    } else {
      emit(state.copyWith(isUpdatingPhone: true));
    }

    final result = await deletePhoneNumberUseCase();
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isUpdatingPhone: false));
        _uiIntentsController.add(
          ShowSuccessIntent(message: UiConstants.phoneNumberRemoved),
        );
        _getProfileInfo(quiet: true);
      case ErrorResponse(error: final error):
        emit(state.copyWith(isUpdatingPhone: false));
        _uiIntentsController.add(ShowErrorIntent(errorMessage: error.message));
    }
  }

  @override
  Future<void> close() {
    _uiIntentsController.close();
    return super.close();
  }
}
