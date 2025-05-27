import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mental_health_partner/config/routes.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_event.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';
import 'package:mental_health_partner/presentation/blocs/profile/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _goalsController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _dateOfBirthController;

  // Profile data
  double _stressLevel = 3.0;
  List<String> _selectedActivities = [];
  bool _isEditMode = false;
  File? _selectedImage;

  // Animation controller for tab transitions
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize controllers with empty values
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _bioController = TextEditingController();
    _goalsController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _dateOfBirthController = TextEditingController();

    // // Add a post-frame callback to populate fields once widget is built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final authState = context.read<AuthBloc>().state;
    //   if (authState is Authenticated) {
    //     _populateFieldsFromAuthState(authState);
    //   } else {
    //     // Refresh auth status to get latest user data
    //     context.read<AuthBloc>().add(CheckAuthStatus());
    //   }
    // });
  }

  @override
  void dispose() {
    // Dispose all controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _goalsController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _debugPrintFieldValues() {
    print('First Name: ${_firstNameController.text}');
    print('Last Name: ${_lastNameController.text}');
    print('Username: ${_usernameController.text}');
    print('Email: ${_emailController.text}');
    // Add other fields as needed
  }

  void _populateFieldsFromAuthState(Authenticated state) {
    setState(() {
      _firstNameController.text = state.user.firstName ?? '';
      _lastNameController.text = state.user.lastName ?? '';
      _bioController.text = state.user.bio ?? '';
      _goalsController.text = state.user.mentalHealthGoals ?? '';
      _usernameController.text = state.user.username;
      _emailController.text = state.user.email;
      _dateOfBirthController.text = state.user.dateOfBirth ?? '';
      _stressLevel = state.user.stressLevel?.toDouble() ?? 3.0;
      _selectedActivities = state.user.preferredActivities ?? [];
    });

    // Debug print to check if values are loaded
    _debugPrintFieldValues();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Upload immediately
      context.read<ProfileBloc>().add(UpdateProfilePicture(image.path));
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        // Restore original values when canceling edit mode
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          _populateFieldsFromAuthState(authState);
        }
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save profile data
      context.read<ProfileBloc>().add(
            UpdateProfile(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              bio: _bioController.text,
              mentalHealthGoals: _goalsController.text,
              stressLevel: _stressLevel,
              preferredActivities: _selectedActivities,
            ),
          );

      // Exit edit mode
      setState(() {
        _isEditMode = false;
      });
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content:
            const Text('Are you sure you want to log out from your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
              Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh user data after update
          context.read<AuthBloc>().add(GetUserRequested());

          // Important: Force a refresh of the UI with the new data
          Future.delayed(const Duration(milliseconds: 300), () {
            final authState = context.read<AuthBloc>().state;
            if (authState is Authenticated) {
              _populateFieldsFromAuthState(authState);
            }
          });
        } else if (state is ProfileOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ProfilePictureUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh user data after profile picture update
          context.read<AuthBloc>().add(GetUserRequested());

          // Important: Force a refresh of the UI with the new data
          Future.delayed(const Duration(milliseconds: 300), () {
            final authState = context.read<AuthBloc>().state;
            if (authState is Authenticated) {
              _populateFieldsFromAuthState(authState);
            }
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (authState is Authenticated) {
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      actions: [
                        if (!_isEditMode)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _toggleEditMode,
                            tooltip: 'Edit Profile',
                          ),
                        if (_isEditMode)
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: _saveProfile,
                            tooltip: 'Save Changes',
                          ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: _confirmLogout,
                          tooltip: 'Logout',
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          "${authState.user.firstName ?? ''} ${authState.user.lastName ?? ''}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 48,
                              left: 16,
                              child: _buildProfileImage(authState),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          tabs: const [
                            Tab(icon: Icon(Icons.person), text: "Personal"),
                            Tab(
                                icon: Icon(Icons.favorite),
                                text: "Mental Health"),
                            Tab(
                                icon: Icon(Icons.account_circle),
                                text: "Account"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: Form(
                  key: _formKey,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Personal Info Tab
                      _buildPersonalInfoTab(),

                      // Mental Health Tab
                      _buildMentalHealthTab(),

                      // Account Info Tab
                      _buildAccountInfoTab(authState),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You are not logged in"),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRouter.loginRoute),
                      child: const Text("Go to Login"),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileImage(Authenticated authState) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : authState.user.profilePicture != null &&
                      authState.user.profilePicture!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: authState.user.profilePicture!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _isEditMode ? _pickImage : null,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isEditMode
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: "Basic Information"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileTextField(
                    controller: _firstNameController,
                    label: "First Name",
                    icon: Icons.person_outline,
                    enabled: _isEditMode,
                    validator: (value) {
                      if (_isEditMode && (value == null || value.isEmpty)) {
                        return "First name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileTextField(
                    controller: _lastNameController,
                    label: "Last Name",
                    icon: Icons.person_outline,
                    enabled: _isEditMode,
                    validator: (value) {
                      if (_isEditMode && (value == null || value.isEmpty)) {
                        return "Last name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileTextField(
                    controller: _dateOfBirthController,
                    label: "Date of Birth",
                    icon: Icons.calendar_today,
                    enabled: _isEditMode,
                    onTap: _isEditMode
                        ? () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _dateOfBirthController.text =
                                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                              });
                            }
                          }
                        : null,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: "About Me"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProfileTextField(
                controller: _bioController,
                label: "Bio",
                icon: Icons.description,
                enabled: _isEditMode,
                maxLines: 5,
                hintText: "Tell us about yourself...",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentalHealthTab() {
    const List<String> allActivities = [
      'Meditation',
      'Exercise',
      'Reading',
      'Journaling',
      'Therapy',
      'Yoga',
      'Music',
      'Nature Walks',
      'Art',
      'Deep Breathing',
      'Cooking',
      'Gardening',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: "Mental Health Goals"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProfileTextField(
                controller: _goalsController,
                label: "Mental Health Goals",
                icon: Icons.flag,
                enabled: _isEditMode,
                maxLines: 3,
                hintText: "What are your mental health goals?",
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: "Current Stress Level"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Level: ${_stressLevel.toInt()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        _getStressLevelDescription(_stressLevel.toInt()),
                        style: TextStyle(
                          fontSize: 16,
                          color: _getStressLevelColor(_stressLevel.toInt()),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _stressLevel,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: _getStressLevelColor(_stressLevel.toInt()),
                    label: _stressLevel.toInt().toString(),
                    onChanged: _isEditMode
                        ? (value) {
                            setState(() {
                              _stressLevel = value;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Low Stress"),
                      Text("High Stress"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: "Preferred Activities"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allActivities.map((activity) {
                  final isSelected = _selectedActivities.contains(activity);
                  return FilterChip(
                    label: Text(activity),
                    selected: isSelected,
                    onSelected: _isEditMode
                        ? (selected) {
                            setState(() {
                              if (selected) {
                                _selectedActivities.add(activity);
                              } else {
                                _selectedActivities.remove(activity);
                              }
                            });
                          }
                        : null,
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: _isEditMode ? null : Colors.grey.shade200,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoTab(Authenticated authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: "Account Information"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileTextField(
                    controller: _usernameController,
                    label: "Username",
                    icon: Icons.account_circle,
                    enabled: false, // Username can't be edited
                  ),
                  const SizedBox(height: 16),
                  ProfileTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email,
                    enabled: false, // Email can't be edited
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: "Account Management"),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to change password page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Change password feature coming soon!"),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red.shade300),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red.shade300),
                    ),
                    onTap: _confirmLogout,
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      // Show delete account confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete account feature coming soon!"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  _buildAccountDetail(
                    "Member Since",
                    authState.user.createdAt.toIso8601String().substring(0, 10),
                  ),
                  const Divider(),
                  _buildAccountDetail(
                    "Last Updated",
                    authState.user.updatedAt
                            ?.toIso8601String()
                            .substring(0, 10) ??
                        "N/A",
                  ),
                  const Divider(),
                  _buildAccountDetail(
                    "Account ID",
                    "#${authState.user.id}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetail(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDarkMode ? AppColors.textPrimaryDark : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStressLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  String _getStressLevelDescription(int level) {
    switch (level) {
      case 1:
        return "Very Relaxed";
      case 2:
        return "Relaxed";
      case 3:
        return "Moderate";
      case 4:
        return "Stressed";
      case 5:
        return "Very Stressed";
      default:
        return "Moderate";
    }
  }
}

// Helper widgets
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final int maxLines;
  final String? hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.enabled = true,
    this.maxLines = 1,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: enabled
            ? null
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100),
        hintText: hintText,
        // Make sure labels are visible
        labelStyle: TextStyle(
          color: isDarkMode ? AppColors.textPrimaryDark : null,
        ),
        // Ensure hint text is visible in dark mode
        hintStyle: TextStyle(
          color: isDarkMode
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        // Ensure border is visible in dark mode
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ),
      ),
      enabled: enabled,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      // IMPORTANT: Make sure text is always visible regardless of enabled state
      style: TextStyle(
        color: isDarkMode
            ? AppColors
                .textPrimaryDark // Always use primary text color in dark mode
            : AppColors
                .textPrimaryLight, // Always use primary text color in light mode
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
