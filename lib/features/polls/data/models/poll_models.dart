import 'package:json_annotation/json_annotation.dart';

part 'poll_models.g.dart';

@JsonSerializable()
class Voter {
  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'profilePictureUrl')
  final String? profilePictureUrl;
  @JsonKey(name: 'votedAt')
  final DateTime? votedAt;

  Voter({this.userId, this.userName, this.profilePictureUrl, this.votedAt});

  factory Voter.fromJson(Map<String, dynamic> json) => _$VoterFromJson(json);
  Map<String, dynamic> toJson() => _$VoterToJson(this);
}

@JsonSerializable()
class PollOption {
  @JsonKey(name: 'optionId')
  final int? optionId;
  @JsonKey(name: 'optionText')
  final String? optionText;
  @JsonKey(name: 'votesCount')
  final int? votesCount;
  @JsonKey(name: 'percentage')
  final double? percentage;
  @JsonKey(name: 'isVotedByCurrentUser')
  final bool? isVotedByCurrentUser;
  @JsonKey(name: 'voters')
  final List<Voter>? voters;

  PollOption({
    this.optionId,
    this.optionText,
    this.votesCount,
    this.percentage,
    this.isVotedByCurrentUser,
    this.voters,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);
  Map<String, dynamic> toJson() => _$PollOptionToJson(this);
}

@JsonSerializable()
class Poll {
  @JsonKey(name: 'pollId')
  final int? pollId;
  @JsonKey(name: 'question')
  final String? question;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'expiresAt')
  final DateTime? expiresAt;
  @JsonKey(name: 'createdByUserName')
  final String? createdByUserName;
  @JsonKey(name: 'totalUniqueVoters')
  final int? totalUniqueVoters;
  @JsonKey(name: 'isExpired')
  final bool? isExpired;
  @JsonKey(name: 'allowMultipleAnswers')
  final bool? allowMultipleAnswers;
  @JsonKey(name: 'options')
  final List<PollOption>? options;

  Poll({
    this.pollId,
    this.question,
    this.createdAt,
    this.expiresAt,
    this.createdByUserName,
    this.totalUniqueVoters,
    this.isExpired,
    this.allowMultipleAnswers,
    this.options,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);
  Map<String, dynamic> toJson() => _$PollToJson(this);
}

@JsonSerializable()
class PollsPagedResult {
  @JsonKey(name: 'items')
  final List<Poll>? items;
  @JsonKey(name: 'page')
  final int? page;
  @JsonKey(name: 'pageSize')
  final int? pageSize;
  @JsonKey(name: 'totalCount')
  final int? totalCount;
  @JsonKey(name: 'hasMore')
  final bool? hasMore;

  PollsPagedResult({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasMore,
  });

  factory PollsPagedResult.fromJson(Map<String, dynamic> json) =>
      _$PollsPagedResultFromJson(json);
  Map<String, dynamic> toJson() => _$PollsPagedResultToJson(this);
}

@JsonSerializable()
class CreatePollRequest {
  @JsonKey(name: 'question')
  final String? question;
  @JsonKey(name: 'expiresAt')
  final String? expiresAt; // Format: DateTime ISO string
  @JsonKey(name: 'options')
  final List<String>? options;
  @JsonKey(name: 'allowMultipleAnswers')
  final bool? allowMultipleAnswers;

  CreatePollRequest({
    this.question,
    this.expiresAt,
    this.options,
    this.allowMultipleAnswers,
  });

  factory CreatePollRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePollRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePollRequestToJson(this);
}

@JsonSerializable()
class EditPollRequest {
  @JsonKey(name: 'question')
  final String? question;
  @JsonKey(name: 'newOptions')
  final List<String>? newOptions;

  EditPollRequest({this.question, this.newOptions});

  factory EditPollRequest.fromJson(Map<String, dynamic> json) =>
      _$EditPollRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EditPollRequestToJson(this);
}

@JsonSerializable()
class ToggleVoteResult {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'isVoted')
  final bool? isVoted;

  ToggleVoteResult({this.message, this.isVoted});

  factory ToggleVoteResult.fromJson(Map<String, dynamic> json) =>
      _$ToggleVoteResultFromJson(json);
  Map<String, dynamic> toJson() => _$ToggleVoteResultToJson(this);
}
