import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:camera/camera.dart';

/// Visitor Management Screen for handling visitor pre-approvals and real-time entry management
class VisitorManagementScreenNew extends StatefulWidget {
  const VisitorManagementScreenNew({super.key});

  @override
  State<VisitorManagementScreenNew> createState() =>
      _VisitorManagementScreenState();
}

class _VisitorManagementScreenState extends State<VisitorManagementScreenNew> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Today';
  bool _isBulkMode = false;
  final Set<int> _selectedVisitors = {};
  Map<String, dynamic>? _activeNotification;

  // Mock visitor data
  final List<Map<String, dynamic>> _allVisitors = [
    {
      'id': 1,
      'name': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'purpose': 'Delivery - Amazon Package',
      'photo':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1236e79c3-1763294023133.png',
      'photoSemanticLabel':
          'Indian man with short black hair and mustache wearing blue shirt',
      'expectedTime': '22/12/2025 02:30 PM',
      'status': 'Pending',
    },
    {
      'id': 2,
      'name': 'Priya Sharma',
      'phone': '+91 87654 32109',
      'purpose': 'Guest Visit',
      'photo':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1dc96d634-1763295460493.png',
      'photoSemanticLabel':
          'Indian woman with long black hair wearing traditional saree',
      'expectedTime': '22/12/2025 04:00 PM',
      'status': 'Approved',
    },
    {
      'id': 3,
      'name': 'Amit Patel',
      'phone': '+91 76543 21098',
      'purpose': 'Maintenance Work',
      'photo':
          'https://img.rocket.new/generatedImages/rocket_gen_img_15e90c3d0-1763293909345.png',
      'photoSemanticLabel':
          'Indian man with glasses and short hair wearing work uniform',
      'expectedTime': '22/12/2025 10:00 AM',
      'status': 'Approved',
    },
    {
      'id': 4,
      'name': 'Sneha Reddy',
      'phone': '+91 65432 10987',
      'purpose': 'Food Delivery - Swiggy',
      'photo':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1ec6b40c2-1763294215713.png',
      'photoSemanticLabel':
          'Young Indian woman with ponytail wearing delivery uniform',
      'expectedTime': '22/12/2025 01:15 PM',
      'status': 'Rejected',
    },
    {
      'id': 5,
      'name': 'Vikram Singh',
      'phone': '+91 54321 09876',
      'purpose': 'Courier - BlueDart',
      'photo':
          'https://img.rocket.new/generatedImages/rocket_gen_img_10525d709-1763292629057.png',
      'photoSemanticLabel':
          'Indian man with beard wearing courier company uniform',
      'expectedTime': '22/12/2025 11:30 AM',
      'status': 'Pending',
    },
  ];

  List<Map<String, dynamic>> _filteredVisitors = [];

  @override
  void initState() {
    super.initState();
    _filteredVisitors = List.from(_allVisitors);
    _simulateVisitorArrival();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _simulateVisitorArrival() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _allVisitors.isNotEmpty) {
        setState(() {
          _activeNotification = _allVisitors.first;
        });
      }
    });
  }

  void _filterVisitors() {
    setState(() {
      _filteredVisitors = _allVisitors.where((visitor) {
        final matchesSearch = visitor['name'].toString().toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );

        final matchesFilter =
            _selectedFilter == 'Today' ||
            visitor['status'].toString().toLowerCase() ==
                _selectedFilter.toLowerCase();

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _showSuccessMessage(String message) {
    HapticFeedback.lightImpact();
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
      margin: EdgeInsets.all(4.w),
      icon: Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 24,
      ),
    ).show(context);
  }

  void _approveVisitor(int visitorId) {
    setState(() {
      final index = _allVisitors.indexWhere((v) => v['id'] == visitorId);
      if (index != -1) {
        _allVisitors[index]['status'] = 'Approved';
        _filterVisitors();
      }
    });
    _showSuccessMessage('Visitor approved successfully');
  }

  void _rejectVisitor(int visitorId) {
    setState(() {
      final index = _allVisitors.indexWhere((v) => v['id'] == visitorId);
      if (index != -1) {
        _allVisitors[index]['status'] = 'Rejected';
        _filterVisitors();
      }
    });
    _showSuccessMessage('Visitor rejected');
  }

  void _deleteVisitor(int visitorId) {
    setState(() {
      _allVisitors.removeWhere((v) => v['id'] == visitorId);
      _filterVisitors();
    });
    _showSuccessMessage('Visitor removed');
  }

  void _callVisitor(String phone) {
    _showSuccessMessage('Calling $phone...');
  }

  void _shareVisitorDetails(Map<String, dynamic> visitor) {
    _showSuccessMessage('Sharing details for ${visitor['name']}');
  }

  void _editVisitor(int visitorId) {
    _showSuccessMessage('Edit functionality coming soon');
  }

  void _extendTime(int visitorId) {
    _showSuccessMessage('Time extended successfully');
  }

  void _addNote(int visitorId) {
    _showSuccessMessage('Note added successfully');
  }

  void _toggleBulkMode() {
    setState(() {
      _isBulkMode = !_isBulkMode;
      if (!_isBulkMode) {
        _selectedVisitors.clear();
      }
    });
  }

  void _bulkApprove() {
    setState(() {
      for (final id in _selectedVisitors) {
        final index = _allVisitors.indexWhere((v) => v['id'] == id);
        if (index != -1) {
          _allVisitors[index]['status'] = 'Approved';
        }
      }
      _selectedVisitors.clear();
      _isBulkMode = false;
      _filterVisitors();
    });
    _showSuccessMessage('${_selectedVisitors.length} visitors approved');
  }

  void _handleVoiceSearch() {
    _showSuccessMessage('Voice search activated');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: Text('Visitor Management'),
        actions: [
          IconButton(
            icon: Icon(
              _isBulkMode ? Icons.close : Icons.checklist,
              color: Colors.white,
              size: 24,
            ),
            onPressed: _toggleBulkMode,
          ),
          if (_isBulkMode && _selectedVisitors.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
              onPressed: _bulkApprove,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _filterVisitors());
        },
        child: Stack(
          children: [
            Column(
              children: [
                FloatingSearchBarWidget(
                  searchController: _searchController,
                  onVoiceSearch: _handleVoiceSearch,
                  onSearchChanged: (_) => _filterVisitors(),
                ),
                FilterChipsWidget(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                      _filterVisitors();
                    });
                  },
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: _filteredVisitors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_search,
                                size: 64,
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No visitors found',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: _filteredVisitors.length,
                          itemBuilder: (context, index) {
                            final visitor = _filteredVisitors[index];
                            final visitorId = visitor['id'] as int;

                            return VisitorCardWidget(
                              visitor: visitor,
                              onApprove: () => _approveVisitor(visitorId),
                              onReject: () => _rejectVisitor(visitorId),
                              onCall: () =>
                                  _callVisitor(visitor['phone'] as String),
                              onShare: () => _shareVisitorDetails(visitor),
                              onDelete: () => _deleteVisitor(visitorId),
                              onEdit: () => _editVisitor(visitorId),
                              onExtendTime: () => _extendTime(visitorId),
                              onAddNote: () => _addNote(visitorId),
                              isSelected: _selectedVisitors.contains(visitorId),
                              onSelectionChanged: () {
                                setState(() {
                                  if (_selectedVisitors.contains(visitorId)) {
                                    _selectedVisitors.remove(visitorId);
                                  } else {
                                    _selectedVisitors.add(visitorId);
                                  }
                                });
                              },
                              isBulkMode: _isBulkMode,
                            );
                          },
                        ),
                ),
              ],
            ),
            if (_activeNotification != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NotificationBannerWidget(
                  visitor: _activeNotification!,
                  onApprove: () {
                    _approveVisitor(_activeNotification!['id'] as int);
                    setState(() => _activeNotification = null);
                  },
                  onDeny: () {
                    _rejectVisitor(_activeNotification!['id'] as int);
                    setState(() => _activeNotification = null);
                  },
                  onDismiss: () {
                    setState(() => _activeNotification = null);
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddVisitorBottomSheet(
                onVisitorAdded: (visitor) {
                  setState(() {
                    _allVisitors.insert(0, visitor);
                    _filterVisitors();
                  });
                  _showSuccessMessage('Visitor added successfully');
                },
              ),
            ),
          );
        },
        icon: Icon(Icons.person_add, color: colorScheme.onPrimary, size: 24),
        label: const Text('Add Visitor'),
        backgroundColor: colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// Bottom sheet for adding new visitor with camera integration
class AddVisitorBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onVisitorAdded;

  const AddVisitorBottomSheet({super.key, required this.onVisitorAdded});

  @override
  State<AddVisitorBottomSheet> createState() => _AddVisitorBottomSheetState();
}

class _AddVisitorBottomSheetState extends State<AddVisitorBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();

  XFile? _capturedImage;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      try {
        await _cameraController!.setFocusMode(FocusMode.auto);
      } catch (e) {
        // Focus mode not supported
      }

      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported
        }
      }

      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      // Camera initialization failed - continue without camera
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() => _capturedImage = photo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture photo')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _capturedImage = image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final visitor = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'purpose': _purposeController.text,
        'photo':
            _capturedImage?.path ??
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'photoSemanticLabel':
            'Visitor photo captured for ${_nameController.text}',
        'expectedTime': _selectedDate != null && _selectedTime != null
            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedTime!.format(context)}'
            : 'Not specified',
        'status': 'Pending',
      };
      widget.onVisitorAdded(visitor);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  'Add New Visitor',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),

                // Camera/Photo Section
                Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _capturedImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                _capturedImage!.path,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 2.w,
                              right: 2.w,
                              child: IconButton(
                                icon: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: colorScheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: colorScheme.onError,
                                    size: 20,
                                  ),
                                ),
                                onPressed: () =>
                                    setState(() => _capturedImage = null),
                              ),
                            ),
                          ],
                        )
                      : _isCameraInitialized && _cameraController != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CameraPreview(_cameraController!),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 48,
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Camera not available',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 2.h),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _capturePhoto,
                        icon: Icon(
                          Icons.camera_alt,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                        label: const Text('Capture'),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromGallery,
                        icon: Icon(
                          Icons.photo_library,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Visitor Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter visitor name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Purpose of Visit',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter purpose';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDate,
                        icon: Icon(
                          Icons.calendar_today,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        label: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date',
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectTime,
                        icon: Icon(
                          Icons.access_time,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        label: Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Select Time',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: const Text('Add Visitor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter chips for visitor status filtering
class FilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const FilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final filters = ['Today', 'Pending', 'Approved', 'Rejected'];

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => onFilterChanged(filter),
            backgroundColor: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF8FAFC),
            selectedColor: colorScheme.primary.withValues(alpha: 0.2),
            checkmarkColor: colorScheme.primary,
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          );
        },
      ),
    );
  }
}

/// Floating search bar with voice search capability
class FloatingSearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onVoiceSearch;
  final ValueChanged<String> onSearchChanged;

  const FloatingSearchBarWidget({
    super.key,
    required this.searchController,
    required this.onVoiceSearch,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search visitors...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    searchController.clear();
                    onSearchChanged('');
                  },
                ),
              IconButton(
                icon: Icon(Icons.mic, color: colorScheme.primary, size: 24),
                onPressed: onVoiceSearch,
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
      ),
    );
  }
}

/// Floating notification banner for visitor arrivals
class NotificationBannerWidget extends StatelessWidget {
  final Map<String, dynamic> visitor;
  final VoidCallback onApprove;
  final VoidCallback onDeny;
  final VoidCallback onDismiss;

  const NotificationBannerWidget({
    super.key,
    required this.visitor,
    required this.onApprove,
    required this.onDeny,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visitor at Gate',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${visitor['name']} has arrived',
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: onDismiss,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: const Text('Approve'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDeny,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                  ),
                  child: const Text('Deny'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual visitor card widget with swipe actions and status indicators
class VisitorCardWidget extends StatelessWidget {
  final Map<String, dynamic> visitor;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onCall;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onExtendTime;
  final VoidCallback onAddNote;
  final bool isSelected;
  final VoidCallback? onSelectionChanged;
  final bool isBulkMode;

  const VisitorCardWidget({
    super.key,
    required this.visitor,
    required this.onApprove,
    required this.onReject,
    required this.onCall,
    required this.onShare,
    required this.onDelete,
    required this.onEdit,
    required this.onExtendTime,
    required this.onAddNote,
    this.isSelected = false,
    this.onSelectionChanged,
    this.isBulkMode = false,
  });

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'approved':
        return colorScheme.primary;
      case 'pending':
        return colorScheme.tertiary;
      case 'rejected':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final status = visitor['status'] as String;
    final statusColor = _getStatusColor(status, colorScheme);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(visitor['id']),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onApprove(),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: Icons.check_rounded,
              label: 'Approve',
              borderRadius: BorderRadius.circular(16),
            ),
            SlidableAction(
              onPressed: (_) => onReject(),
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              icon: Icons.close_rounded,
              label: 'Reject',
              borderRadius: BorderRadius.circular(16),
            ),
            SlidableAction(
              onPressed: (_) => onCall(),
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              icon: Icons.phone_rounded,
              label: 'Call',
              borderRadius: BorderRadius.circular(16),
            ),
            SlidableAction(
              onPressed: (_) => onShare(),
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
              icon: Icons.share_rounded,
              label: 'Share',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildContextMenu(context, theme),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  if (isBulkMode)
                    Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => onSelectionChanged?.call(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          visitor['photo'] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                          semanticLabel:
                              visitor['photoSemanticLabel'] as String,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(0.5.w),
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getStatusIcon(
                              status,
                            ),
                            size: 12,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor['name'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                visitor['purpose'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              visitor['expectedTime'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenu(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: colorScheme.primary, size: 24),
              title: Text('Edit Details', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.access_time,
                color: colorScheme.secondary,
                size: 24,
              ),
              title: Text('Extend Time', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                onExtendTime();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.note_add,
                color: colorScheme.tertiary,
                size: 24,
              ),
              title: Text('Add Note', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                onAddNote();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
