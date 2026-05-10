import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/widgets/banner_image_picker.dart';
import 'package:serviko_app/injection_container.dart';

class EditProviderDetailsScreen extends StatefulWidget {
  const EditProviderDetailsScreen({super.key});

  @override
  State<EditProviderDetailsScreen> createState() =>
      _EditProviderDetailsScreenState();
}

class _EditProviderDetailsScreenState extends State<EditProviderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _experienceController;
  bool _isDataLoaded = false;
  String? _bannerImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bioController = TextEditingController();
    _experienceController = TextEditingController();

    // Pre-fill existing details
    final profileCubit = context.read<ProviderProfileCubit>();
    if (profileCubit.state is ProviderProfileLoaded) {
      _fillData((profileCubit.state as ProviderProfileLoaded).profile);
    } else {
      profileCubit.fetchProviderProfile();
    }
  }

  void _fillData(ProviderProfileEntity profile) {
    if (!_isDataLoaded) {
      _titleController.text = profile.professionalTitle ?? '';
      _bioController.text = profile.about ?? '';
      _experienceController.text = profile.yearsOfExperience?.toString() ?? '';
      _isDataLoaded = true;
    }
    _bannerImageUrl = profile.bannerImageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<EditProviderDetailsCubit>().updateDetails(
        professionalTitle: _titleController.text.trim(),
        bio: _bioController.text.trim(),
        yearsOfExperience: int.tryParse(_experienceController.text.trim()) ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProviderDetailsCubit(
        updateProviderDetailsUseCase:
            InjectionContainer.instance.updateProviderDetailsUseCase,
        uploadBannerImageUseCase:
            InjectionContainer.instance.uploadBannerImageUseCase,
        deleteBannerImageUseCase:
            InjectionContainer.instance.deleteBannerImageUseCase,
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProviderProfileCubit, ProviderProfileState>(
            listener: (context, profileState) {
              if (profileState is ProviderProfileLoaded) {
                _fillData(profileState.profile);
              }
            },
          ),
          BlocListener<EditProviderDetailsCubit, EditProviderDetailsState>(
            listener: (context, state) {
              if (state is EditProviderDetailsSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.read<ProviderProfileCubit>().fetchProviderProfile();
                context.pop();
              } else if (state is EditProviderDetailsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is BannerImageUploadSuccess ||
                  state is BannerImageDeleteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state is BannerImageUploadSuccess
                          ? state.message
                          : (state as BannerImageDeleteSuccess).message,
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.read<ProviderProfileCubit>().fetchProviderProfile();
              } else if (state is BannerImageUploadError ||
                  state is BannerImageDeleteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state is BannerImageUploadError
                          ? state.message
                          : (state as BannerImageDeleteError).message,
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: 'Edit Provider Details'),
          body: SafeArea(
            child: BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
              builder: (context, profileState) {
                if ((profileState is ProviderProfileLoading ||
                        profileState is ProviderProfileInitial) &&
                    !_isDataLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner Image Section
                        const Text(
                          'Banner Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        BannerImagePicker(initialImageUrl: _bannerImageUrl),
                        const SizedBox(height: AppSizes.lg),
                        const Divider(color: AppColors.divider, thickness: 1.5),
                        const SizedBox(height: AppSizes.lg),

                        // Professional Information Section
                        const Text(
                          'Professional Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        CustomTextField(
                          controller: _titleController,
                          labelText: 'Professional Title',
                          hintText: 'e.g. Expert Plumber, Senior Electrician',
                          validator: (value) => FormValidators.validateRequired(
                            value,
                            'Professional title',
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        CustomTextField(
                          controller: _bioController,
                          labelText: 'Bio',
                          hintText:
                              'Tell your customers about your services and experience',
                          maxLines: 4,
                        ),
                        const SizedBox(height: AppSizes.md),

                        CustomTextField(
                          controller: _experienceController,
                          labelText: 'Years of Experience',
                          hintText: 'e.g. 5',
                          keyboardType: TextInputType.number,
                          validator: (value) => FormValidators.validateNumeric(
                            value,
                            'Years of experience',
                          ),
                        ),
                        const SizedBox(height: AppSizes.xl),

                        BlocBuilder<
                          EditProviderDetailsCubit,
                          EditProviderDetailsState
                        >(
                          builder: (context, editState) {
                            final isLoading =
                                editState is EditProviderDetailsLoading;
                            return CustomButton(
                              text: 'Save Details',
                              onPressed: isLoading
                                  ? () {}
                                  : () => _onSave(context),
                              isLoading: isLoading,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
