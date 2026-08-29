import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';

// Auth
import 'features/auth/domain/usecases/update_profile_usecase.dart';
import 'features/destination/domain/usecases/get_user_submissions_usecase.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
// Destination
import 'features/destination/data/datasources/destination_remote_data_source.dart';
import 'features/destination/data/repositories/destination_repository_impl.dart';
import 'features/destination/domain/repositories/destination_repository.dart';
import 'features/destination/domain/usecases/get_featured_destinations_usecase.dart';
import 'features/destination/domain/usecases/get_destinations_by_category_usecase.dart';
import 'features/destination/domain/usecases/get_pending_submissions_usecase.dart';
import 'features/destination/domain/usecases/approve_submission_usecase.dart';
import 'features/destination/domain/usecases/reject_submission_usecase.dart';
import 'features/destination/presentation/providers/destination_provider.dart';
import 'features/destination/presentation/providers/admin_provider.dart';
import 'features/destination/domain/usecases/get_destination_by_id_usecase.dart';
import 'features/destination/domain/usecases/search_destinations_usecase.dart';
import 'features/destination/domain/usecases/submit_destination_usecase.dart';
import 'features/destination/domain/usecases/update_destination_usecase.dart';
import 'features/destination/domain/usecases/delete_destination_usecase.dart';
import 'features/destination/domain/usecases/get_discover_feed_usecase.dart';


import 'features/category/data/datasources/category_remote_data_source.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/category/domain/repositories/category_repository.dart';
import 'features/category/domain/usecases/get_categories_usecase.dart';
import 'features/category/domain/usecases/create_category_usecase.dart';
import 'features/category/domain/usecases/update_category_usecase.dart';
import 'features/category/domain/usecases/delete_category_usecase.dart';
import 'features/category/presentation/providers/category_provider.dart';
import 'features/review/data/datasources/review_remote_data_source.dart';
import 'features/review/data/repositories/review_repository_impl.dart';
import 'features/review/domain/repositories/review_repository.dart';
import 'features/review/domain/usecases/get_reviews_usecase.dart';
import 'features/review/domain/usecases/submit_review_usecase.dart';
import 'features/review/domain/usecases/delete_review_usecase.dart';
import 'features/review/presentation/providers/review_provider.dart';
import 'features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/domain/repositories/wishlist_repository.dart';
import 'features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'features/wishlist/domain/usecases/toggle_wishlist_usecase.dart';
import 'features/wishlist/presentation/providers/wishlist_provider.dart';



// Screens
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_feed_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/admin/presentation/screens/admin_panel_screen.dart';
import 'features/destination/presentation/screens/submission_form_screen.dart';


class GhumNepalApp extends StatelessWidget {
  const GhumNepalApp({super.key});

  static final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ---- Auth ----
        Provider(create: (_) => AuthRemoteDataSource()),
        Provider<AuthRepository>(
          create: (context) =>
              AuthRepositoryImpl(context.read<AuthRemoteDataSource>()),
        ),
        Provider(create: (context) => UpdateProfileUseCase(context.read<AuthRepository>())),
        Provider(create: (context) => LoginUseCase(context.read<AuthRepository>())),
        Provider(create: (context) => SignUpUseCase(context.read<AuthRepository>())),
        Provider(create: (context) => LogoutUseCase(context.read<AuthRepository>())),
        Provider(create: (context) => SignInWithGoogleUseCase(context.read<AuthRepository>())),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            loginUseCase: context.read<LoginUseCase>(),
            signUpUseCase: context.read<SignUpUseCase>(),
            signInWithGoogleUseCase: context.read<SignInWithGoogleUseCase>(),
            updateProfileUseCase: context.read<UpdateProfileUseCase>(),
            logoutUseCase: context.read<LogoutUseCase>(),
          ),
        ),

        // ---- Destination ----
        Provider(create: (_) => DestinationRemoteDataSource()),
        Provider<DestinationRepository>(
          create: (context) =>
              DestinationRepositoryImpl(context.read<DestinationRemoteDataSource>()),
        ),
        Provider(create: (context) =>
            GetFeaturedDestinationsUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            GetDestinationsByCategoryUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            GetPendingSubmissionsUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            GetDestinationByIdUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            SearchDestinationsUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            SubmitDestinationUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            UpdateDestinationUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            DeleteDestinationUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            ApproveSubmissionUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            RejectSubmissionUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            GetDiscoverFeedUseCase(context.read<DestinationRepository>())),
        Provider(create: (context) =>
            GetUserSubmissionsUseCase(context.read<DestinationRepository>())),
        ChangeNotifierProvider(
          create: (context) => DestinationProvider(
            getFeaturedUseCase: context.read<GetFeaturedDestinationsUseCase>(),
            getByCategoryUseCase: context.read<GetDestinationsByCategoryUseCase>(),
            getDiscoverFeedUseCase: context.read<GetDiscoverFeedUseCase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminProvider(
            getPendingUseCase: context.read<GetPendingSubmissionsUseCase>(),
            approveUseCase: context.read<ApproveSubmissionUseCase>(),
            rejectUseCase: context.read<RejectSubmissionUseCase>(),
          ),
        ),

        // ---- Not yet migrated ----
        Provider(create: (_) => WishlistRemoteDataSource()),
        Provider<WishlistRepository>(
          create: (context) => WishlistRepositoryImpl(context.read<WishlistRemoteDataSource>()),
        ),
        Provider(create: (context) => GetWishlistUseCase(context.read<WishlistRepository>())),
        Provider(create: (context) => ToggleWishlistUseCase(context.read<WishlistRepository>())),
        Provider(create: (_) => CategoryRemoteDataSource()),
        Provider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(context.read<CategoryRemoteDataSource>()),
        ),
        Provider(create: (context) => GetCategoriesUseCase(context.read<CategoryRepository>())),
        Provider(create: (context) => CreateCategoryUseCase(context.read<CategoryRepository>())),
        Provider(create: (context) => UpdateCategoryUseCase(context.read<CategoryRepository>())),
        Provider(create: (context) => DeleteCategoryUseCase(context.read<CategoryRepository>())),
        Provider(create: (_) => ReviewRemoteDataSource()),
        Provider<ReviewRepository>(
          create: (context) => ReviewRepositoryImpl(context.read<ReviewRemoteDataSource>()),
        ),
        Provider(create: (context) => GetReviewsUseCase(context.read<ReviewRepository>())),
        Provider(create: (context) => SubmitReviewUseCase(context.read<ReviewRepository>())),
        Provider(create: (context) => DeleteReviewUseCase(context.read<ReviewRepository>())),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(
            getCategoriesUseCase: context.read<GetCategoriesUseCase>(),
            createCategoryUseCase: context.read<CreateCategoryUseCase>(),
            updateCategoryUseCase: context.read<UpdateCategoryUseCase>(),
            deleteCategoryUseCase: context.read<DeleteCategoryUseCase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistProvider(
            getWishlistUseCase: context.read<GetWishlistUseCase>(),
            toggleWishlistUseCase: context.read<ToggleWishlistUseCase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(
            getReviewsUseCase: context.read<GetReviewsUseCase>(),
            submitReviewUseCase: context.read<SubmitReviewUseCase>(),
            deleteReviewUseCase: context.read<DeleteReviewUseCase>(),
            updateDestinationUseCase: context.read<UpdateDestinationUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'GhumNepal',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messengerKey,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeFeedScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/admin': (context) => const AdminPanelScreen(),
          '/submit': (context) => const SubmissionFormScreen(),
        },
      ),
    );
  }
}