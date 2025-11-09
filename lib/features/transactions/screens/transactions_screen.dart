import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/routes/routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/transaction_card.dart';
import '../widgets/feature_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/date_filter_chip.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late final FirebaseFirestore _db;
  late final String _uid;
  late final AnimationController _animationController;
  late final TextEditingController _searchController;
  String _selectedDateFilter = 'This Month';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _uid = AuthService().uidOrThrow;
    _searchController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.tealStart.withOpacity(0.2),
                AppColors.purpleStart.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.receipt_long,
              size: 80,
              color: AppColors.tealStart,
            ),
          ),
        ),
        const SizedBox(height: 32),
        
        
        Text(
          '📊 Track Every Rupee',
          style: AppTextStyles.h2(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        
        
        Text(
          'Start your financial journey by\nadding your first transaction',
          style: AppTextStyles.bodyMedium(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureCard(
                icon: Icons.category,
                title: 'Categorize',
                subtitle: 'Organize by type',
                gradient: AppColors.tealGradient,
              ),
              const SizedBox(width: 16),
              FeatureCard(
                icon: Icons.analytics,
                title: 'Analyze',
                subtitle: 'Track patterns',
                gradient: AppColors.purpleGradient,
              ),
              const SizedBox(width: 16),
              FeatureCard(
                icon: Icons.savings,
                title: 'Save More',
                subtitle: 'Reach goals faster',
                gradient: const LinearGradient(
                  colors: [AppColors.orangeStart, AppColors.orangeEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.tealStart.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.categoryFood.withOpacity(0.2),
              child: Icon(Icons.restaurant, color: AppColors.categoryFood),
            ),
            title: Text('Lunch at Cafe', style: AppTextStyles.h4(context)),
            subtitle: Text('Food - Today', style: AppTextStyles.bodySmall(context)),
            trailing: Text(
              '-₹250',
              style: AppTextStyles.amountMedium(context).copyWith(color: AppColors.error),
            ),
          ),
        ),
        const SizedBox(height: 40),
        
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, RoutePaths.addTransaction),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tealStart,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: AppColors.tealStart.withOpacity(0.4),
            ),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            label: Text(
              'Add Your First Transaction',
              style: AppTextStyles.button(context).copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.cardBackground(context),
            highlightColor: AppColors.surfaceColor(context),
            child: const ListTile(),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList(List<QueryDocumentSnapshot> transactions) {
    final filteredTransactions = transactions.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final description = data['description'] as String;
      final category = data['category'] as String;
      final tags = List<String>.from(data['tags'] ?? []);
      
      return description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final data = transaction.data() as Map<String, dynamic>;
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.05,
              1.0,
              curve: Curves.easeOut,
            ),
          )),
          child: Dismissible(
            key: Key(transaction.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.cardBackground(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text('Delete Transaction?', style: AppTextStyles.h3(context)),
                  content: Text(
                    'This action cannot be undone.',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.button(context).copyWith(
                          color: AppColors.tealStart,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Delete',
                        style: AppTextStyles.button(context).copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              await _db
                  .collection(AppConstants.colTransactions)
                  .doc(transaction.id)
                  .delete();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Transaction deleted'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: TransactionCard(data: data),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection(AppConstants.colTransactions)
            .where(AppConstants.fUid, isEqualTo: _uid)
            .orderBy(AppConstants.fDate, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          _animationController.forward();
          
          return Column(
            children: [
              // Search & Filter Bar
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.cardBackground(context),
                      AppColors.primaryBackground(context),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionSearchBar(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.purpleGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list),
                          color: Colors.white,
                          onPressed: () {
                            
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Date Filter Chips
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DateFilterChip(
                      label: 'Today',
                      isSelected: _selectedDateFilter == 'Today',
                      onSelected: (value) {
                        setState(() {
                          _selectedDateFilter = 'Today';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    DateFilterChip(
                      label: 'This Week',
                      isSelected: _selectedDateFilter == 'This Week',
                      onSelected: (value) {
                        setState(() {
                          _selectedDateFilter = 'This Week';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    DateFilterChip(
                      label: 'This Month',
                      isSelected: _selectedDateFilter == 'This Month',
                      onSelected: (value) {
                        setState(() {
                          _selectedDateFilter = 'This Month';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    DateFilterChip(
                      label: 'Custom',
                      isSelected: _selectedDateFilter == 'Custom',
                      onSelected: (value) {
                        setState(() {
                          _selectedDateFilter = 'Custom';
                        });
                        
                      },
                    ),
                  ],
                ),
              ),
              
              
              Expanded(
                child: _buildTransactionsList(snapshot.data!.docs),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutePaths.addTransaction),
        backgroundColor: AppColors.tealStart,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        elevation: 8,
        splashColor: AppColors.tealEnd,
      ),
    );
  }
}