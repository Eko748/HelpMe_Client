import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/manage_order/manage_order_bloc.dart';
import '../cubits/home/home_cubit.dart';
import '../services/api/api_controller.dart';
import '../ui/pages/auth/change_password_page.dart';
import '../ui/pages/auth/forget_password_page.dart';
import '../ui/pages/auth/sign_in_page.dart';
import '../ui/pages/auth/sign_up_page.dart';
import '../ui/pages/auth/verify_phone_number_page.dart';
import '../ui/pages/home/edit_profile_page.dart';
import '../ui/pages/home/history_page.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/home/profile_page.dart';
import '../ui/pages/misc/image_zoom_page.dart';
import '../ui/pages/misc/launch_page.dart';
import '../ui/pages/misc/snap_midtrans_page.dart';
import '../ui/pages/order/add_task_page.dart';
import '../ui/pages/order/chat_page.dart';
import '../ui/pages/order/detail_order_page.dart';
import '../ui/pages/order/select_mitra_page.dart';
import '../ui/pages/order/select_problem_page.dart';

class AppRoute {
  static final GoRouter appRoute = GoRouter(
    initialLocation: '/',
    routes: _routes,
    redirect: (context, state) {
      /*
        Redirect yang kupakai untuk mencegar mencegah user mengakses beberapa page,
        mungkin bisa diimprove atau ada pendekatan yang lebih baik tanpa menggunakan plugin ini
      */
      final isAuthenticated = ApiController.token != null ? true : false;
      /* 
        Untuk mengecek apakah user memilki order aktif setiap mereka melakukan navigasi,
        mungkin bisa diupdate agar hanya saat navigasi ke route tertentu
      */
      final haveOrder = context.read<ManageOrderBloc>().haveActiveOrder;
      final activeOrder = (haveOrder == true &&
              context.read<HomeCubit>().orderHistory.isNotEmpty)
          ? context.read<HomeCubit>().orderHistory.firstWhere((history) =>
              history.orderStatus?.trim().toLowerCase() == 'pending' ||
              history.orderStatus?.trim().toLowerCase() == 'booked' ||
              history.orderStatus?.trim().toLowerCase() == 'paid' ||
              history.orderStatus?.trim().toLowerCase() == 'otw' ||
              history.orderStatus?.trim().toLowerCase() == 'in_progress' ||
              history.orderStatus?.trim().toLowerCase() == 'arrived')
          : null;
      context.read<ManageOrderBloc>().activeOrder = activeOrder;

      if (isAuthenticated == false && state.matchedLocation == '/home') {
        return '/signIn';
      }
      if (isAuthenticated == false && state.matchedLocation == '/profile') {
        return '/signIn';
      }
      if (isAuthenticated == false && state.matchedLocation == '/editProfile') {
        return '/signIn';
      }
      if (isAuthenticated == false && state.matchedLocation == '/detail') {
        return '/signIn';
      }
      if (isAuthenticated == false && state.matchedLocation == '/addTask') {
        return '/signIn';
      }
      if (isAuthenticated == true && state.matchedLocation == '/signIn') {
        return '/home';
      }
      if (isAuthenticated == true && state.matchedLocation == '/signUp') {
        return '/home';
      }
      if (haveOrder == true && state.matchedLocation == '/selectProblem') {
        return '/selectMitra?orderId=${activeOrder?.orderId}&status=${activeOrder?.orderStatus}';
      }
      if (haveOrder == true && state.matchedLocation == '/addTask') {
        return '/selectMitra?orderId=${activeOrder?.orderId}&status=${activeOrder?.orderStatus}';
      }
      if (activeOrder != null) {
        if (haveOrder == true &&
            activeOrder.orderStatus!.trim().toLowerCase().contains('pending') &&
            state.uri.query.contains('orderId=${activeOrder.orderId}') &&
            state.matchedLocation == '/detailOrder') {
          return '/selectMitra?orderId=${activeOrder.orderId}&status=${activeOrder.orderStatus}';
        }
        if (haveOrder == true &&
            !activeOrder.orderStatus!
                .trim()
                .toLowerCase()
                .contains('pending') &&
            state.matchedLocation == '/selectProblem') {
          return '/detailOrder?orderId=${context.read<ManageOrderBloc>().activeOrder?.orderId}';
        }
        if (haveOrder == true &&
            !activeOrder.orderStatus!
                .trim()
                .toLowerCase()
                .contains('pending') &&
            state.matchedLocation == '/selectTask') {
          return '/detailOrder?orderId=${context.read<ManageOrderBloc>().activeOrder?.orderId}';
        }
        if (haveOrder == true &&
            !activeOrder.orderStatus!
                .trim()
                .toLowerCase()
                .contains('pending') &&
            state.matchedLocation == '/selectMitra') {
          return '/detailOrder?orderId=${context.read<ManageOrderBloc>().activeOrder?.orderId}';
        }
      }
      return null;
    },
    errorBuilder: (context, state) => const Placeholder(),
  );

  static List<RouteBase> get _routes {
    return [
      GoRoute(
        path: '/',
        name: 'init',
        builder: (context, state) => const LaunchPage(),
      ),
      GoRoute(
        path: '/signIn',
        name: 'signInPage',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/signUp',
        name: 'signUpPage',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgetPassword',
        name: 'forgetPasswordPage',
        builder: (context, state) => const ForgetPasswordPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'homePage',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profilePage',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/editProfile',
        name: 'editProfilePage',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/changePassword',
        name: 'changePasswordPage',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/verifyPhoneNumber',
        name: 'verifyPhoneNumberPage',
        builder: (context, state) => const VerifyPhoneNumberPage(),
      ),
      GoRoute(
        path: '/selectProblem',
        name: 'selectProblemPage',
        builder: (context, state) {
          final id = state.uri.queryParameters['categoryId'].toString();
          final category = state.uri.queryParameters['category'];
          return SelectProblemPage(
            categoryId:
                !id.contains('null') && id.isNotEmpty ? int.parse(id) : null,
            category: category.toString(),
          );
        },
      ),
      GoRoute(
        path: '/addTask',
        name: 'addTaskPage',
        builder: (context, state) {
          final id = state.uri.queryParameters['problemId'].toString();
          final problem = state.uri.queryParameters['problem'];
          return AddTaskPage(
            problemId:
                !id.contains('null') && id.isNotEmpty ? int.parse(id) : null,
            problem: problem.toString(),
          );
        },
      ),
      GoRoute(
        path: '/selectMitra',
        name: 'selectMitraPage',
        builder: (context, state) {
          String id = state.uri.queryParameters['orderId'].toString();
          String status = state.uri.queryParameters['status'].toString();
          return SelectMitraPage(
            orderId:
                !id.contains('null') && id.isNotEmpty ? int.parse(id) : null,
            orderStatus: status,
          );
        },
      ),
      GoRoute(
        path: '/imageZoom',
        name: 'imageZoomPage',
        builder: (context, state) {
          final path =
              state.uri.queryParameters['imagePaths']?.split(',') ?? [];
          final name =
              state.uri.queryParameters['imageNames']?.split(',') ?? [];
          return ImageZoomPage(
            imagePaths: path,
            imageNames: name,
          );
        },
      ),
      GoRoute(
        path: '/payOrder',
        name: 'payPage',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'].toString();
          return SnapMidtransPage(token: token);
        },
      ),
      GoRoute(
        path: '/detailOrder',
        name: 'detailOrderPage',
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'].toString();
          final distance = state.uri.queryParameters['distance'].toString();
          return DetailOrderPage(
            orderId: !orderId.contains('null') && orderId.isNotEmpty
                ? int.parse(orderId)
                : null,
            distanceInKm: !distance.contains('null') && distance.isNotEmpty
                ? double.parse(distance)
                : null,
          );
        },
      ),
      GoRoute(
        path: '/chat',
        name: 'chatPage',
        builder: (context, state) {
          final userId = state.uri.queryParameters['id'].toString();
          final chatRoomCode = state.uri.queryParameters['roomCode'].toString();
          final mitraName = state.uri.queryParameters['name'].toString();
          final imgPath = state.uri.queryParameters['img'].toString();
          return ChatPage(
            userId: !userId.contains('null') && userId.isNotEmpty
                ? int.parse(userId)
                : 0,
            chatRoomCode: chatRoomCode,
            mitraName: mitraName,
            imgPath: imgPath,
          );
        },
      ),
      GoRoute(
          path: '/history',
          name: 'historyPage',
          builder: (context, state) => const HistoryPage()),
    ];
  }
}
