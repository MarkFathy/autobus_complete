part of '../screens/login_screen.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailKey = GlobalKey<DefaultTextFieldState>();
  final _passwordKey = GlobalKey<DefaultTextFieldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              message: S.of(context).loginSuccess,
            );
            unawaited(Go.offAllNamed(NamedRoutes.home));
          } else if (state is AuthPasswordResetSent) {
            CustomSnackBar.showSuccess(context, message: state.message);
          } else if (state is AuthError) {
            _emailKey.currentState?.shake();
            _passwordKey.currentState?.shake();
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return AppLoadingOverlay(
            isLoading: isLoading,
            child: AppScaffold(
              safeTop: true,
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                child: Column(
                  children: [
                    10.szH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Assets.pngs.bus.image(width: 30.w, height: 30.h),
                        5.szW,
                        Text(
                          S.of(context).autobusComplete,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                          ),
                        ),
                        Assets.lotties.bus.lottie(width: 26.w, height: 26.h),
                      ],
                    ),

                    Assets.pngs.loginImage.image(width: 300.w, height: 220.h),
                    10.szH,

                    DefaultTextField(
                      key: _emailKey,
                      prefixIcon: const Icon(Icons.person),
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
                    15.szH,
                    ForgetPasswordButton(
                      onTap: () {
                        ForgetPasswordDialog.show(
                          context,
                          authCubit: context.read<AuthCubit>(),
                        );
                      },
                    ),
                    25.szH,
                    CustomButton(
                      text: S.of(context).login,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) {
                                if (Validators.validateEmail(
                                      _emailController.text,
                                    ) !=
                                    null) {
                                  _emailKey.currentState?.shake();
                                }
                                if (Validators.validatePassword(
                                      _passwordController.text,
                                    ) !=
                                    null) {
                                  _passwordKey.currentState?.shake();
                                }
                                return;
                              }

                              unawaited(
                                context.read<AuthCubit>().login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                            },
                    ),
                  25.szH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).dontHaveAnAccount,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      5.szW,
                      GestureDetector(
                        onTap: () {
                          unawaited(
                            Go.toNamed(
                              NamedRoutes.register,
                              transition: TransitionType.fade,
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).register,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  18.szH,
                   const OrDivider(),
                  20.szH,
                  GoogleLoginButton(
                    onTap: isLoading
                        ? () {}
                        : () => context.read<AuthCubit>().loginWithGoogle(),
                  ),
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
