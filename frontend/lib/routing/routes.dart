import 'package:flutter/material.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/features/articles/articles_detail_screen.dart';
import 'package:frontend/features/articles/articles_screen.dart';
import 'package:frontend/features/articles/controller/article_controller.dart';
import 'package:frontend/features/auth/center_auth_screen.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/auth/sign_in_screen.dart';
import 'package:frontend/features/auth/sign_up_screen.dart';
import 'package:frontend/features/chatbot/chatbot_screen.dart';
import 'package:frontend/features/detail_prediction/detail_prediction_screen.dart';
import 'package:frontend/features/exam_dass21/controller/exam_dass21_controller.dart';
import 'package:frontend/features/exam_dass21/exam_conclusion_screen.dart';
import 'package:frontend/features/exam_dass21/exam_dass21_screen.dart';
import 'package:frontend/features/home/controller/home_controller.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'package:frontend/features/layout/layout_scaffold.dart';
import 'package:frontend/features/profile/controller/profile_controller.dart';
import 'package:frontend/features/profile/profile_screen.dart';
import 'package:frontend/features/profile/section/account_screen.dart';
import 'package:frontend/features/profile/section/feedback_screen.dart';
import 'package:frontend/features/profile/section/save_articles_screen.dart';
import 'package:frontend/features/test_emtion/controller/test_emotion_controller.dart';
import 'package:frontend/features/test_emtion/test_emotion_screen.dart';
import 'package:frontend/features/topic_article/controller/topic_article_controller.dart';
import 'package:frontend/features/topic_article/topic_screen.dart';
import 'package:frontend/routing/animation.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/topic_article/add_article_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final authController = AuthController();

final goRouter = GoRouter(
  initialLocation: PageRoutes.auth,
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: PageRoutes.auth,
      pageBuilder:
          (context, state) => animationRouter(const CenterAuthScreen(), state),
    ),
    GoRoute(
      path: PageRoutes.signUp,
      pageBuilder:
          (context, state) => animationRouter(const SignUpScreen(), state),
    ),
    GoRoute(
      path: PageRoutes.signIn,
      pageBuilder:
          (context, state) => animationRouter(const SignInScreen(), state),
    ),
    GoRoute(
      path: PageRoutes.detailPrediction,
      pageBuilder: (context, state) {
        final data = state.extra! as Map<String, dynamic>;
        final prediction = data['prediction'];
        final resultTest = data['resultTest'];
        final count = data['count'];

        return animationRouter(
          DetailPredictionScreen(
            prediction: prediction,
            resultTest: resultTest,
            count: count,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: PageRoutes.testPsych,
      pageBuilder:
          (context, state) => animationRouter(
            ChangeNotifierProvider(
              create: (context) => TestEmotionController(),
              child: const TestEmotionScreen(),
            ),
            state,
          ),
    ),
    GoRoute(
      path: PageRoutes.examDass21,
      pageBuilder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;

        final predictionId = extra['id'] as String;
        final finalEmotion = extra['final_emotion'] as String;

        return animationRouter(
          ChangeNotifierProvider(
            create: (context) => TestDass21Controller(),
            child: Dass21TestScreen(
              predictionId: predictionId,
              finalEmotion: finalEmotion,
            ),
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: PageRoutes.finalResult,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final response = extra?['response'];
        final finalEmotion = extra?['final_emotion'] as String?;

        return animationRouter(
          ChangeNotifierProvider(
            create: (context) => TestDass21Controller(),
            child: ExamConclusionScreen(
              result: response,
              finalEmotion: finalEmotion??'Chứa xác định',
            ),
          ),
          state,
        );
      },
    ),

    GoRoute(
      path: PageRoutes.listArticles,
      pageBuilder: (context, state) {
        final data = state.extra! as Map<String, dynamic>;
        final nameTopic = data['nameTopic'] as String;
        final listArticles = data['articles'] as List<Article>;
        return animationRouter(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TopicArticleController()),
              ChangeNotifierProvider(create: (_) => ArticleController()),
            ],
            child: TopicScreen(topic: nameTopic, listArticles: listArticles),
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: PageRoutes.detailArticle,
      pageBuilder: (context, state) {
        final data = state.extra! as Article;
        return animationRouter(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TopicArticleController()),
              ChangeNotifierProvider(create: (_) => ArticleController()),
            ],
            child: ArticlesDetailScreen(article: data),
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: PageRoutes.feedback,
      pageBuilder:
          (context, state) => animationRouter(
            ChangeNotifierProvider(
              create: (context) => ProfileController(),
              child: const FeedbackScreen(),
            ),
            state,
          ),
    ),
    GoRoute(
      path: PageRoutes.updateProfile,
      pageBuilder:
          (context, state) => animationRouter(
            ChangeNotifierProvider(
              create: (context) => ProfileController(),
              child: const AccountScreen(),
            ),
            state,
          ),
    ),
    GoRoute(
      path: PageRoutes.addArticle,
      builder: (context, state) => const AddArticleScreen(),
    ),
    GoRoute(
      path: PageRoutes.tabSaveAndLike,
      pageBuilder:
          (context, state) => animationRouter(
            ChangeNotifierProvider(
              create: (context) => ArticleController(),
              child: const SavedArticlesScreen(),
            ),
            state,
          ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LayoutScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: PageRoutes.homePage,
              pageBuilder:
                  (context, state) => animationRouter(
                    ChangeNotifierProvider(
                      create: (context) => HomeController(),
                      child: const HomeScreen(),
                    ),
                    state,
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: PageRoutes.articles,
              pageBuilder:
                  (context, state) => animationRouter(
                    MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => TopicArticleController(),
                        ),
                        ChangeNotifierProvider(
                          create: (_) => ArticleController(),
                        ),
                      ],
                      child: const ArticlesScreen(),
                    ),
                    state,
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: PageRoutes.chat,
              pageBuilder:
                  (context, state) => animationRouter(
                    ChangeNotifierProvider(
                      create: (context) => ProfileController(),
                      child: const ChatBotScreen(),
                    ),
                    state,
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: PageRoutes.profile,
              pageBuilder:
                  (context, state) =>
                      animationRouter(const ProfileScreen(), state),
            ),
          ],
        ),
      ],
    ),
  ],
);
