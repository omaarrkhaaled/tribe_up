import 'package:tribe_up/features/feed/api/models/feed_response.dart';

abstract class FeedRemoteDataSource {
  Future<FeedResponse> getFeedPosts({int page, int pageSize});
}
