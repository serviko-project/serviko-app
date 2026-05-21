import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class InboxEntry {
  const InboxEntry({
    required this.contact,
    required this.conversationType,
    this.conversationNotifier,
  });

  final ProviderDirectoryEntity contact;
  final ZIMConversationType conversationType;
  final ZIMKitConversationNotifier? conversationNotifier;
}
