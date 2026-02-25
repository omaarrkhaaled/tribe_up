import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/feed/api/api_client/feed_api_client.dart';
import 'package:tribe_up/features/feed/api/models/feed_response.dart';
import 'package:tribe_up/features/feed/data/data_sources/feed_remote_data_source.dart';

@Injectable(as: FeedRemoteDataSource)
class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final FeedApiClient _apiClient;

  const FeedRemoteDataSourceImpl(this._apiClient);

  @override
  Future<FeedResponse> getFeedPosts({int page = 1, int pageSize = 20}) async {
    return await _apiClient.getFeed(page, pageSize);
  }
}
