import 'package:ecom/core/utils/validators.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty values', () {
      expect(Validators.email(null), 'Email is required');
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email('   '), 'Email is required');
    });

    test('rejects invalid formats', () {
      expect(Validators.email('not-an-email'), 'Enter a valid email address');
      expect(Validators.email('missing@domain'), 'Enter a valid email address');
    });

    test('accepts a valid email', () {
      expect(Validators.email('demo@ecom.app'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty values', () {
      expect(Validators.password(null), 'Password is required');
      expect(Validators.password(''), 'Password is required');
    });

    test('rejects short passwords', () {
      expect(
        Validators.password('short'),
        'Password must be at least ${Validators.minPasswordLength} characters',
      );
    });

    test('accepts a password that meets the demo requirement', () {
      expect(Validators.password(AuthRepository.demoPassword), isNull);
    });
  });
}
