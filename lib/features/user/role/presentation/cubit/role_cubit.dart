import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';

// Manages role switching and provider status
class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(const RoleState.initial());

  static const _activeRoleKey = 'active_role';

  Future<void> initialize() async {
    final savedRole = await _loadSavedRole();
    if (savedRole == UserRole.provider &&
        state.providerStatus == ProviderStatus.approved) {
      emit(state.copyWith(activeRole: UserRole.provider));
    }
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

    if (status != ProviderStatus.approved && state.isProvider) {
      emit(state.copyWith(activeRole: UserRole.customer));
      _saveRole(UserRole.customer);
    }
  }

  // Reset on sign out
  void reset() {
    emit(const RoleState.initial());
    _clearSavedRole();
  }

  Future<UserRole> _loadSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_activeRoleKey);
    if (value == UserRole.provider.name) return UserRole.provider;
    return UserRole.customer;
  }

  Future<void> _saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeRoleKey, role.name);
  }

  Future<void> _clearSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeRoleKey);
  }
}
