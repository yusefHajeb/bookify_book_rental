import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/rental_entity.dart';
import '../bloc/book_bloc.dart';
import '../widgets/rental_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserRentals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserRentals() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<BookBloc>().add(LoadUserRentalsEvent(authState.user.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return Column(
              children: [
                _buildUserInfo(authState.user),
                _buildTabBar(),
                Expanded(child: _buildTabBarView()),
              ],
            );
          }
          return const Center(child: Text('Not authenticated'));
        },
      ),
    );
  }

  Widget _buildUserInfo(user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              user.name?.isNotEmpty == true ? user.name![0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            user.name ?? 'User',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            user.email ?? '',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: user.role == 'admin' ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              user.role?.toUpperCase() ?? 'USER',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
        indicatorPadding: EdgeInsets.symmetric(horizontal: 8.w),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        automaticIndicatorColorAdjustment: false,
        dividerColor: Colors.transparent,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.w,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          color: Theme.of(context).colorScheme.primary,
        ),

        // labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        tabs: const [
          Tab(text: 'حجوزات نشطة'),
          Tab(text: 'تاريخ الحجوزات'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRentalsList(showActive: true),
        _buildRentalsList(showActive: false),
      ],
    );
  }

  Widget _buildRentalsList({required bool showActive}) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserRentalsLoaded) {
          final filteredRentals = state.rentals.where((rental) {
            if (showActive) {
              return rental.status == RentalStatus.pending ||
                  rental.status == RentalStatus.approved;
            } else {
              return rental.status == RentalStatus.returned ||
                  rental.status == RentalStatus.overdue;
            }
          }).toList();

          if (filteredRentals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    showActive ? Icons.book_outlined : Icons.history,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    showActive ? 'لا يوجد حجز نشط' : 'لا حجوزات مسبقة',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    showActive
                        ? ' تصفح الكتب وابداء الحجز'
                        : 'حجزك المكتمل يظهر هنا.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadUserRentals();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: filteredRentals.length,
              itemBuilder: (context, index) {
                return RentalCard(
                  rental: filteredRentals[index],
                  onTap: () {
                    _showRentalDetails(filteredRentals[index]);
                  },
                );
              },
            ),
          );
        } else if (state is BookError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _loadUserRentals,
                  child: const Text('اعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('لا يوجد'));
      },
    );
  }

  void _showRentalDetails(RentalEntity rental) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Rental Details',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Rental ID', '#${rental.id}'),
                        _buildDetailRow('Book ID', '#${rental.bookId}'),
                        _buildDetailRow(
                          'Rental Date',
                          _formatDate(rental.rentalDate),
                        ),
                        _buildDetailRow(
                          'Due Date',
                          _formatDate(rental.dueDate),
                        ),
                        if (rental.returnDate != null)
                          _buildDetailRow(
                            'Return Date',
                            _formatDate(rental.returnDate!),
                          ),
                        _buildDetailRow(
                          'Status',
                          _getStatusText(rental.status),
                        ),
                        SizedBox(height: 20.h),
                        if (rental.status == RentalStatus.approved)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showReturnConfirmation(rental);
                              },
                              child: const Text('Mark as Returned'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showReturnConfirmation(RentalEntity rental) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Book'),
        content: const Text(
          'Are you sure you want to mark this book as returned?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookBloc>().add(
                UpdateRentalStatusEvent(
                  rentalId: rental.id!,
                  status: RentalStatus.returned,
                  returnDate: DateTime.now(),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return 'Pending Approval';
      case RentalStatus.approved:
        return 'Approved';
      case RentalStatus.returned:
        return 'Returned';
      case RentalStatus.overdue:
        return 'Overdue';
      case RentalStatus.cancelled:
        return 'Cancelled';
    }
  }
}
