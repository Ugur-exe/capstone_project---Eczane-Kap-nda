import 'package:bitirme_projesi/notification/p.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'moc_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('sendNotification', () {
    test('returns success status if the request is successful', () async {
      // Arrange
      final client = MockClient();
      const token =
          'ee6gtI8IROGmgtlQftT61p:APA91bH8NELn5ukcVYl0MwosYHQRjNKm0nv8DaMpxufc7orSgtR0Qhs_ZTHN7ca9Zbivptvu3W2iM1xvk541015h2RoLdf7TsLLLSq2BTOnAf3Q7K50fUXV_yl0B1Zme-P2QMacpZ-SJ';
      const title = 'Test Notification';
      const body = 'This is a test notification';

      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"status": "success"}', 200));

      // Act
      final result = await sendNotification(client, token, title, body);

      // Assert
      expect(result, 'success');
    });
  });
}
