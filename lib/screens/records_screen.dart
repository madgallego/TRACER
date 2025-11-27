import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../models/transaction.dart';
import '../widgets/gradient_icon.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  // Controller for search input
  final TextEditingController _searchController = TextEditingController();

  // State variables
  List<Transaction> _allRecords = [];
  List<Transaction> _filteredRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
    _searchController.addListener(_onSearchChanged);
  }

  // Methods for data fetching and processing
  Future<void> _fetchRecords() async {
    try {
      final response = await Supabase.instance.client
          .from('transaction') 
          .select()
          .order('receiptdate', ascending: false); // Sort by newest

      final data = (response as List)
          .map((item) => Transaction.fromJson(item))
          .toList();

      if (mounted) {
        setState(() {
          _allRecords = data;
          _filteredRecords = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Search logic
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        final title = record.transactPurpose?.toLowerCase() ?? '';
        final id = record.receiptNum?.toLowerCase() ?? '';
        return title.contains(query) || id.contains(query);
      }).toList();
    });
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
                        const Text(
                          'Records',
                          style: TextStyle(
                            fontFamily: "AROneSans",
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20.0),

                        // Gradient search bar
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(3), // border width
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(
                                      fontFamily: "AROneSans",
                                      fontSize: 13.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Search records...",
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
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

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
                                      separatorBuilder: (context, index) => 
                                          const Divider(height: 20, color: Colors.black12),
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
    final dateString = "${record.transactMonth}-${record.transactDay}-${record.transactYear}";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Receipt number
        SizedBox(
          width: 90,
          child: Text(
            record.receiptNum ?? '---',
            style: const TextStyle(
              fontFamily: "AROneSans",
              fontWeight: FontWeight.bold, 
              color: Colors.black87,
              fontSize: 12
            ),
          ),
        ),
        
        // Title and date
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.transactPurpose ?? 'No Purpose',
                style: const TextStyle(
                  fontFamily: "AROneSans",
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Paid $dateString",
                style: const TextStyle(
                  fontFamily: "AROneSans", 
                  fontSize: 12, color: 
                  Colors.grey, fontWeight: 
                  FontWeight.w500
                ),
              ),
            ],
          ),
        ),
        
        // Amount
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Php ${record.transactAmount}",
              style: const TextStyle(
                fontFamily: "AROneSans",
                fontWeight: FontWeight.bold, 
                color: Colors.black87
              ),
            ),
          ),
        ),
      ],
    );
  }
}