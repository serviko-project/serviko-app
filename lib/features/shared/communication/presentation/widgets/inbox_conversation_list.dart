import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/models/inbox_entry.dart';
import 'package:serviko_app/features/shared/communication/presentation/pages/chat_screen.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/chat_tile.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/inbox_loading_skeleton.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/inbox_message.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class InboxConversationList extends StatefulWidget {
  const InboxConversationList({
    super.key,
    required this.contacts,
    required this.currentUserUid,
  });

  final List<ProviderDirectoryEntity> contacts;
  final String currentUserUid;

  @override
  State<InboxConversationList> createState() => _InboxConversationListState();
}

class _InboxConversationListState extends State<InboxConversationList> {
  late Future<ZIMKitConversationListNotifier> _conversationListFuture;

  @override
  void initState() {
    super.initState();
    _conversationListFuture = ZIMKit().getConversationListNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ZIMKitConversationListNotifier>(
      future: _conversationListFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const InboxLoadingSkeleton();

        return ValueListenableBuilder<List<ZIMKitConversationNotifier>>(
          valueListenable: snapshot.data!,
          builder: (context, conversationNotifiers, _) {
            final entries = _buildEntries(conversationNotifiers);

            if (entries.isEmpty) {
              return const InboxMessage(
                title: 'No conversations yet',
                subtitle: 'Messages from customers and providers appear here.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSizes.sm),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ChatTile(
                  contact: entry.contact,
                  conversationType: entry.conversationType,
                  conversationNotifier: entry.conversationNotifier,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          contact: entry.contact,
                          customerFirebaseUid: widget.currentUserUid,
                          conversationType: entry.conversationType,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  List<InboxEntry> _buildEntries(
    List<ZIMKitConversationNotifier> conversationNotifiers,
  ) {
    final contactsByUid = {
      for (final contact in widget.contacts) contact.firebaseUid: contact,
    };
    final entries = <InboxEntry>[];
    final addedIds = <String>{};

    final sortedConversationNotifiers = [...conversationNotifiers]
      ..sort((a, b) => b.value.orderKey.compareTo(a.value.orderKey));

    for (final notifier in sortedConversationNotifiers) {
      final conversation = notifier.value;
      if (conversation.type != ZIMConversationType.peer) continue;
      if (conversation.id.isEmpty || conversation.id == widget.currentUserUid) {
        continue;
      }

      final contact = contactsByUid[conversation.id];
      entries.add(
        InboxEntry(
          contact: contact ?? _contactFromConversation(conversation),
          conversationType: conversation.type,
          conversationNotifier: notifier,
        ),
      );
      addedIds.add(conversation.id);
    }

    for (final contact in widget.contacts) {
      if (contact.firebaseUid.isEmpty ||
          contact.firebaseUid == widget.currentUserUid ||
          addedIds.contains(contact.firebaseUid)) {
        continue;
      }

      entries.add(
        InboxEntry(
          contact: contact,
          conversationType: ZIMConversationType.peer,
        ),
      );
    }

    return entries;
  }

  ProviderDirectoryEntity _contactFromConversation(
    ZIMKitConversation conversation,
  ) {
    final name = conversation.name.trim().isEmpty
        ? conversation.id
        : conversation.name;
    final avatarUrl = conversation.avatarUrl.trim().isEmpty
        ? null
        : conversation.avatarUrl;

    return ProviderDirectoryEntity(
      id: conversation.id,
      userId: conversation.id,
      firebaseUid: conversation.id,
      name: name,
      profileImageUrl: avatarUrl,
      professionalTitle: 'Customer',
    );
  }
}
