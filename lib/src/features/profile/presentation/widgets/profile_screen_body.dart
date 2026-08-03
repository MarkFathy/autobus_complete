part of '../screens/profile_screen.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) {
        final cubit = sl<ProfileCubit>();
        unawaited(cubit.getUserProfile());
        return cubit;
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _nameController.text = state.user.name;
            _emailController.text = state.user.email;
          } else if (state is ProfileUpdateSuccess) {
            _nameController.text = state.user.name;
            _emailController.text = state.user.email;
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).profileUpdatedSuccess,
            );
            Go.back();
          } else if (state is ProfilePasswordResetSent) {
            CustomSnackBar.showSuccess(
              context,
              message: state.message,
            );
          } else if (state is ProfileAccountDeleted) {
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).operationCancelled, // or deleted success
            );
            unawaited(Go.offAllNamed(NamedRoutes.login));
          } else if (state is ProfileError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final isLoading = state is ProfileLoading;
          final currentUser = cubit.currentUser;

          return AppLoadingOverlay(
            isLoading: isLoading,
            child: AppScaffold(
              safeTop: true,
              appBar: CustomAppBar(
                title: Text(
                  S.of(context).editProfile,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      24.szH,
                      // ── Avatar Image Picker ───────────────────────
                      UserAvatarPicker(
                        selectedImage: cubit.selectedImage,
                        imageUrl: cubit.isImageRemoved
                            ? null
                            : currentUser?.photoUrl,
                        onPickImageSource: cubit.pickImage,
                        onRemoveImage: cubit.removeImage,
                        radius: 65,
                      ),
                      30.szH,

                      // ── Full Name Field ───────────────────────────
                      DefaultTextField(
                        controller: _nameController,
                        hint: S.of(context).fullName,
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: context.colors.onSurfaceVariant,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? S.of(context).pleaseFillAllFields
                                : null,
                      ),
                      16.szH,

                      // ── Email Field ───────────────────────────────
                      DefaultTextField(
                        controller: _emailController,
                        hint: S.of(context).email,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: context.colors.onSurfaceVariant,
                        ),
                        inputType: TextInputType.emailAddress,
                        validator: (value) => Validators.validateEmail(
                          value,
                          emptyMessage: S.of(context).pleaseFillAllFields,
                        ),
                      ),
                      24.szH,

                      // ── Save Changes Button ───────────────────────
                      CustomButton(
                        text: S.of(context).saveChanges,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            unawaited(
                              cubit.updateProfile(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                              ),
                            );
                          }
                        },
                      ),
                      24.szH,

                      // ── Change Password & Actions Group ───────────
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: context.colors.primary.withValues(alpha: 0.3),
                            width: 1.w,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 6.h,
                            ),
                            leading: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: context.colors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_reset_rounded,
                                color: context.colors.primary,
                                size: 22.sp,
                              ),
                            ),
                            title: Text(
                              S.of(context).changePassword,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.colors.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).changePasswordInfo,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                            trailing: Icon(
                              Icons.send_rounded,
                              color: context.colors.primary,
                              size: 18.sp,
                            ),
                            onTap: cubit.sendPasswordResetEmail,
                          ),
                        ),
                      ),
                      20.szH,

                      // ── Delete Account Button ─────────────────────
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: context.colors.secondary.withValues(alpha: 0.4),
                            width: 1.w,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            leading: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: context.colors.secondaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: context.colors.secondary,
                                size: 22.sp,
                              ),
                            ),
                            title: Text(
                              S.of(context).deleteAccount,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.colors.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            onTap: () {
                              unawaited(
                                DeleteAccountBottomSheet.show(
                                  context,
                                  onConfirmDelete: cubit.deleteAccount,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      30.szH,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
}
