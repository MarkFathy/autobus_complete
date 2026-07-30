part of '../screens/privacy_policy_screen.dart';

class PrivacyPolicyScreenBody extends StatelessWidget {
  const PrivacyPolicyScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppInfoCubit>()..loadPrivacyPolicy(),
      child: BlocBuilder<AppInfoCubit, AppInfoState>(
        builder: (context, state) {
          final isLoading = state is AppInfoLoading;
          final isError = state is AppInfoError;
          final errorMessage = isError ? state.message : '';

          final title = state is AppInfoLoaded
              ? state.info.getLocalizedTitle(context)
              : '';
          final content = state is AppInfoLoaded
              ? state.info.getLocalizedContent(context)
              : '';

          return AppLoadingOverlay(
            isLoading: isLoading,
            child: AppScaffold(
              safeBottom: true,
              appBar: const CustomAppBar(showBackButton: true),
              body: isError
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: Text(
                          errorMessage,
                          style: getTextStyle().s14.w600.redColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: getTextStyle().s18.bold.yellowColor,
                          ),
                          20.szH,
                          Text(
                            content,
                            style: getTextStyle().s16.w400.whiteColor.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
