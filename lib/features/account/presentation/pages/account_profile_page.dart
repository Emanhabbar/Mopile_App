import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/account_profile.dart';
import '../../data/repositories/account_repository.dart';
import '../controllers/account_providers.dart';

class AccountProfilePage extends ConsumerStatefulWidget {
  const AccountProfilePage({super.key});

  @override
  ConsumerState<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends ConsumerState<AccountProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountProfileProvider);
    final session = ref.watch(authControllerProvider).valueOrNull;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.accountProfileTitle),
            Text(
              l10n.accountProfileSubtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: profile.when(
        loading: () => AppLoadingState(label: l10n.accountLoadingProfile),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(accountProfileProvider),
        ),
        data: (data) {
          _initialize(data);
          final user = session?.user ?? _fallbackUser(data);
          return RefreshIndicator(
            onRefresh: () => ref.refresh(accountProfileProvider.future),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                AppReveal(
                  child: _AvatarEditor(
                    user: user,
                    busy: _saving,
                    onUpload: _uploadAvatar,
                    onDelete: data.hasProfileImage ? _deleteAvatar : null,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: context.appColors.surface,
                      borderRadius: BorderRadius.circular(23),
                      border: Border.all(color: context.appColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: context.appColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(
                                Icons.edit_note_rounded,
                                color: context.appColors.primary,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Text(
                              l10n.accountBasicData,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: l10n.accountFullName,
                          controller: _nameController,
                          icon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return l10n.accountFullNameRequired;
                            if (text.length > 150) {
                              return l10n.accountFullNameTooLong;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: data.email,
                          enabled: false,
                          cursorColor: context.appColors.primary,
                          cursorWidth: 1.4,
                          style: TextStyle(
                            color: context.appColors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.accountEmailLabel,
                            labelStyle: TextStyle(
                              color: context.appColors.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 14,
                                end: 10,
                              ),
                              child: Icon(
                                Icons.email_outlined,
                                size: 21,
                                color: context.appColors.primary,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 46,
                              minHeight: 52,
                            ),
                            filled: true,
                            fillColor: context.appColors.surfaceSoft,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: l10n.accountPhoneLabel,
                          controller: _phoneController,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          hint: l10n.accountOptionalHint,
                          validator: (value) => (value?.trim().length ?? 0) > 30
                              ? l10n.accountPhoneTooLong
                              : null,
                        ),
                        const SizedBox(height: 22),
                        FilledButton.icon(
                          onPressed: _saving ? null : _saveProfile,
                          icon: _saving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(l10n.saveChanges),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _initialize(AccountProfile profile) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = profile.fullName;
    _phoneController.text = profile.phoneNumber ?? '';
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    await _run(() async {
      final profile = await ref
          .read(accountRepositoryProvider)
          .updateProfile(
            fullName: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
          );
      await _applyProfile(profile);
      _showMessage(l10n.accountSaved);
    });
  }

  Future<void> _uploadAvatar() async {
    final l10n = AppLocalizations.of(context);
    final group = XTypeGroup(
      label: l10n.accountImagesGroup,
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
    );
    final file = await openFile(acceptedTypeGroups: [group]);
    if (file == null) return;
    if (await file.length() > 5 * 1024 * 1024) {
      _showMessage(l10n.accountImageTooLarge, isError: true);
      return;
    }
    await _run(() async {
      final profile = await ref
          .read(accountRepositoryProvider)
          .updateAvatar(filePath: file.path, fileName: file.name);
      await _applyProfile(profile);
      _showMessage(l10n.accountAvatarUpdated);
    });
  }

  Future<void> _deleteAvatar() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteImageTitle),
          content: Text(l10n.deleteImageConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await _run(() async {
      final profile = await ref.read(accountRepositoryProvider).deleteAvatar();
      await _applyProfile(profile);
      _showMessage(l10n.accountAvatarDeleted);
    });
  }

  Future<void> _applyProfile(AccountProfile profile) async {
    final current = ref.read(authControllerProvider).valueOrNull?.user;
    if (current != null) {
      await ref
          .read(authControllerProvider.notifier)
          .updateCurrentUser(profile.mergeInto(current));
    }
    ref.invalidate(accountProfileProvider);
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _saving = true);
    try {
      await action();
    } catch (error) {
      _showMessage(_message(error), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _message(Object error) => error is ApiException
      ? error.message
      : AppLocalizations.of(context).accountOperationFailed;

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? context.appColors.danger : context.appColors.primary,
      ),
    );
  }

  AuthUser _fallbackUser(AccountProfile profile) => AuthUser(
    userId: profile.userId,
    email: profile.email,
    fullName: profile.fullName,
    roles: profile.roles,
    hasProfileImage: profile.hasProfileImage,
    profileImageUpdatedAtUtc: profile.profileImageUpdatedAtUtc,
  );
}

class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.user,
    required this.busy,
    required this.onUpload,
    this.onDelete,
  });

  final AuthUser user;
  final bool busy;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.appColors.primary,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: context.appColors.primaryDark.withValues(alpha: 0.35)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ProfileAvatar(user: user, radius: 46),
          const SizedBox(height: 14),
          Text(
            user.fullName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 9,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.tonalIcon(
                onPressed: busy ? null : onUpload,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(
                  user.hasProfileImage
                      ? AppLocalizations.of(context).changePhoto
                      : AppLocalizations.of(context).addPhoto,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: context.appColors.secondary,
                  foregroundColor: context.appColors.primaryDeep,
                ),
              ),
              if (onDelete != null)
                TextButton.icon(
                  onPressed: busy ? null : onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(
                    AppLocalizations.of(context).removePhoto,
                  ),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
