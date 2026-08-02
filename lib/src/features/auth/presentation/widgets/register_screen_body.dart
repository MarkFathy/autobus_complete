part of '../screens/register_screen.dart';

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({super.key});

  @override
  State<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameKey = GlobalKey<DefaultTextFieldState>();
  final _emailKey = GlobalKey<DefaultTextFieldState>();
  final _passwordKey = GlobalKey<DefaultTextFieldState>();
  final _confirmPasswordKey = GlobalKey<DefaultTextFieldState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).registerSuccess,
            );
            unawaited(Go.offAllNamed(NamedRoutes.home));
          } else if (state is AuthEmailVerificationSent) {
            CustomSnackBar.showSuccess(context, message: state.message);
            Go.back();
          } else if (state is AuthError) {
            _nameKey.currentState?.shake();
            _emailKey.currentState?.shake();
            _passwordKey.currentState?.shake();
            _confirmPasswordKey.currentState?.shake();
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isLoading = state is AuthLoading;
          final selectedImage = cubit.selectedImage;

          return AppLoadingOverlay(
            isLoading: isLoading,
            child: AppScaffold(
              safeTop: true,
              appBar: const CustomAppBar(),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                child: Column(
                  children: [
                      UserAvatarPicker(
                        selectedImage: selectedImage,
                        onPickImageSource: cubit.pickImage,
                        onRemoveImage: cubit.removeImage,
                      ),
                      40.szH,
                      DefaultTextField(
                        key: _nameKey,
                        prefixIcon: const Icon(Icons.person),
                        hint: S.of(context).fullName,
                        controller: _nameController,
                        validator: (value) => value == null || value.trim().isEmpty
                            ? S.of(context).fullNameRequired
                            : null,
                      ),
                      20.szH,
                      DefaultTextField(
                        key: _emailKey,
                        prefixIcon: const Icon(Icons.email),
                        hint: S.of(context).email,
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        validator: (value) => Validators.validateEmail(
                          value,
                          emptyMessage: S.of(context).emailRequired,
                          invalidMessage: S.of(context).invalidEmail,
                        ),
                      ),
                      20.szH,
                      DefaultTextField(
                        key: _passwordKey,
                        prefixIcon: const Icon(Icons.lock),
                        hint: S.of(context).password,
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) => Validators.validatePassword(
                          value,
                          emptyMessage: S.of(context).passwordRequired,
                          minLengthMessage: S.of(context).passwordMinLength,
                        ),
                      ),
                      20.szH,
                      DefaultTextField(
                        key: _confirmPasswordKey,
                        prefixIcon: const Icon(Icons.lock),
                        isPassword: true,
                        hint: S.of(context).passwordConfirmation,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          final passwordVal = Validators.validatePassword(
                            value,
                            emptyMessage: S.of(context).passwordRequired,
                            minLengthMessage: S.of(context).passwordMinLength,
                          );
                          if (passwordVal != null) return passwordVal;
                          if (value != _passwordController.text) {
                            return S.of(context).passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      25.szH,
                      CustomButton(
                        text: S.of(context).register,
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) {
                                  if (_nameController.text.trim().isEmpty) {
                                    _nameKey.currentState?.shake();
                                  }
                                  if (Validators.validateEmail(_emailController.text) != null) {
                                    _emailKey.currentState?.shake();
                                  }
                                  if (Validators.validatePassword(_passwordController.text) != null) {
                                    _passwordKey.currentState?.shake();
                                  }
                                  if (Validators.validatePassword(_confirmPasswordController.text) != null ||
                                      _passwordController.text != _confirmPasswordController.text) {
                                    _confirmPasswordKey.currentState?.shake();
                                    if (_passwordController.text != _confirmPasswordController.text &&
                                        _passwordController.text.isNotEmpty &&
                                        _confirmPasswordController.text.isNotEmpty) {
                                      CustomSnackBar.showError(
                                        context,
                                        message: S.of(context).passwordsDoNotMatch,
                                      );
                                    }
                                  }
                                  return;
                                }

                                final name = _nameController.text.trim();
                                final email = _emailController.text.trim();
                                final password = _passwordController.text.trim();

                                unawaited(
                                  cubit.register(
                                    name,
                                    email,
                                    password,
                                    imageFile: cubit.selectedImage,
                                  ),
                                );
                              },
                      ),
                      20.szH,
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
