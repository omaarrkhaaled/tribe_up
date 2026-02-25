import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/feed/data/models/feed_response.dart';

part 'feed_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class FeedApiClient {
  @factoryMethod
  factory FeedApiClient(Dio dio, {ParseErrorLogger? errorLogger}) =
      _FeedApiClient;

  @GET(ApiConstants.feedEndPoint)
  Future<FeedResponse> getFeed(
    @Query(UiConstants.page) int page,
    @Query(UiConstants.pageSize) int pageSize,
  );
}
