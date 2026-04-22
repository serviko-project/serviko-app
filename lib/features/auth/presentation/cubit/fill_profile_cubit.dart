import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Fill profile form state
class FillProfileState {
  final String? gender;
  const FillProfileState({this.gender});

  FillProfileState copyWith({String? gender}) =>
      FillProfileState(gender: gender ?? this.gender);
}

// Manages fill profile form state and controllers
class FillProfileCubit extends Cubit<FillProfileState> {
  FillProfileCubit() : super(const FillProfileState());

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameFocusNode = FocusNode();
  final dobFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  static const List<String> genderOptions = ['Male', 'Female', 'Other'];

  void updateGender(String? value) => emit(state.copyWith(gender: value));

  // Collects all profile data
  Map<String, dynamic> getProfileData() {
    return {
      'fullName': fullNameController.text.trim(),
      'gender': state.gender,
      'dateOfBirth': dobController.text.trim(),
      'phone': phoneController.text.trim(),
    };
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    fullNameFocusNode.dispose();
    dobFocusNode.dispose();
    phoneFocusNode.dispose();
    return super.close();
  }
}
