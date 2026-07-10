import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_states.dart';

class PollsGroupsScreen extends StatefulWidget {
  const PollsGroupsScreen({super.key});

  @override
  State<PollsGroupsScreen> createState() => _PollsGroupsScreenState();
}

class _PollsGroupsScreenState extends State<PollsGroupsScreen> {
  late final TribesListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TribesListCubit>()..doIntent(const LoadJoinedTribesIntent());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider<TribesListCubit>(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            UiConstants.selectTribeForPolls,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorManager.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<TribesListCubit, TribesState>(
          builder: (context, state) {
            final joinedTribes = state.joinedTribes;
            final isLoading = state.isLoadingJoined;

            if (isLoading && joinedTribes.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              );
            }

            if (joinedTribes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.poll_outlined,
                      size: 72,
                      color: ColorManager.lightGrey.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      UiConstants.havenotJoinedTribesYet,
                      style: textTheme.titleMedium?.copyWith(
                        color: ColorManager.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      UiConstants.joinTribeToViewOrCreatePolls,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorManager.lightGrey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: joinedTribes.length,
              itemBuilder: (context, index) {
                final group = joinedTribes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.pushNamed(
                        AppRoutesConstants.groupPolls,
                        extra: group,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Profile image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorManager.primary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child:
                                group.groupProfilePicture != null &&
                                    group.groupProfilePicture!.isNotEmpty &&
                                    group.groupProfilePicture != 'null' &&
                                    group.groupProfilePicture != 'undefined' &&
                                    group.groupProfilePicture!.startsWith(
                                      'http',
                                    )
                                ? CachedNetworkImage(
                                    imageUrl: group.groupProfilePicture!,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Icon(
                                      Icons.groups,
                                      color: ColorManager.primary,
                                      size: 30,
                                    ),
                                  )
                                : Icon(
                                    Icons.groups,
                                    color: ColorManager.primary,
                                    size: 30,
                                  ),
                          ),
                          const SizedBox(width: 16),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.groupName ?? '',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  group.description ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: ColorManager.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 14,
                                      color: ColorManager.lightGrey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      UiConstants.membersCountLabel(
                                        group.membersCount ?? 0,
                                      ),
                                      style: textTheme.bodySmall?.copyWith(
                                        color: ColorManager.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: ColorManager.lightGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
