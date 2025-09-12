# Testing Guide for Athletica

## Overview

This guide covers the comprehensive testing strategy for the Athletica fitness coaching platform, including unit tests, widget tests, integration tests, and performance tests.

## Testing Structure

```
test/
├── providers_test.dart          # Unit tests for providers
├── services_test.dart           # Unit tests for services
├── models_test.dart             # Unit tests for data models
├── utils_test.dart              # Unit tests for utility functions
├── widget_test.dart             # Widget tests for UI components
└── performance_test.dart        # Performance tests

integration_test/
└── app_test.dart               # End-to-end integration tests
```

## Unit Tests

### Provider Tests (`test/providers_test.dart`)

Tests for state management providers:

- **AuthProvider Tests**:
  - Initial state verification
  - Successful sign-in flow
  - Sign-in failure handling
  - Sign-out functionality
  - Social authentication (Google, Facebook, Apple)

- **CoachProvider Tests**:
  - Initial state verification
  - Client management (add, update, delete)
  - Plan management (add, update, delete)
  - Data loading and error handling

### Service Tests (`test/services_test.dart`)

Tests for API and business logic services:

- **ApiService Tests**:
  - HTTP request handling
  - Error response processing
  - Authentication token management
  - Data serialization/deserialization

- **MockApiService Tests**:
  - Mock data consistency
  - Response timing simulation
  - Error scenario simulation

### Model Tests (`test/models_test.dart`)

Tests for data models:

- **Client Model Tests**:
  - Property validation
  - JSON serialization/deserialization
  - Data integrity checks

- **Plan Model Tests**:
  - Feature validation
  - Status management
  - Duration calculations

- **Coach Model Tests**:
  - Profile validation
  - Subscription tier handling
  - Certificate management

## Widget Tests

### Screen Tests (`test/widget_test.dart`)

Tests for UI screens and components:

- **SignInScreen Tests**:
  - Form element rendering
  - Input validation
  - Navigation flow
  - Error message display

- **HomeScreen Tests**:
  - Dashboard elements
  - Quick action buttons
  - Navigation functionality

- **ClientsScreen Tests**:
  - Client list display
  - Search and filter functionality
  - Add client flow

- **SettingsScreen Tests**:
  - Settings categories
  - Navigation to sub-screens
  - Logout functionality

### Component Tests

Tests for reusable UI components:

- **EmptyStateWidget Tests**:
  - Message display
  - Action button functionality
  - Icon rendering

- **LoadingIndicator Tests**:
  - Loading state display
  - Animation behavior

- **ErrorWidget Tests**:
  - Error message display
  - Retry functionality
  - Error reporting

## Integration Tests

### End-to-End Tests (`integration_test/app_test.dart`)

Complete user flow tests:

- **Authentication Flow**:
  - Sign-in with email/password
  - Social authentication (Google, Facebook)
  - Sign-out process

- **Client Management Flow**:
  - Add new client
  - Edit client information
  - Delete client
  - View client details

- **Plan Management Flow**:
  - Create new plan
  - Edit plan details
  - Delete plan
  - Assign plan to client

- **Settings Flow**:
  - Navigate to settings
  - Update preferences
  - Change notification settings

## Performance Tests

### Performance Monitoring (`test/performance_test.dart`)

Tests for app performance:

- **Memory Usage Tests**:
  - Memory leak detection
  - Garbage collection efficiency
  - Image loading optimization

- **Rendering Performance Tests**:
  - Frame rate monitoring
  - Widget rebuild optimization
  - List scrolling performance

- **Network Performance Tests**:
  - API response time
  - Image loading speed
  - Offline functionality

## Running Tests

### Unit Tests
```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/providers_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests in watch mode
flutter test --watch
```

### Widget Tests
```bash
# Run widget tests
flutter test test/widget_test.dart

# Run widget tests with verbose output
flutter test test/widget_test.dart --verbose
```

### Integration Tests
```bash
# Run integration tests
flutter test integration_test/

# Run integration tests on specific device
flutter test integration_test/ -d <device_id>
```

### Performance Tests
```bash
# Run performance tests
flutter test test/performance_test.dart

# Run performance tests with profiling
flutter test test/performance_test.dart --profile
```

## Test Coverage

### Coverage Goals
- **Unit Tests**: 90%+ coverage for business logic
- **Widget Tests**: 80%+ coverage for UI components
- **Integration Tests**: 100% coverage for critical user flows

### Coverage Reports
```bash
# Generate coverage report
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Data Management

### Mock Data
- Use `MockApiService` for consistent test data
- Create factory methods for test data generation
- Use `Faker` package for realistic test data

### Test Fixtures
- Create reusable test fixtures
- Use `setUp` and `tearDown` for test isolation
- Clean up resources after each test

## Continuous Integration

### GitHub Actions
The CI/CD pipeline includes:

- **Test Execution**: Run all tests on every commit
- **Code Analysis**: Static analysis with `flutter analyze`
- **Code Formatting**: Check code formatting consistency
- **Security Scanning**: Vulnerability and license checks
- **Performance Testing**: Automated performance benchmarks

### Test Reports
- Test results are published as GitHub Actions artifacts
- Coverage reports are uploaded to Codecov
- Performance metrics are tracked over time

## Best Practices

### Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### Test Data
- Use realistic test data
- Avoid hardcoded values
- Create reusable test utilities

### Error Testing
- Test both success and failure scenarios
- Verify error messages and handling
- Test edge cases and boundary conditions

### Performance Testing
- Monitor test execution time
- Use `RepaintBoundary` for performance tests
- Profile memory usage during tests

## Debugging Tests

### Common Issues
- **Widget not found**: Check widget tree structure
- **Timeout errors**: Increase timeout duration
- **State issues**: Ensure proper provider setup
- **Async issues**: Use `pumpAndSettle()` for async operations

### Debugging Tools
- Use `flutter test --verbose` for detailed output
- Add `debugPrint()` statements for debugging
- Use `tester.printToConsole()` for widget tree inspection

## Maintenance

### Regular Updates
- Update test dependencies regularly
- Review and update test data
- Refactor tests when code changes
- Monitor test performance and coverage

### Test Documentation
- Document complex test scenarios
- Maintain test README files
- Update test guides when adding new features
- Share test best practices with team

## Conclusion

This comprehensive testing strategy ensures the Athletica app maintains high quality, reliability, and performance. Regular testing helps catch issues early and provides confidence in code changes.

For questions or issues with testing, refer to the Flutter testing documentation or contact the development team.
