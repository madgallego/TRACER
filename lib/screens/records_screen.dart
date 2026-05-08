import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../models/transaction.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_dropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/db_service.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  DbService? _dbService;

  // Controller for search input
  final TextEditingController _searchController = TextEditingController();

  // State variables
  List<Transaction> _allRecords = [];
  List<Transaction> _filteredRecords = [];
  bool _isLoading = true;

  // Filter state
  bool _showFilters = false;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedFoName;
  List<String> _foNameOptions = [];
  String? _selectedYearLevel;
  String? _selectedBloc;
  List<String> _yearLevelOptions = [];
  List<String> _blocOptions = []; 

  // Organization
  String? _currentOrgId;

  @override
  void initState() {
    super.initState();
    _setupServiceAndLoad(); 
    _searchController.addListener(_applyFilters);
  }

  Future<void> _setupServiceAndLoad() async {
    try {
      _dbService = await DbService.initialize();
      await _loadData();
    } catch (e) {
      debugPrint("Service initialization failed: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadData() async {
    if (_dbService == null) return;

    try {
      final orgId = await _dbService!.getFinanceOfficerOrgId();
      
      if (orgId == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final data = await _dbService!.fetchTransactions(orgId);

      final foNames = data
          .map((r) {
            final fn = r.foFirstName ?? '';
            final mi = (r.foMiddleInitial?.isNotEmpty == true)
                ? "${r.foMiddleInitial}. "
                : "";
            final ln = r.foLastName ?? '';
            return "$fn $mi$ln".trim();
          })
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      final yearLevels = data
          .map((r) => r.stuYearLevel ?? '') 
          .where((y) => y.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      final blocs = data
          .map((r) => r.stuBloc ?? '') // Replace with your actual model property
          .where((b) => b.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      if (mounted) {
        setState(() {
          _currentOrgId = orgId;
          _allRecords = data;
          _filteredRecords = data;
          _foNameOptions = foNames;
          _yearLevelOptions = yearLevels;
          _blocOptions = blocs;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Filtering logic
  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredRecords = _allRecords.where((record) {

        // --- Search ---
        final title = record.transactPurpose?.toLowerCase() ?? '';
        final id = record.receiptNum?.toLowerCase() ?? '';
        final foFirstName = record.foFirstName?.toLowerCase() ?? '';
        final foMiddleInitial = (record.foMiddleInitial?.isNotEmpty == true)
            ? "${record.foMiddleInitial}.".toLowerCase()
            : "";
        final foLastName = record.foLastName?.toLowerCase() ?? '';
        final foName = "$foFirstName $foMiddleInitial $foLastName".trim();

        final matchesSearch = query.isEmpty ||
            title.contains(query) ||
            id.contains(query) ||
            foFirstName.contains(query) ||
            foMiddleInitial.contains(query) ||
            foLastName.contains(query) ||
            foName.contains(query);

        // --- Date Range ---
        bool matchesDate = true;
        if (_fromDate != null || _toDate != null) {
          final year = int.tryParse(record.transactYear ?? '');
          final month = int.tryParse(record.transactMonth ?? '');
          final day = int.tryParse(record.transactDay ?? '');

          if (year != null && month != null && day != null) {
            final recordDate = DateTime(year, month, day);
            if (_fromDate != null && recordDate.isBefore(_fromDate!)) {
              matchesDate = false;
            }
            if (_toDate != null && recordDate.isAfter(_toDate!.add(const Duration(days: 1)))) {
              matchesDate = false;
            }
          } else {
            matchesDate = false;
          }
        }

        // --- Finance Officer Name ---
        bool matchesFo = true;
        if (_selectedFoName != null) {
          final fn = record.foFirstName ?? '';
          final mi = (record.foMiddleInitial?.isNotEmpty == true)
              ? "${record.foMiddleInitial}. "
              : "";
          final ln = record.foLastName ?? '';
          final fullName = "$fn $mi$ln".trim();
          matchesFo = fullName == _selectedFoName;
        }

        // --- Year Level ---
        bool matchesYear = true;
        if (_selectedYearLevel != null) {
          matchesYear = record.stuYearLevel == _selectedYearLevel;
        }

        // --- Bloc ---
        bool matchesBloc = true;
        if (_selectedBloc != null) {
          matchesYear = record.stuBloc == _selectedBloc;
        }

        return matchesSearch && matchesDate && matchesFo && matchesYear && matchesBloc;
      }).toList();
    });
  }

  // Clear all filters
  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedFoName = null;
      _selectedYearLevel = null; 
      _selectedBloc = null; 
    });
    _applyFilters();
  }

  bool get _hasActiveFilters =>
      _fromDate != null || _toDate != null || _selectedFoName != null || _selectedYearLevel != null || _selectedBloc != null; 

  // Date picker helper
  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
      _applyFilters();
    }
  }

  // Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select';
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  void _showRecordDetails(Transaction record) {
    // Format date
    final months = ['January','February','March','April','May','June',
                    'July','August','September','October','November','December'];
    final monthNum = int.tryParse(record.transactMonth ?? '');
    final monthName = (monthNum != null && monthNum >= 1 && monthNum <= 12)
        ? months[monthNum - 1]
        : record.transactMonth ?? '';
    final dateString = "$monthName, ${record.transactDay} ${record.transactYear}";

    // Format finance officer name
    final foMi = (record.foMiddleInitial?.isNotEmpty == true)
        ? "${record.foMiddleInitial}. "
        : "";
    final foName = "${record.foFirstName ?? ''} $foMi${record.foLastName ?? ''}".trim();

    // Format student name
    final stuMi = (record.stuMiddleInitial?.isNotEmpty == true)
        ? "${record.stuMiddleInitial}. "
        : "";
    final stuName = "${record.stuFirstName ?? ''} $stuMi${record.stuLastName ?? ''}".trim();
    
    // Format uploader name
    // Format Uploader Name with Middle Initial Logic
    final String upFn = record.uploaderFirstName ?? '';
    final String upLn = record.uploaderLastName ?? '';
    final String rawUpMi = record.uploaderMiddleInitial ?? '';
    final String upMi = rawUpMi.isNotEmpty ? "$rawUpMi. " : "";
    
    final String uploaderFullName = "$upFn $upMi$upLn".trim();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receipt no.',
                      style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      record.receiptNum ?? '---',
                      style: AppDesign.bodyStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.black54),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Gradient divider
            Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Details rows
            _buildDetailRow('Date', dateString),
            _buildDetailRow('Amount', 'Php ${record.transactAmount}'),
            _buildDetailRow('Description', record.transactPurpose ?? '---'),

            const SizedBox(height: 12),

            _buildDetailRow('Received by', foName.isEmpty ? '---' : foName),
            _buildDetailRow('Paid by', stuName.isEmpty ? '---' : stuName),
            _buildDetailRow('Student ID', _formatStudentId(record.stuNum)),
            _buildDetailRow('Uploaded by', uploaderFullName.isEmpty ? '---' : uploaderFullName),

            const SizedBox(height: 20),

            // Bottom graphic
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                'assets/images/svg/expanded_records_screen_bottom_graphic.svg',
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to format student ID with dashes
  String _formatStudentId(String? id) {
    if (id == null || id.isEmpty) return '---';
    final digits = id.replaceAll('-', '');
    if (digits.length >= 13) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8, 13)}';
    }
    return id;
  }

  // Helper for each detail row in the bottom sheet
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: AppDesign.bodyStyle.copyWith(fontSize: 14, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppDesign.bodyStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range
            Text(
              "Date Range",
              style: AppDesign.bodyStyle.copyWith(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(true),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _fromDate == null ? 'From' : _formatDate(_fromDate),
                              style: AppDesign.bodyStyle.copyWith(fontSize: 13, color: _fromDate == null ? Colors.black38 : Colors.black87),
                            ),
                            GradientIcon(
                              icon: Icons.calendar_today,
                              size: 14,
                              gradient: const LinearGradient(colors: [
                                AppDesign.primaryGradientStart,
                                AppDesign.primaryGradientEnd,
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(false),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _toDate == null ? 'To' : _formatDate(_toDate),
                              style: AppDesign.bodyStyle.copyWith(fontSize: 13, color: _toDate == null ? Colors.black38 : Colors.black87),
                            ),
                            GradientIcon(
                              icon: Icons.calendar_today,
                              size: 14,
                              gradient: const LinearGradient(colors: [
                                AppDesign.primaryGradientStart,
                                AppDesign.primaryGradientEnd,
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Finance Officer filter
            Text(
              "Finance Officer",
              style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFoName,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(16),
                    icon: GradientIcon(
                      icon: Icons.arrow_drop_down,
                      size: AppDesign.sBtnIconSize,
                      gradient: LinearGradient(colors: [
                        AppDesign.primaryGradientStart,
                        AppDesign.primaryGradientEnd,
                      ]),
                    ),
                    hint: Text(
                      'All finance officers',
                      style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                    style: AppDesign.bodyStyle.copyWith(fontSize: 13, color: Colors.black87),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('All finance officers',
                            style: AppDesign.bodyStyle.copyWith(fontSize: 13)),
                      ),
                      ..._foNameOptions.map(
                        (name) => DropdownMenuItem(
                          value: name,
                          child: Text(name,
                              style: AppDesign.bodyStyle.copyWith(fontSize: 13)),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedFoName = value);
                      _applyFilters();
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Year Level and Bloc
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Year Level",
                        style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedYearLevel,
                              isExpanded: true,
                              icon: GradientIcon(icon: Icons.arrow_drop_down, size: AppDesign.sBtnIconSize, gradient: const LinearGradient(colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd])),
                              hint: Text(
                                'All Years', 
                                style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.normal),
                              ),
                              items: [
                                DropdownMenuItem(value: null, child: Text('All Years', style: AppDesign.bodyStyle.copyWith(fontSize: 13))),
                                ..._yearLevelOptions.map((year) => DropdownMenuItem(value: year, child: Text(year, style: AppDesign.bodyStyle.copyWith(fontSize: 13)))),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedYearLevel = value);
                                _applyFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Bloc Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bloc",
                        style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedBloc,
                              isExpanded: true,
                              icon: GradientIcon(icon: Icons.arrow_drop_down, size: AppDesign.sBtnIconSize, gradient: const LinearGradient(colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd])),
                              hint: Text(
                                'All Blocs', 
                                style: AppDesign.bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.normal),
                              ),
                              items: [
                                DropdownMenuItem(value: null, child: Text('All Blocs', style: AppDesign.bodyStyle.copyWith(fontSize: 13))),
                                ..._blocOptions.map((bloc) => DropdownMenuItem(value: bloc, child: Text(bloc, style: AppDesign.bodyStyle.copyWith(fontSize: 13)))),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedBloc = value);
                                _applyFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Clear filters button
            if (_hasActiveFilters) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear, size: 16),
                  label: Text(
                    'Clear Filters',
                    style: AppDesign.bodyStyle.copyWith(fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFF44336), 
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // User interface
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Removes keyboard when tapping outside input fields
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                ),
              ),
            ),

            // Main content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          'Records',
                          style: AppDesign.headingStyle.copyWith(
                              fontSize: 30.0,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20.0),

                        // Search bar + filter button row
                        Row(
                          children: [
                            // Search bar
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                    colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(23),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(20, 7, 10, 0),
                                  child: TextField(
                                    controller: _searchController,
                                    style: AppDesign.bodyStyle.copyWith(fontSize: 13.0,),
                                    decoration: InputDecoration(
                                      hintText: "Search records...",
                                      hintStyle: AppDesign.bodyStyle.copyWith(
                                        fontSize: 13.0,
                                        color: Colors.black38,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 7),
                                        child: GradientIcon(
                                          icon: Icons.search,
                                          size: AppDesign.sBtnIconSize,
                                          gradient: const LinearGradient(colors: [
                                            AppDesign.primaryGradientStart,
                                            AppDesign.primaryGradientEnd
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Filter button
                            GestureDetector(
                              onTap: () => setState(() => _showFilters = !_showFilters),
                              child: Container(
                                height: 50,
                                width: 50,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                    colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _hasActiveFilters ? null : Colors.white,
                                    gradient: _hasActiveFilters
                                        ? const LinearGradient(
                                            colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(23),
                                  ),
                                  child: _hasActiveFilters
                                      ? Icon(
                                          Icons.tune,
                                          size: AppDesign.sBtnIconSize,
                                          color: Colors.white,
                                        )
                                      : GradientIcon(
                                          icon: Icons.tune,
                                          size: AppDesign.sBtnIconSize,
                                          gradient: const LinearGradient(
                                            colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Expandable filter panel
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: _showFilters ? _buildFilterPanel() : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 20),

                        // Column header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  "Receipt No.",
                                  style: AppDesign.bodyStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 9.0),
                                  child: Text(
                                    "Details",
                                    style: AppDesign.bodyStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Amount",
                                    style: AppDesign.bodyStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Records list
                        Expanded(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _filteredRecords.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No records found.',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      itemCount: _filteredRecords.length,
                                      separatorBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Container(
                                            height: 2,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                                              ),
                                            ),
                                          ),
                                        ),
                                      itemBuilder: (context, index) {
                                        final record = _filteredRecords[index];
                                        return _buildRecordRow(record);
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget for each record row
  Widget _buildRecordRow(Transaction record) {
    // Format date 
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    final monthNum = int.tryParse(record.transactMonth ?? '');
    final monthName = (monthNum != null && monthNum >= 1 && monthNum <= 12)
        ? months[monthNum - 1]
        : record.transactMonth ?? '';
    final dateString = "$monthName ${record.transactDay}, ${record.transactYear}";

    // Format finance officer's name
    final fName = record.foFirstName ?? '';
    final mInitial = record.foMiddleInitial != null ? "${record.foMiddleInitial}. " : "";
    final lName = record.foLastName ?? '';
    
    String foName = "$fName $mInitial$lName".trim();
    
    if (foName.isEmpty) foName = 'No Name';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showRecordDetails(record),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receipt number
              SizedBox(
                width: 90,
                child: Text(
                  record.receiptNum ?? '---',
                  style: AppDesign.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Title, date and finance officer name
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.transactPurpose ?? 'No Purpose',
                      style: AppDesign.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Paid $dateString",
                      style: AppDesign.bodyStyle.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      foName,
                      style: AppDesign.bodyStyle.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              
              // Amount
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Php ${double.tryParse(record.transactAmount ?? '0')?.toStringAsFixed(2) ?? '0.00'}",
                    softWrap: false,
                    style: AppDesign.bodyStyle.copyWith(fontSize: 12,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}