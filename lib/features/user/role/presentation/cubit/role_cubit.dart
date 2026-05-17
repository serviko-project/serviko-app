import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';

// Manages role switching and provider status
class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(const RoleState.initial());

  static const _activeRoleKey = 'active_role';
  static const _providerStatusKey = 'provider_status';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final savedRoleValue = prefs.getString(_activeRoleKey);
    final savedStatusValue = prefs.getString(_providerStatusKey);

    final savedRole = savedRoleValue == UserRole.provider.name
        ? UserRole.provider
        : UserRole.customer;

    final savedStatus = ProviderStatus.values.firstWhere(
      (e) => e.name == savedStatusValue,
      orElse: () => ProviderStatus.none,
    );

    // Only switch to provider if status=approved
    final effectiveRole =
        (savedRole == UserRole.provider &&
            savedStatus == ProviderStatus.approved)
        ? UserRole.provider
        : UserRole.customer;

    emit(
      state.copyWith(activeRole: effectiveRole, providerStatus: savedStatus),
    );
  }

  // Switch to provider mode
  void switchToProvider() {
    if (!state.canSwitchToProvider) return;
    emit(state.copyWith(activeRole: UserRole.provider));
    _saveRole(UserRole.provider);
  }

  // Switch back to customer mode
  void switchToCustomer() {
    emit(state.copyWith(activeRole: UserRole.customer));
    _saveRole(UserRole.customer);
  }

  // Update provider status
  void updateProviderStatus(ProviderStatus status) {
    emit(state.copyWith(providerStatus: status));
    _saveProviderStatus(status);

    if (status != ProviderStatus.approved && state.isProvider) {
      emit(state.copyWith(activeRole: UserRole.customer));
      _saveRole(UserRole.customer);
    }
  }

  // Sync provider status from profile API response
  void syncProviderStatusFromProfile(String? statusString) {
    if (statusString == null) {
      updateProviderStatus(ProviderStatus.none);
      return;
    }

    final status = ProviderStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => ProviderStatus.none,
    );
    updateProviderStatus(status);

    if (status == ProviderStatus.approved) {
      initialize();
    }
  }

  // Reset on sign out
  void reset() {
    emit(const RoleState.initial());
    _clearSavedData();
  }

  Future<void> _saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeRoleKey, role.name);
  }

  Future<void> _saveProviderStatus(ProviderStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_providerStatusKey, status.name);
  }

  Future<void> _clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeRoleKey);
    await prefs.remove(_providerStatusKey);
  }
}
