import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemstone_fyp/Screens/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Mock HTTP Client
class MockClient extends Mock implements http.Client {}

Future<void> setupFirebaseTesting() async {
  TestWidgetsFlutterBinding.ensureInitialized();// Ensures the test environment is initialized.
  FirebasePlatform.instance = MockFirebasePlatform();//  Sets up a mock Firebase instance for testing.
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'test-api-key',
      appId: 'test-app-id',
      messagingSenderId: 'test-sender-id',
      projectId: 'test-project-id',
    ),
  );
}

//This mocks the Firebase platform so that Firebase services can be accessed
// in the test environment without needing a real Firebase connection.
class MockFirebasePlatform extends FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseApp(name: name, options: options);
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseApp(
      name: name,
      options: const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
      ),
    );
  }
}

class MockFirebaseApp extends FirebaseAppPlatform {//This class act as Firebase app instance with fake credentials.
  MockFirebaseApp({String? name, FirebaseOptions? options})
      : super(name ?? defaultFirebaseAppName, options!);
}

void main() async {
  await setupFirebaseTesting();

  late MyHomePageState myHomePage;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    myHomePage = MyHomePageState(client: mockClient);
  });

  test('getPredictedPrice should return a valid price when API call succeeds', () async {
    final mockResponse = jsonEncode({"predicted_price": 2500.0});

    when(mockClient.post(// it saying when the user req with post endpoint, if it success it should return success code and response
      Uri.parse("https://gemstone-model.onrender.com/predict"),
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    final price = await myHomePage.getPredictedPrice({
      "Type": "Ruby",
      "Color": "Red",
      "Clarity": "VVS1",
      "Cut": "Oval",
      "Treatment": "Heated",
      "Hardness": 9,
      "Carat": 1.5,
    });

    expect(price, 2500.0);
  });
}