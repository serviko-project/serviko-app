import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Manages onboarding page state and PageController lifecycle
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  final pageController = PageController();

  static const int totalPages = 3;

  bool get isLastPage => state == totalPages - 1;

  void onPageChanged(int index) => emit(index);

  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
