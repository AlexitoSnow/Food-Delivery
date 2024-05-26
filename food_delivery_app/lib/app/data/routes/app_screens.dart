import 'package:go_router/go_router.dart';

import '../../domain/model/food_item.dart';
import '../../presentation/view/screens.dart';

part 'app_routes.dart';

class AppScreens {
  static GoRouter appRouter() {
    return GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: AppRoutes.home,
              builder: (context, state) => const HomeView(),
            ),
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartView(),
            ),
            GoRoute(
              path: AppRoutes.wallet,
              builder: (context, state) => const Wallet(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileView(),
            ),
          ],
          builder: (context, state, child) {
            return ParentView(currentWidget: child);
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login,
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          name: AppRoutes.signUp,
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordView(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnBoardingView(),
        ),
        GoRoute(
          path: AppRoutes.details,
          builder: (context, state) {
            return DetailsView(
              foodItem: state.extra as FoodItem,
            );
          },
        ),
      ],
    );
  }
}
