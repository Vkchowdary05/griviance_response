import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../bloc/grievance_bloc.dart';
import '../widgets/status_chip.dart';
import '../../domain/entities/grievance_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_utils.dart';

class GrievanceDetailPage extends StatefulWidget {
  final String grievanceId;

  const GrievanceDetailPage({
    super.key,
    required this.grievanceId,
  });

  @override
  State<GrievanceDetailPage> createState() => _GrievanceDetailPageState();
}

class _GrievanceDetailPageState extends State<GrievanceDetailPage> {
  GrievanceEntity? grievance;

  @override
  void initState() {
    super.initState();
    _loadGrievanceDetail();
  }

  void _loadGrievanceDetail() {
    // TODO: Implement load single grievance
    // For now, we'll simulate loading from the existing state
    final state = context.read<GrievanceBloc>().state;
    if (state is GrievanceLoadedState) {
      final foundGrievance = state.grievances.firstWhere(
        (g) => g.id == widget.grievanceId,
        orElse: () => state.grievances.first, // Fallback for demo
      );
      setState(() => grievance = foundGrievance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grievance Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareGrievance();
                  break;
                case 'report':
                  _reportGrievance();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: ListTile(
                  leading: Icon(Icons.flag),
                  title: Text('Report'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: grievance == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  grievance!.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              StatusChip(status: grievance!.status),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Status Timeline
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getPriorityColor().withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '${AppUtils.capitalizeFirst(grievance!.priority.value)} Priority',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getPriorityColor(),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'ID: #${grievance!.id.substring(0, 8).toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            grievance!.description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Image Section
                  if (grievance!.imageUrl != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Attached Image',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: grievance!.imageUrl!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Details Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildDetailRow(
                            'Department',
                            grievance!.departmentName ?? 'Not specified',
                            Icons.business,
                          ),
                          _buildDetailRow(
                            'Submitted By',
                            grievance!.citizenName ?? 'Unknown',
                            Icons.person,
                          ),
                          if (grievance!.officerName != null)
                            _buildDetailRow(
                              'Assigned Officer',
                              grievance!.officerName!,
                              Icons.badge,
                            ),
                          _buildDetailRow(
                            'Submitted On',
                            AppUtils.formatDateTime(grievance!.createdAt),
                            Icons.calendar_today,
                          ),
                          if (grievance!.locationAddress != null)
                            _buildDetailRow(
                              'Location',
                              grievance!.locationAddress!,
                              Icons.location_on,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement upvote
                            AppUtils.showSnackBar(context, 'Upvoted!');
                          },
                          icon: const Icon(Icons.thumb_up_outlined),
                          label: Text('Upvote (${grievance!.upvotes})'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _trackStatus,
                          icon: const Icon(Icons.track_changes),
                          label: const Text('Track Status'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor() {
    switch (grievance!.priority) {
      case GrievancePriority.low:
        return AppColors.success;
      case GrievancePriority.medium:
        return AppColors.warning;
      case GrievancePriority.high:
        return AppColors.error;
      case GrievancePriority.urgent:
        return const Color(0xFF7C2D12); // Dark red
    }
  }

  void _shareGrievance() {
    AppUtils.showSnackBar(context, 'Share functionality coming soon');
  }

  void _reportGrievance() {
    AppUtils.showSnackBar(context, 'Report functionality coming soon');
  }

  void _trackStatus() {
    AppUtils.showSnackBar(context, 'Status tracking coming soon');
  }
}
