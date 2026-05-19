import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/cubit/contact_directory_cubit.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/inbox_conversation_list.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/inbox_loading_skeleton.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/inbox_message.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContactDirectoryCubit>().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const CustomAppBar(title: 'Inbox', leading: SizedBox.shrink()),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const InboxMessage(
              title: 'Sign in required',
              subtitle: 'Please sign in to contact providers.',
            );
          }

          return BlocBuilder<ContactDirectoryCubit, ContactDirectoryState>(
            builder: (context, state) {
              if (state is ContactDirectoryLoading ||
                  state is ContactDirectoryInitial) {
                return const InboxLoadingSkeleton();
              }

              if (state is ContactDirectoryFailure) {
                return InboxMessage(
                  title: 'Could not load contacts',
                  subtitle: state.message,
                  action: TextButton.icon(
                    onPressed: () =>
                        context.read<ContactDirectoryCubit>().fetchContacts(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                );
              }

              final contacts = state is ContactDirectoryLoaded
                  ? state.contacts
                  : <ProviderDirectoryEntity>[];

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ContactDirectoryCubit>().fetchContacts(),
                child: InboxConversationList(
                  contacts: contacts,
                  currentUserUid: authState.user.uid,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
