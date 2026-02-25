import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';

abstract class FeedRepository {
  Future<BaseResponse<FeedResponseEntity>> getFeedPosts({
    int page,
    int pageSize,
  });
}
