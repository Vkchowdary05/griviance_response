import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/grievance_bloc.dart';
import '../widgets/grievance_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../domain/entities/grievance_entity.dart';  // ✅ Needed for `GrievanceStatus.value`


class GrievanceListPage extends StatefulWidget {
  const GrievanceListPage({Key? key}) : super(key: key);

  @override
  State<GrievanceListPage> createState() => _GrievanceListPageState();
}

class _GrievanceListPageState extends State<GrievanceListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final statuses = [null, 'pending', 'in_progress', 'resolved', 'rejected'];
    final newStatus = statuses[_tabController.index];

    if (_selectedStatus != newStatus) {
      setState(() => _selectedStatus = newStatus);
      context.read<GrievanceBloc>().add(
            FilterGrievancesEvent(status: newStatus),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Grievances'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'sort_date':
                  // TODO: Sort by date
                  break;
                case 'sort_priority':
                  // TODO: Sort by priority
                  break;
                case 'sort_upvotes':
                  // TODO: Sort by upvotes
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort_date',
                child: ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Sort by Date'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'sort_priority',
                child: ListTile(
                  leading: Icon(Icons.priority_high),
                  title: Text('Sort by Priority'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'sort_upvotes',
                child: ListTile(
                  leading: Icon(Icons.thumb_up),
                  title: Text('Sort by Upvotes'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Resolved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<GrievanceBloc, GrievanceState>(
                  builder: (context, state) {
                    if (state is GrievanceLoadedState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            'Total',
                            state.grievances.length.toString(),
                            AppColors.primary,
                          ),
                          _buildSummaryItem(
                            'Pending',
                            state.grievances
                                .where((g) => g.status.value == 'pending')
                                .length
                                .toString(),
                            AppColors.statusPending,
                          ),
                          _buildSummaryItem(
                            'Resolved',
                            state.grievances
                                .where((g) => g.status.value == 'resolved')
                                .length
                                .toString(),
                            AppColors.statusResolved,
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),

          // Grievance List
          Expanded(
            child: BlocBuilder<GrievanceBloc, GrievanceState>(
              builder: (context, state) {
                if (state is GrievanceLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GrievanceErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<GrievanceBloc>().add(
                                RefreshGrievancesEvent(),
                              ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is GrievanceLoadedState) {
                  if (state.grievances.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedStatus == null
                                ? 'No grievances found'
                                : 'No ${_selectedStatus!.replaceAll('_', ' ')} grievances',
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () =>
                                context.push(RouteConstants.createGrievance),
                            icon: const Icon(Icons.add),
                            label: const Text('Submit New Grievance'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<GrievanceBloc>()
                          .add(RefreshGrievancesEvent());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.grievances.length,
                      itemBuilder: (context, index) {
                        final grievance = state.grievances[index];
                        return GrievanceCard(
                          grievance: grievance,
                          onTap: () => context.push(
                            RouteConstants.grievanceDetail
                                .replaceAll(':id', grievance.id),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteConstants.createGrievance),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
