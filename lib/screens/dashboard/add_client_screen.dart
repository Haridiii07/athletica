import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athletica/presentation/providers/coach_provider.dart';
import 'package:athletica/data/models/client.dart';
import 'package:athletica/utils/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:athletica/presentation/providers/auth_provider.dart';

class AddClientScreen extends ConsumerStatefulWidget {
  final String? clientId; // For editing existing client

  const AddClientScreen({super.key, this.clientId});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedStatus = 'active';
  String? _profilePhotoPath;
  final ImagePicker _picker = ImagePicker();

  final List<String> _statusOptions = ['active', 'inactive', 'pending'];

  @override
  void initState() {
    super.initState();
    if (widget.clientId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadClientData(widget.clientId!);
      });
    }
  }

  Future<void> _loadClientData(String clientId) async {
    try {
      final client = await ref.read(clientDetailsProvider(clientId).future);
      _nameController.text = client.name;
      _emailController.text = client.email ?? '';
      _phoneController.text = client.phone ?? '';
      _selectedStatus = client.status;
      _profilePhotoPath = client.profilePhotoUrl;
      if (mounted) setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.clientId != null;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Client' : 'Add New Client',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.errorRed),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo Section
                _buildProfilePhotoSection(),
                const SizedBox(height: 24),

                // Basic Information
                _buildSectionTitle('Basic Information'),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter client\'s full name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter client\'s email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number (Optional)',
                  hint: 'Enter client\'s phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                // Status Selection
                _buildSectionTitle('Client Status'),
                const SizedBox(height: 16),

                _buildStatusSelector(),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickProfilePhoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryBlue,
                  width: 3,
                ),
                color: AppTheme.cardBackground,
              ),
              child: _profilePhotoPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_profilePhotoPath!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.person_add,
                      size: 48,
                      color: AppTheme.primaryBlue,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _pickProfilePhoto,
            child: Text(
              _profilePhotoPath != null ? 'Change Photo' : 'Add Photo',
              style: const TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        hintStyle: const TextStyle(color: AppTheme.textGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.errorRed),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: _statusOptions.map((status) {
          final isSelected = _selectedStatus == status;
          return RadioListTile<String>(
            title: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              _getStatusDescription(status),
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            value: status,
            groupValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            activeColor: AppTheme.primaryBlue,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'active':
        return 'Client is actively training';
      case 'inactive':
        return 'Client is not currently training';
      case 'pending':
        return 'Client registration pending';
      default:
        return '';
    }
  }

  Widget _buildActionButtons(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              side: const BorderSide(color: AppTheme.borderColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveClient,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isEditing ? 'Update Client' : 'Add Client'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profilePhotoPath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final coach = await ref.read(currentCoachProvider.future);
      if (coach == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please sign in to add clients'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
        return;
      }

      final client = Client(
        id: widget.clientId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        coachId: coach.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        status: _selectedStatus,
        profilePhotoUrl: _profilePhotoPath,
        subscriptionProgress: 0.0,
        joinedAt: DateTime.now(),
        lastSession: null,
        goals: {},
        stats: {},
        sessionHistory: [],
      );

      if (widget.clientId != null) {
        // Update existing client
        final updateUseCase = ref.read(updateClientUseCaseProvider);
        await updateUseCase.call(client);
        ref.invalidate(clientsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Client updated successfully'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          context.pop();
        }
      } else {
        // Add new client
        final addUseCase = ref.read(addClientUseCaseProvider);
        await addUseCase.call(client);
        ref.invalidate(clientsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Client added successfully'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving client: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Delete Client',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete this client? This action cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (widget.clientId == null) return;
              context.pop();
              try {
                final deleteUseCase = ref.read(deleteClientUseCaseProvider);
                await deleteUseCase.call(widget.clientId!);
                ref.invalidate(clientsProvider);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Client deleted successfully'),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                  context.pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting client: $e'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
