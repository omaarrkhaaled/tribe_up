import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/feed/data/data_sources/feed_remote_data_source.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@Injectable(as: FeedRepository)
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _remoteDataSource;

  const FeedRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<FeedResponseEntity>> getFeedPosts({
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall<FeedResponseEntity>(() async {
      final response = await _remoteDataSource.getFeedPosts(
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }
}
