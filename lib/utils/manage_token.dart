import '../services/firebase/firebase_api.dart';
import 'secure_storage.dart';
import '../services/api/api_controller.dart';

class ManageAuthToken {
  static void readToken() async {
    await SecureStorage()
        .readSecureData('authToken')
        .then((value) => ApiController.token = value);
  }

  static void writeToken() async {
    ApiController.token != null
        ? await SecureStorage().writeSecureData(
            'authToken',
            ApiController.token!,
          )
        : null;
  }

  static void deleteToken() async {
    await SecureStorage().deleteSecureData('authToken');
    ApiController.token = null;
  }
}

class ManageSnapToken {
  static Future<String?> readToken() async {
    final value = await SecureStorage().readSecureData('snapToken');
    return value;
  }

  static void writeToken(String? snapToken) async {
    snapToken != null
        ? await SecureStorage().writeSecureData(
            'snapToken',
            snapToken,
          )
        : null;
  }

  static void deleteToken() async {
    await SecureStorage().deleteSecureData('snapToken');
  }
}

class ManageFCMToken {
  static Future<String?> readToken() async {
    final value = await SecureStorage().readSecureData('fcmToken').then(
          (value) => FirebaseMessagingApi.fcmToken == null
              ? FirebaseMessagingApi.fcmToken = value
              : null,
        );
    return value;
  }

  static void writeToken(String? fcmToken) async {
    fcmToken != null
        ? await SecureStorage().writeSecureData(
            'fcmToken',
            fcmToken,
          )
        : null;
  }

  static void deleteToken() async {
    await SecureStorage().deleteSecureData('fcmToken');
  }
}
