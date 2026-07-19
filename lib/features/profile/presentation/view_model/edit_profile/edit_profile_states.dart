import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/features/profile/domain/entities/edit_profile_entity.dart';

class EditProfileStates extends BaseState<ProfileInfoEntity> {
  final String firstName;
  final String lastName;
  final String userName;
  final String phoneNumber;

  final String bio;
  final String profilePictureUrl;
  final String coverPictureUrl;

  final bool isUpdatingName;
  final bool isUpdatingBio;
  final bool isUpdatingPhone;
  final bool isUploadingPicture;
  final bool isUploadingCover;

  const EditProfileStates({
    super.data,
    super.isLoading = false,
    super.errorMessage,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.bio = '',
    this.profilePictureUrl = '',
    this.coverPictureUrl = '',
    this.isUpdatingName = false,
    this.isUpdatingBio = false,
    this.isUpdatingPhone = false,
    this.isUploadingPicture = false,
    this.isUploadingCover = false,
  });

  EditProfileStates copyWith({
    ProfileInfoEntity? data,
    bool? isLoading,
    String? errorMessage,
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? bio,
    String? profilePictureUrl,
    String? coverPictureUrl,
    bool? isUpdatingName,
    bool? isUpdatingBio,
    bool? isUpdatingPhone,
    bool? isUploadingPicture,
    bool? isUploadingCover,
  }) {
    return EditProfileStates(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      coverPictureUrl: coverPictureUrl ?? this.coverPictureUrl,
      isUpdatingName: isUpdatingName ?? this.isUpdatingName,
      isUpdatingBio: isUpdatingBio ?? this.isUpdatingBio,
      isUpdatingPhone: isUpdatingPhone ?? this.isUpdatingPhone,
      isUploadingPicture: isUploadingPicture ?? this.isUploadingPicture,
      isUploadingCover: isUploadingCover ?? this.isUploadingCover,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    firstName,
    lastName,
    userName,
    phoneNumber,
    bio,
    profilePictureUrl,
    coverPictureUrl,
    isUpdatingName,
    isUpdatingBio,
    isUpdatingPhone,
    isUploadingPicture,
    isUploadingCover,
  ];
}
