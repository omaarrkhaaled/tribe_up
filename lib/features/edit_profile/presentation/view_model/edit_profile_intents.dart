import 'dart:io';

sealed class EditProfileIntents {}

class GetProfileInfoIntent extends EditProfileIntents {}

class UploadCoverIntent extends EditProfileIntents {
  final File file;
  UploadCoverIntent({required this.file});
}

class RemoveCoverIntent extends EditProfileIntents {}

class UploadProfilePictureIntent extends EditProfileIntents {
  final File file;
  UploadProfilePictureIntent({required this.file});
}

class RemoveProfilePictureIntent extends EditProfileIntents {}

class FirstNameChangedIntent extends EditProfileIntents {
  final String firstName;
  FirstNameChangedIntent({required this.firstName});
}

class LastNameChangedIntent extends EditProfileIntents {
  final String lastName;
  LastNameChangedIntent({required this.lastName});
}

class UpdateNameIntent extends EditProfileIntents {
  final String name;
  UpdateNameIntent({required this.name});
}

class UpdateBioIntent extends EditProfileIntents {
  final String bio;
  UpdateBioIntent({required this.bio});
}

class RemoveBioIntent extends EditProfileIntents {}

class UpdatePhoneNumberIntent extends EditProfileIntents {
  final String phoneNumber;
  UpdatePhoneNumberIntent({required this.phoneNumber});
}

class RemovePhoneNumberIntent extends EditProfileIntents {}
