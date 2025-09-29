import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DepartmentDropdown extends StatelessWidget {
  final String? selectedDepartment;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const DepartmentDropdown({
    super.key,
    required this.selectedDepartment,
    required this.onChanged,
    this.validator,
  });

  static const List<String> departments = [
    'Public Works',
    'Water & Sanitation',
    'Transportation',
    'Health Services',
    'Education',
    'Environment',
    'Housing',
    'Social Services',
    'Revenue',
    'Police',
    'Fire Safety',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Department',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedDepartment,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Select Department',
            prefixIcon: const Icon(Icons.business_outlined),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          items: departments
              .map((department) => DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
