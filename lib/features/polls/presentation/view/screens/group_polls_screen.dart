import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/user_relation.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/login_local_data_source.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/presentation/view/widgets/create_edit_poll_sheet.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_cubit.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_states.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_intents.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_ui_intents.dart';

class GroupPollsScreen extends StatefulWidget {
  final Group group;

  const GroupPollsScreen({super.key, required this.group});

  @override
  State<GroupPollsScreen> createState() => _GroupPollsScreenState();
}

class _GroupPollsScreenState extends State<GroupPollsScreen> {
  late final PollsCubit _cubit;
  late final ScrollController _scrollController;
  late final StreamSubscription<PollsUiIntents> _uiSubscription;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit = getIt<PollsCubit>()
      ..doIntent(LoadPollsIntent(groupId: widget.group.id!));

    _uiSubscription = _cubit.uiIntents.listen((intent) {
      if (!mounted) return;
      _handleUiIntent(intent);
    });

    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userSummary = await getIt<LoginLocalDataSource>().getUserSummary();
    if (mounted) {
      setState(() {
        _currentUsername = userSummary?.userName;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.doIntent(LoadMorePollsIntent(groupId: widget.group.id!));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _uiSubscription.cancel();
    super.dispose();
  }

  void _handleUiIntent(PollsUiIntents intent) {
    switch (intent) {
      case ShowErrorUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
        );
      case ShowSuccessUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.primary,
        );
      default:
        break;
    }
  }

  void _openCreatePollSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: CreateEditPollSheet(groupId: widget.group.id!),
      ),
    );
  }

  void _openEditPollSheet(Poll poll) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: CreateEditPollSheet(pollToEdit: poll),
      ),
    );
  }

  void _showVotersDetails(PollOption option) {
    final voters = option.voters ?? [];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final sheetTextTheme = Theme.of(context).textTheme;
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UiConstants.votersForLabel(option.optionText ?? ''),
                style: sheetTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (voters.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      UiConstants.noVotesYet,
                      style: sheetTextTheme.bodyMedium?.copyWith(
                        color: ColorManager.grey,
                      ),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: voters.length,
                    itemBuilder: (context, index) {
                      final voter = voters[index];
                      final timeStr = voter.votedAt != null
                          ? voter.votedAt!.toLocal().toString().substring(0, 16)
                          : '';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ColorManager.primary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage:
                              voter.profilePictureUrl != null &&
                                  voter.profilePictureUrl!.isNotEmpty &&
                                  voter.profilePictureUrl != 'null'
                              ? CachedNetworkImageProvider(
                                  voter.profilePictureUrl!,
                                )
                              : null,
                          child:
                              voter.profilePictureUrl == null ||
                                  voter.profilePictureUrl!.isEmpty ||
                                  voter.profilePictureUrl == 'null'
                              ? Icon(Icons.person, color: ColorManager.primary)
                              : null,
                        ),
                        title: Text(
                          voter.userName ?? '',
                          style: sheetTextTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          UiConstants.votedAtLabel(timeStr),
                          style: sheetTextTheme.bodySmall?.copyWith(
                            color: ColorManager.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final relation = UserRelation.fromInt(widget.group.userRelation);
    final isAdminOrOwner =
        relation == UserRelation.admin || relation == UserRelation.owner;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider<PollsCubit>(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.group.groupName} - ${UiConstants.optionsLabel}",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                UiConstants.tribalDecisionDashboard,
                style: textTheme.bodySmall?.copyWith(color: ColorManager.grey),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorManager.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _cubit.doIntent(
                LoadPollsIntent(groupId: widget.group.id!, isRefresh: true),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openCreatePollSheet,
          backgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<PollsCubit, PollsState>(
          builder: (context, state) {
            if (state.isLoading && state.polls.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              );
            }

            if (state.polls.isEmpty) {
              return RefreshIndicator(
                color: ColorManager.primary,
                onRefresh: () async {
                  _cubit.doIntent(
                    LoadPollsIntent(groupId: widget.group.id!, isRefresh: true),
                  );
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.ballot_outlined,
                            size: 80,
                            color: ColorManager.lightGrey.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            UiConstants.noActivePolls,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            UiConstants.beFirstToCreatePoll,
                            style: textTheme.bodyMedium?.copyWith(
                              color: ColorManager.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _openCreatePollSheet,
                            icon: const Icon(Icons.add),
                            label: const Text(UiConstants.createPoll),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              foregroundColor: ColorManager.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: ColorManager.primary,
              onRefresh: () async {
                _cubit.doIntent(
                  LoadPollsIntent(groupId: widget.group.id!, isRefresh: true),
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: state.polls.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.polls.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        ),
                      ),
                    );
                  }

                  final poll = state.polls[index];
                  return _buildPollCard(poll, isAdminOrOwner, textTheme);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPollCard(Poll poll, bool isAdminOrOwner, TextTheme textTheme) {
    final isCreator =
        _currentUsername != null && poll.createdByUserName == _currentUsername;
    final isEditable = isCreator;
    final isDeletable = isCreator || isAdminOrOwner;
    final isExpired = poll.isExpired ?? false;

    // Check if the user has already voted for ANY option in this poll
    final hasVoted =
        poll.options?.any((o) => o.isVotedByCurrentUser == true) ?? false;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isExpired
              ? Colors.transparent
              : ColorManager.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Author details & Actions menu
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.primary.withValues(alpha: 0.1),
                  radius: 16,
                  child: Icon(
                    Icons.person_outline,
                    size: 16,
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "@${poll.createdByUserName ?? ''}",
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        poll.createdAt != null
                            ? "Created: ${poll.createdAt!.toLocal().toString().substring(0, 10)}"
                            : '',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: ColorManager.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expiry status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? ColorManager.red.withValues(alpha: 0.1)
                        : ColorManager.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isExpired ? UiConstants.expired : UiConstants.active,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isExpired ? ColorManager.red : ColorManager.green,
                    ),
                  ),
                ),

                // Actions (Edit/Delete) popup menu
                if (isEditable || isDeletable)
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'edit') {
                        _openEditPollSheet(poll);
                      } else if (val == 'delete') {
                        UIUtils.showPremiumDialog(
                          context: context,
                          message: UiConstants.deletePollConfirm,
                          posAction: () {
                            _cubit.doIntent(
                              DeletePollIntent(pollId: poll.pollId!),
                            );
                          },
                          negAction: () {},
                          posActionName: UiConstants.deleteAction,
                          negActionName: UiConstants.cancelAction,
                        );
                      }
                    },
                    icon: Icon(Icons.more_vert, color: ColorManager.lightGrey),
                    itemBuilder: (context) => [
                      if (isEditable)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text(UiConstants.editPoll),
                            ],
                          ),
                        ),
                      if (isDeletable)
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: ColorManager.red,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                UiConstants.deleteAction,
                                style: TextStyle(color: ColorManager.red),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Poll Question
            Text(
              poll.question ?? '',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),

            // Multiple Answers info badge
            if (poll.allowMultipleAnswers == true)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  UiConstants.multipleAnswersAllowed,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: ColorManager.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              const SizedBox(height: 8),

            // Options List
            Column(
              children: (poll.options ?? []).map((opt) {
                final isVoted = opt.isVotedByCurrentUser ?? false;
                final percentage = opt.percentage ?? 0.0;

                final showResults = hasVoted || isExpired;

                return GestureDetector(
                  onTap: () {
                    if (isExpired) {
                      _showVotersDetails(opt);
                      return;
                    }

                    _cubit.doIntent(
                      ToggleVoteIntent(
                        pollId: poll.pollId!,
                        optionId: opt.optionId!,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isVoted
                          ? ColorManager.primary.withValues(alpha: 0.05)
                          : ColorManager.notificationReadBackground.withValues(
                              alpha: 0.8,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isVoted
                            ? ColorManager.primary.withValues(alpha: 0.3)
                            : ColorManager.lightGrey.withValues(alpha: 0.1),
                        width: isVoted ? 1.5 : 1,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        // The progress bar container in the background
                        if (showResults)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            width:
                                MediaQuery.of(context).size.width *
                                (percentage / 100) *
                                0.8,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isVoted
                                  ? ColorManager.primary.withValues(alpha: 0.15)
                                  : ColorManager.primary.withValues(
                                      alpha: 0.05,
                                    ),
                            ),
                          ),

                        // Option details content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text & Selection Indicator
                              Expanded(
                                child: Row(
                                  children: [
                                    if (isVoted)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: ColorManager.primary,
                                          size: 18,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        opt.optionText ?? '',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: isVoted
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: ColorManager.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Vote percentages & counts
                              if (showResults)
                                Row(
                                  children: [
                                    Text(
                                      "${percentage.toStringAsFixed(1)}%",
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isVoted
                                            ? ColorManager.primary
                                            : ColorManager.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _showVotersDetails(opt),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorManager.lightGrey
                                              .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          "${opt.votesCount ?? 0} ${UiConstants.votes}",
                                          style: textTheme.bodySmall?.copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Footer: unique voters count & expiration text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${poll.totalUniqueVoters ?? 0} ${UiConstants.totalVoters}",
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.grey,
                  ),
                ),
                if (poll.expiresAt != null)
                  Text(
                    isExpired
                        ? UiConstants.closed
                        : UiConstants.endsLabel(
                            poll.expiresAt!.toLocal().toString().substring(
                              0,
                              16,
                            ),
                          ),
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: isExpired ? ColorManager.red : ColorManager.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
