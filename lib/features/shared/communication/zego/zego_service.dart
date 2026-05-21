import 'package:flutter/material.dart';
import 'package:serviko_app/core/config/zego_config.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_token_manager.dart';
import 'package:serviko_app/features/user/auth/domain/entities/user_entity.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ZegoService {
  ZegoService({required ZegoTokenManager tokenManager})
    : _tokenManager = tokenManager;

  final ZegoTokenManager _tokenManager;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  bool _sdkInitialized = false;
  String? _loggedInUserId;

  // Initialize the Zego SDK
  Future<void> initializeSdk() async {
    if (_sdkInitialized || ZegoConfig.appId == 0) return;
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
    await ZIMKit().init(appID: ZegoConfig.appId, appSign: ZegoConfig.appSign);
    _sdkInitialized = true;
  }

  // Login the user to Zego services
  Future<void> login(UserEntity user) async {
    if (ZegoConfig.appId == 0) return;
    if (_loggedInUserId == user.uid) return;

    await initializeSdk();
    final tokenResult = await _tokenManager.getValidToken();
    final token = tokenResult.fold((failure) => '', (value) => value);
    final userName = _safeUserName(user.displayName ?? 'Serviko User');

    await ZIMKit().connectUser(id: user.uid, name: userName);
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: ZegoConfig.appId,
      appSign: ZegoConfig.appSign,
      token: token,
      userID: user.uid,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
    _loggedInUserId = user.uid;
  }

  // Logout the user from Zego services
  Future<void> logout() async {
    _loggedInUserId = null;
    _tokenManager.clear();
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    await ZIMKit().disconnectUser();
  }

  Future<void> updateUserDisplayName(String displayName) async {
    if (ZegoConfig.appId == 0 || _loggedInUserId == null) return;

    final userName = _safeUserName(displayName);
    await ZIMKit().updateUserInfo(name: userName);
  }

  Future<bool> startCall({
    required ProviderDirectoryEntity contact,
    required bool isVideoCall,
    required String customerFirebaseUid,
  }) {
    return ZegoUIKitPrebuiltCallInvitationService().send(
      invitees: [ZegoCallUser(contact.firebaseUid, contact.displayName)],
      isVideoCall: isVideoCall,
      callID: conversationId(
        customerFirebaseUid: customerFirebaseUid,
        providerFirebaseUid: contact.firebaseUid,
      ),
    );
  }

  String conversationId({
    required String customerFirebaseUid,
    required String providerFirebaseUid,
  }) {
    final customer = _zegoSafeId(customerFirebaseUid);
    final provider = _zegoSafeId(providerFirebaseUid);
    return 'user_${customer}_provider_$provider';
  }

  String _safeUserName(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? 'Serviko User' : trimmed;
  }

  String _zegoSafeId(String value) {
    return value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  }
}
