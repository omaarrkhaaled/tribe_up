import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/feed/domain/use_case/feed_use_case.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_ui_intents.dart';

@injectable
class FeedCubit extends Cubit<FeedStates> {
  final FeedUseCase _feedUseCase;
  final StreamController<FeedUiIntents> _uiIntentController =
      StreamController();

  Stream<FeedUiIntents> get uiIntents => _uiIntentController.stream;

  FeedCubit(this._feedUseCase) : super(const FeedStates());

  void doIntent(FeedIntents intent) {
    switch (intent) {
      case SelectTabIntent(:final tab):
        _selectTab(tab);
        break;
      case LoadFeedIntent():
        _loadFeed();
        break;
      case RefreshFeedIntent():
        _loadFeed();
        break;
    }
  }

  void _selectTab(FeedNavTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void _loadFeed() async {
    emit(state.copyWith(isLoading: true));
    final response = await _feedUseCase(page: 1, pageSize: 20);
    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(posts: data.posts, isLoading: false, error: null));
        break;
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false, error: error.message));
        break;
    }
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}
