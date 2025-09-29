import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/grievance_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:grievance_system/features/auth/presentation/widgets/custom_button.dart';
import 'package:grievance_system/features/auth/presentation/widgets/custom_text_field.dart';
import '../widgets/department_dropdown.dart';
import '../../domain/entities/grievance_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class CreateGrievancePage extends StatefulWidget {
  const CreateGrievancePage({super.key});

  @override
  State<CreateGrievancePage> createState() => _CreateGrievancePageState();
}

class _CreateGrievancePageState extends State<CreateGrievancePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedDepartment;
  GrievancePriority _selectedPriority = GrievancePriority.medium;
  File? _selectedImage;
  Position? _currentLocation;
  String? _locationAddress;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      final position = await LocationService.getCurrentPosition();
      final address = await LocationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      setState(() {
        _currentLocation = position;
        _locationAddress = address;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      AppUtils.showSnackBar(context, 'Could not get location: ${e.toString()}', isError: true);
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitGrievance() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthenticatedState) {
      AppUtils.showSnackBar(context, 'Please login first', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    // TODO: Upload image if selected
    String? imageUrl;
    if (_selectedImage != null) {
      // Implement image upload logic here
      // imageUrl = await uploadImage(_selectedImage!);
    }

    context.read<GrievanceBloc>().add(
      CreateGrievanceEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        departmentId: _selectedDepartment ?? '1', // Default department ID
        citizenId: authState.user.id,
        locationLat: _currentLocation?.latitude,
        locationLng: _currentLocation?.longitude,
        locationAddress: _locationAddress,
        imageUrl: imageUrl,
        priority: _selectedPriority,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Grievance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<GrievanceBloc, GrievanceState>(
        listener: (context, state) {
          setState(() => _isSubmitting = state is GrievanceLoadingState);

          if (state is GrievanceCreatedState) {
            AppUtils.showSnackBar(context, '✅ Grievance submitted successfully!');
            context.go(RouteConstants.dashboard);
          } else if (state is GrievanceErrorState) {
            AppUtils.showSnackBar(context, state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Describe Your Issue',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Provide clear details to help us resolve your grievance quickly.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                
                CustomTextField(
                  label: 'Title',
                  hint: 'Brief description of the issue',
                  controller: _titleController,
                  validator: Validators.grievanceTitle,
                  prefixIcon: const Icon(Icons.title),
                ),
                const SizedBox(height: 24),
                
                DepartmentDropdown(
                  selectedDepartment: _selectedDepartment,
                  onChanged: (value) => setState(() => _selectedDepartment = value),
                  validator: (value) => Validators.required(value, 'Department'),
                ),
                const SizedBox(height: 24),
                
                CustomTextField(
                  label: 'Description',
                  hint: 'Detailed explanation of the issue',
                  controller: _descriptionController,
                  validator: Validators.grievanceDescription,
                  maxLines: 6,
                  maxLength: 1000,
                  prefixIcon: const Icon(Icons.description),
                ),
                const SizedBox(height: 24),
                
                const Text(
                  'Priority Level',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: GrievancePriority.values.map((priority) {
                    return ChoiceChip(
                      label: Text(AppUtils.capitalizeFirst(priority.value)),
                      selected: _selectedPriority == priority,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedPriority = priority);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Location Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primary),
                            const SizedBox(width: 8),
                            const Text(
                              'Location',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            if (_isLoadingLocation)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _getCurrentLocation,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _locationAddress ?? 'Getting location...',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Image Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.camera_alt, color: AppColors.primary),
                            const SizedBox(width: 8),
                            const Text(
                              'Add Photo (Optional)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.add_photo_alternate),
                              label: const Text('Add Photo'),
                            ),
                          ],
                        ),
                        if (_selectedImage != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => setState(() => _selectedImage = null),
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            label: const Text(
                              'Remove Photo',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                CustomButton(
                  text: 'Submit Grievance',
                  onPressed: _submitGrievance,
                  isLoading: _isSubmitting,
                  icon: const Icon(Icons.send),
                ),
                const SizedBox(height: 16),
                
                const Center(
                  child: Text(
                    'Your grievance will be reviewed and assigned to the appropriate department.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
