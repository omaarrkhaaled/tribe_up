import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';

class ActiveInvitationCard extends StatelessWidget {
  final InvitationResultDTO invitation;
  final bool isRevoking;
  final VoidCallback onRevoke;

  const ActiveInvitationCard({
    super.key,
    required this.invitation,
    required this.isRevoking,
    required this.onRevoke,
  });

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '-';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String _formatCreatedDate(String? isoDate) {
    if (isoDate == null) return 'Today';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return 'Today';
      }
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return 'Today';
    }
  }

  Widget _infoCell(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: ColorManager.grey),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: ColorManager.grey),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text(
          UiConstants.activeInvitation,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.lightGrey.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.lightGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  invitation.invitationUrl ?? '-',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: ColorManager.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 14),

              // Created / Expires row
              Row(
                children: [
                  _infoCell(
                    context,
                    icon: Icons.calendar_month_outlined,
                    label: UiConstants.created,
                    value: _formatCreatedDate(invitation.createdAt),
                  ),
                  const SizedBox(width: 16),
                  _infoCell(
                    context,
                    icon: Icons.hourglass_bottom_outlined,
                    label: 'Expires',
                    value: _formatDate(invitation.expiresAt),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Max Usage / Used Count row
              Row(
                children: [
                  _infoCell(
                    context,
                    icon: Icons.group_outlined,
                    label: 'Max Usage',
                    value: invitation.maxUses?.toString() ?? '∞',
                  ),
                  const SizedBox(width: 16),
                  _infoCell(
                    context,
                    icon: Icons.check_circle_outline,
                    label: 'Used Count',
                    value: invitation.usedCount?.toString() ?? '0',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Revoke / Copy link buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isRevoking ? null : onRevoke,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorManager.red,
                        side: BorderSide(color: ColorManager.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isRevoking
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorManager.red,
                              ),
                            )
                          : Text(UiConstants.revokeInvitation),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final url = invitation.invitationUrl;
                        if (url != null) {
                          Clipboard.setData(ClipboardData(text: url));
                          UIUtils.showPremiumMessage(
                            context,
                            UiConstants.inviteLinkCopied,
                            backgroundColor: ColorManager.primary,
                            icon: Icons.check_circle_outline,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorManager.black,
                        side: BorderSide(color: ColorManager.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(UiConstants.copyLink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
