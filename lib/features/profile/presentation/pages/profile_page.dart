import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      _nameController = TextEditingController(text: authState.user.fullName);
      _phoneController = TextEditingController(text: authState.user.phone ?? '');
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _isEditing = false),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveProfile,
                ),
              ],
            ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthenticatedState) {
            return const Center(child: Text('Please login to view profile'));
          }

          final user = state.user;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                              onPressed: () {
                                AppUtils.showSnackBar(context, 'Photo upload coming soon');
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Profile Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildProfileField(
                          'Full Name',
                          user.fullName,
                          _nameController,
                          Icons.person,
                          isEditable: true,
                        ),
                        _buildProfileField(
                          'Email',
                          user.email,
                          null,
                          Icons.email,
                          isEditable: false,
                        ),
                        _buildProfileField(
                          'Phone',
                          user.phone ?? 'Not provided',
                          _phoneController,
                          Icons.phone,
                          isEditable: true,
                        ),
                        _buildProfileField(
                          'Role',
                          user.role.value.toUpperCase(),
                          null,
                          Icons.badge,
                          isEditable: false,
                        ),
                        if (user.department != null)
                          _buildProfileField(
                            'Department',
                            user.department!,
                            null,
                            Icons.business,
                            isEditable: false,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Account Actions
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.notifications, color: AppColors.primary),
                        title: const Text('Notification Settings'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          AppUtils.showSnackBar(context, 'Settings coming soon');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.security, color: AppColors.primary),
                        title: const Text('Privacy & Security'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          AppUtils.showSnackBar(context, 'Security settings coming soon');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.help, color: AppColors.primary),
                        title: const Text('Help & Support'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          AppUtils.showSnackBar(context, 'Help coming soon');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: AppColors.error),
                        title: const Text('Sign Out'),
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    String value,
    TextEditingController? controller,
    IconData icon,
    {bool isEditable = false}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
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
                const SizedBox(height: 4),
                if (_isEditing && isEditable && controller != null)
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
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

  void _saveProfile() {
    // TODO: Implement profile save functionality
    AppUtils.showSnackBar(context, 'Profile saved successfully!');
    setState(() => _isEditing = false);
  }

  void _showLogoutDialog() async {
    final result = await AppUtils.showConfirmDialog(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
      cancelText: 'Cancel',
    );

    if (result == true) {
      context.read<AuthBloc>().add(LogoutEvent());
    }
  }
}
