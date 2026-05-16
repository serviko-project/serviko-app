import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/categories_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/home_header.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/home_search_bar.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/popular_services_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/special_offers_section.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/popular_services_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data
    context.read<CategoryCubit>().fetchCategories();
    context.read<PopularServicesCubit>().fetchPopularServices();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),
            // Header
            SliverToBoxAdapter(child: HomeHeader()),
            SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),

            // Search Bar
            SliverToBoxAdapter(child: HomeSearchBar()),
            SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),

            // Special Offers
            SliverToBoxAdapter(child: SpecialOffersSection()),
            SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),

            // Categories
            CategoriesSection(),
            SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),

            // Popular Services
            PopularServicesSection(),
            SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
          ],
        ),
      ),
    );
  }
}
