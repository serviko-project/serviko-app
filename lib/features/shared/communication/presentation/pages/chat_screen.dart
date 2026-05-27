import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/cubit/chat_input_cubit.dart';
import 'package:serviko_app/features/shared/communication/presentation/cubit/chat_input_state.dart';
import 'package:serviko_app/features/shared/communication/presentation/utils/chat_message_formatters.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/chat_app_bar.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/chat_message_builders.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.contact,
    required this.customerFirebaseUid,
    this.conversationType = ZIMConversationType.peer,
  });

  final ProviderDirectoryEntity contact;
  final String customerFirebaseUid;
  final ZIMConversationType conversationType;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _editingController;
  late final ChatInputCubit _chatInputCubit;

  @override
  void initState() {
    super.initState();
    _chatInputCubit = ChatInputCubit();
    _editingController = TextEditingController();
    _editingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _editingController.dispose();
    _chatInputCubit.close();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _editingController.text;
    final screenWidth = MediaQuery.of(context).size.width;
    final newHeight = calculateChatInputHeight(text, screenWidth);
    _chatInputCubit.updateHeight(newHeight);
  }

  Future<void> _startCall(bool isVideoCall) async {
    final sent = await InjectionContainer.instance.zegoService.startCall(
      contact: widget.contact,
      isVideoCall: isVideoCall,
      customerFirebaseUid: widget.customerFirebaseUid,
    );
    if (!mounted || sent) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not start the call.')));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: AppColors.primary),
      child: BlocBuilder<ChatInputCubit, ChatInputState>(
        bloc: _chatInputCubit,
        builder: (context, state) {
          return ZIMKitMessageListPage(
            conversationID: widget.contact.firebaseUid,
            conversationType: widget.conversationType,
            showMoreButton: false,
            preMessageSending: _trimTextMessage,
            editingController: _editingController,
            messageInputHeight: state.inputHeight,
            messageInputMaxLines: 3,
            messageInputMinLines: 1,
            messageInputKeyboardType: TextInputType.multiline,
            messageInputContainerPadding: const EdgeInsets.all(AppSizes.sm),
            messageInputContainerDecoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 0.5),
              ),
            ),
            inputBackgroundDecoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            ),
            inputDecoration: const InputDecoration(
              hintText: 'Message',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: 12,
              ),
            ),
            sendButtonWidget: const Padding(
              padding: EdgeInsets.only(left: 6, right: 2),
              child: Icon(
                Icons.send_rounded,
                color: AppColors.primary,
                size: AppSizes.lg,
              ),
            ),
            messageItemBuilder: (context, message, defaultWidget) =>
                buildChatMessageItem(
                  context,
                  message,
                  defaultWidget,
                  widget.contact,
                  widget.conversationType,
                ),
            messageContentBuilder: (context, message, defaultWidget) =>
                buildChatMessageContent(context, message, defaultWidget),
            appBarBuilder: (context, defaultAppBar) => buildChatAppBar(
              context: context,
              contact: widget.contact,
              onAudioCallPressed: () => _startCall(false),
              onVideoCallPressed: () => _startCall(true),
            ),
          );
        },
      ),
    );
  }

  ZIMKitMessage _trimTextMessage(ZIMKitMessage message) {
    final textContent = message.textContent;
    if (textContent == null) return message;

    textContent.text = textContent.text.trim();
    return message;
  }
}
