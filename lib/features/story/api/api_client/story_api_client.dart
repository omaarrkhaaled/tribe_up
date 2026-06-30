import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/story/data/models/story_model.dart';
import 'package:tribe_up/features/story/data/models/story_feed_item_model.dart';

part 'story_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StoryApiClient {
  @factoryMethod
  factory StoryApiClient(Dio dio) = _StoryApiClient;

  @POST(ApiConstants.createStoryEndPoint)
  @MultiPart()
  Future<StoryModel> createStory(
    @Query('GroupId') int? groupId,
    @Query('Caption') String? caption,
    @Query('Accessibility') int accessibility,
    @Part(name: 'MediaFile') File mediaFile,
  );

  @DELETE(ApiConstants.deleteStoryEndPoint)
  Future<void> deleteStory(@Path('storyId') int storyId);

  @GET(ApiConstants.getGroupStoriesEndPoint)
  Future<List<StoryModel>> getGroupStories(@Path('groupId') int groupId);

  @GET(ApiConstants.getStoryFeedEndPoint)
  Future<List<StoryFeedItemModel>> getStoryFeed(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @PUT(ApiConstants.markAsViewedEndPoint)
  Future<void> markAsViewed(@Path('storyId') int storyId);
}
