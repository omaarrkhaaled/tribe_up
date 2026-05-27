sealed class TribeSettingsUiIntents {
  const TribeSettingsUiIntents();
}

final class ShowErrorUiIntent extends TribeSettingsUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class ShowSuccessUiIntent extends TribeSettingsUiIntents {
  final String message;
  const ShowSuccessUiIntent(this.message);
}

final class TribeDeletedUiIntent extends TribeSettingsUiIntents {
  const TribeDeletedUiIntent();
}

final class SettingsSavedUiIntent extends TribeSettingsUiIntents {
  const SettingsSavedUiIntent();
}
