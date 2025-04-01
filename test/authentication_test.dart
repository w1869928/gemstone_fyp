import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemstone_fyp/Screens/auth.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockAuth;
  late Auth auth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    auth = Auth(firebaseAuth: mockAuth); // Passing mock auth
  });

  test("Successful sign-in with email and password", () async {
    final mockUserCredential = MockUserCredential();

    when(mockAuth.signInWithEmailAndPassword(// when user sing in with below
      // credential it should return mockUserCredential result
      email: "test@example.com",
      password: "securePassword123",
    )).thenAnswer((_) async => mockUserCredential);

    final result = await auth.signInWithEmailAndPassword(
      email: "test@example.com",
      password: "securePassword123",
    );

    expect(result, mockUserCredential);//checking the result
  });
}
