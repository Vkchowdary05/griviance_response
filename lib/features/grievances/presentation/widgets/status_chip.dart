import 'package:flutter/material.dart';
import '../../domain/entities/grievance_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_utils.dart';

class StatusChip extends StatelessWidget {
  final GrievanceStatus status;
  final bool compact;

  const StatusChip({
    Key? key,
    required this.status,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
        ),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case GrievanceStatus.pending:
        return AppColors.statusPending;
      case GrievanceStatus.inProgress:
        return AppColors.statusInProgress;
      case GrievanceStatus.resolved:
        return AppColors.statusResolved;
      case GrievanceStatus.rejected:
        return AppColors.statusRejected;
    }
  }

  String _getStatusText() {
    switch (status) {
      case GrievanceStatus.pending:
        return 'Pending';
      case GrievanceStatus.inProgress:
        return 'In Progress';
      case GrievanceStatus.resolved:
        return 'Resolved';
      case GrievanceStatus.rejected:
        return 'Rejected';
    }
  }
}
