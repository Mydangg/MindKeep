import 'package:flutter/widgets.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/core/widgets/alter/loading_overlay.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/auth_api.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/features/auth/helper/local_storage_helper.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  AuthController() {
    passwordFocusNode.addListener(() {
      showPasswordChecklist = passwordFocusNode.hasFocus;
      notifyListeners();
    });

    password.addListener(notifyListeners);
  }

  final AuthApi service = AuthApi();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool isPasswordVisible = false;
  bool showPasswordChecklist = false;

  PsychUser? _currentUser;
  PsychUser? get currentUser => _currentUser;
  bool get isSignIn => _isSignIn;
  bool _isSignIn = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void setUser(PsychUser user) {
    _currentUser = user;
    _isSignIn = true;
    notifyListeners();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> clearUser() async {
    _currentUser = null;
    _isSignIn = false;
    notifyListeners();
  }

  Future<void> isLoginIn() async {
    final user = await LocalStorageHelper.getUser();
    if (user != null) {
      setUser(user);
    }
    notifyListeners();
    notifyListeners();
  }

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> signIn(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (!validateForm(formKey)) return;

    final overlay = LoadingOverlay()..showLoading(context);

    final data = {'email': email.text, 'password': password.text};

    try {
      final response = await service.signIn(data);

      if (response['user'] != null) {
        final user = PsychUser.fromJson(response['user']);
        await LocalStorageHelper.saveUser(user);
        setUser(user);
      }

      if (!context.mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(PageRoutes.homePage);
        }
      });
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }

  // try {
  //   print("SIGNUP DATA: $data");

  //   final response = await service.signUp(data);

  //   print("SIGNUP RESPONSE: $response");

  //   PredictSnackBar().showSnackBar(context, response['message'] ?? "Đăng ký thành công");
  //   context.go(PageRoutes.signIn);
  // } on ApiException catch (e) {
  //   print("SIGNUP ERROR: $e");
  //   PredictSnackBar().showSnackBar(context, e.toString());
  // } finally {
  //   overlay.hideLoading(context);
  // }
  // }

  Future<void> signUp(BuildContext context,GlobalKey<FormState> formKey) async {
    if (!validateForm(formKey)) return;

    final overlay = LoadingOverlay()..showLoading(context);

    final data = {
      'email': email.text,
      'password': password.text,
      'username': name.text,
    };

    try {
      final response = await service.signUp(data);
      PredictSnackBar().showSnackBar(context, response['message']);
      context.go(PageRoutes.signIn);
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }

  Future<void> signOut(BuildContext context) async {
    await LocalStorageHelper.clearUser();
    await clearUser();
    if (context.mounted) {
      context.go(PageRoutes.auth);
    }
  }
}
