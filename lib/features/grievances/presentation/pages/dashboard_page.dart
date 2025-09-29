import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/grievance_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../widgets/grievance_card.dart';
import '../widgets/status_chip.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<GrievanceBloc>().add(
        LoadGrievancesEvent(userId: authState.user.id, userRole: authState.user.role),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthenticatedState) {
            return const Center(child: CircularProgressIndicator());
          }

          return IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeTab(authState.user),
              _buildGrievancesTab(authState.user),
              _buildProfileTab(authState.user),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            activeIcon: Icon(Icons.list),
            label: 'Grievances',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 
        ? FloatingActionButton(
            onPressed: () => context.push(RouteConstants.createGrievance),
            child: const Icon(Icons.add),
          )
        : null,
    );
  }

  Widget _buildHomeTab(UserEntity user) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Welcome, ${user.fullName.split(' ').first}'),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO: Navigate to notifications
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildListDelegate([
              _buildDashboardCard(
                title: 'Submit Grievance',
                icon: Icons.add_circle_outline,
                color: AppColors.primary,
                onTap: () => context.push(RouteConstants.createGrievance),
              ),
              _buildDashboardCard(
                title: 'My Grievances',
                icon: Icons.list_alt_outlined,
                color: AppColors.accent,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildDashboardCard(
                title: 'Track Status',
                icon: Icons.track_changes_outlined,
                color: AppColors.warning,
                onTap: () {
                  // TODO: Navigate to tracking
                },
              ),
              _buildDashboardCard(
                title: 'Emergency',
                icon: Icons.emergency_outlined,
                color: AppColors.error,
                onTap: () {
                  // TODO: Handle emergency grievance
                },
              ),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<GrievanceBloc, GrievanceState>(
                  builder: (context, state) {
                    if (state is GrievanceLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (state is GrievanceLoadedState) {
                      final recentGrievances = state.grievances.take(3).toList();
                      
                      if (recentGrievances.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text('No recent activity'),
                            ),
                          ),
                        );
                      }
                      
                      return Column(
                        children: recentGrievances
                            .map((grievance) => GrievanceCard(
                                  grievance: grievance,
                                  onTap: () => context.push(
                                    RouteConstants.grievanceDetail
                                        .replaceAll(':id', grievance.id),
                                  ),
                                ))
                            .toList(),
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrievancesTab(UserEntity user) {
    return Column(
      children: [
        AppBar(
          title: const Text('My Grievances'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                // TODO: Handle filter selection
                context.read<GrievanceBloc>().add(
                  FilterGrievancesEvent(status: value == 'all' ? null : value),
                );
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'all', child: Text('All')),
                const PopupMenuItem(value: 'pending', child: Text('Pending')),
                const PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
                const PopupMenuItem(value: 'resolved', child: Text('Resolved')),
                const PopupMenuItem(value: 'rejected', child: Text('Rejected')),
              ],
              child: const Icon(Icons.filter_list),
            ),
          ],
        ),
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
                      const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDashboardData,
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
                        const Text(
                          'No grievances found',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap the + button to submit your first grievance',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.push(RouteConstants.createGrievance),
                          icon: const Icon(Icons.add),
                          label: const Text('Submit Grievance'),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async => _loadDashboardData(),
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
    );
  }

  Widget _buildProfileTab(UserEntity user) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.textPrimary],
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: AppColors.primary),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileItem('Name', user.fullName),
                      _buildProfileItem('Email', user.email),
                      _buildProfileItem('Role', user.role.value.toUpperCase()),
                      if (user.department != null)
                        _buildProfileItem('Department', user.department!),
                      if (user.phone != null)
                        _buildProfileItem('Phone', user.phone!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to settings
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & Support'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to help
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Show about dialog
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
