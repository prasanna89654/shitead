# Contributing to Shitead

Thank you for considering contributing to Shitead! We welcome contributions from everyone, whether you're a beginner or an experienced developer.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/shitead.git
   cd shitead
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Git

### Installation

```bash
# Get dependencies
flutter pub get

# Run tests to ensure everything works
flutter test

# Run the example app
cd example
flutter run
```

## 📝 Making Changes

### Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format your code
- Ensure your code passes `flutter analyze`

### Testing

- Add tests for any new functionality
- Ensure all existing tests pass
- Aim for good test coverage

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Documentation

- Update documentation for any API changes
- Add inline documentation for new public methods
- Update the README.md if needed

## 🔄 Pull Request Process

1. **Ensure your code follows our standards**:

   ```bash
   flutter format .
   flutter analyze
   flutter test
   ```

2. **Update documentation** if you've made API changes

3. **Create a descriptive pull request**:

   - Use a clear and descriptive title
   - Reference any related issues
   - Describe what your changes do and why

4. **Wait for review** - a maintainer will review your PR

## 📋 Types of Contributions

### 🐛 Bug Reports

When filing a bug report, please include:

- Flutter and Dart versions
- Device/platform information
- Steps to reproduce
- Expected vs. actual behavior
- Code samples if possible

### ✨ Feature Requests

For feature requests, please:

- Describe the feature and its use case
- Explain why it would be valuable
- Consider backward compatibility
- Provide examples if possible

### 🔧 Code Contributions

We welcome:

- Bug fixes
- New features
- Performance improvements
- Documentation improvements
- Test improvements

## 🏗️ Project Structure

```
lib/
├── shitead.dart              # Main export file
└── src/
    ├── seat_layout.dart      # Main widget
    ├── models/
    │   ├── seat.dart         # Seat model
    │   └── seat_status.dart  # Seat status enum
    └── widgets/
        ├── seat_widget.dart  # Individual seat widget
        └── seat_info_modal.dart # Seat info modal

test/                         # Test files
example/                      # Example application
assets/                       # Package assets
```

## 🧪 Testing Guidelines

### Test Types

1. **Unit Tests** - Test individual functions and classes
2. **Widget Tests** - Test widget rendering and interaction
3. **Integration Tests** - Test complete user flows

### Test Structure

```dart
void main() {
  group('SeatLayout', () {
    testWidgets('should display correct number of seats', (tester) async {
      // Test implementation
    });

    testWidgets('should handle seat selection', (tester) async {
      // Test implementation
    });
  });
}
```

## 📚 Documentation Standards

### Inline Documentation

````dart
/// Creates a seat layout widget with the specified configuration.
///
/// The [numberOfSeats] parameter is required and specifies the total
/// number of passenger seats to display.
///
/// Example:
/// ```dart
/// SeatLayout(
///   numberOfSeats: 20,
///   seatsPerRow: 4,
/// )
/// ```
class SeatLayout extends StatefulWidget {
  /// Number of passenger seats to display
  final int numberOfSeats;

  // ...
}
````

### README Updates

- Keep examples up to date
- Document breaking changes
- Update API reference tables

## 🚦 Release Process

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create a git tag
4. Publish to pub.dev (maintainers only)

## 🤔 Questions?

If you have questions about contributing:

- Open an issue for discussion
- Check existing issues and PRs
- Read through the codebase

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be:

- Listed in release notes
- Mentioned in the README
- Given credit in commit messages

Thank you for helping make Shitead better! 🎉
