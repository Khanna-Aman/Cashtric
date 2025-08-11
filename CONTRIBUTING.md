# Contributing to Cashtric

Thank you for your interest in contributing to Cashtric! We welcome contributions from the community and are excited to see what you'll bring to the project.

## 🤝 How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with the following information:

1. **Bug Description**: Clear description of the issue
2. **Steps to Reproduce**: Detailed steps to reproduce the bug
3. **Expected Behavior**: What you expected to happen
4. **Actual Behavior**: What actually happened
5. **Screenshots**: If applicable, add screenshots
6. **Environment**: 
   - Device model and OS version
   - App version
   - Flutter version

### Suggesting Features

We love feature suggestions! Please create an issue with:

1. **Feature Description**: Clear description of the proposed feature
2. **Use Case**: Why this feature would be useful
3. **Implementation Ideas**: Any thoughts on how it could be implemented
4. **Mockups/Wireframes**: If applicable, visual representations

### Code Contributions

#### Getting Started

1. **Fork the Repository**
   ```bash
   git clone https://github.com/Khanna-Aman/Cashtric.git
   cd Cashtric
   ```

2. **Set Up Development Environment**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Development Guidelines

##### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

##### File Organization
```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── services/        # Business logic
├── utils/           # Utility functions
└── constants/       # App constants
```

##### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

#### Testing

- Write unit tests for new services and utilities
- Write widget tests for new UI components
- Ensure all tests pass before submitting PR

```bash
flutter test
```

#### Documentation

- Update README.md if adding new features
- Add inline documentation for public APIs
- Update CHANGELOG.md with your changes

### Pull Request Process

1. **Ensure Quality**
   - All tests pass
   - Code follows style guidelines
   - No breaking changes (unless discussed)

2. **Create Pull Request**
   - Use descriptive title
   - Reference related issues
   - Provide detailed description of changes
   - Include screenshots for UI changes

3. **Review Process**
   - Maintainers will review your PR
   - Address any feedback
   - Once approved, your PR will be merged

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Git

### Local Development

1. **Clone and Setup**
   ```bash
   git clone https://github.com/Khanna-Aman/Cashtric.git
   cd Cashtric
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Run Tests**
   ```bash
   flutter test
   ```

4. **Code Analysis**
   ```bash
   flutter analyze
   ```

### Project Structure

```
Cashtric/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   ├── screens/               # UI screens
│   ├── services/              # Business logic
│   ├── utils/                 # Utilities
│   └── constants/             # Constants
├── test/                      # Test files
├── assets/                    # App assets
├── android/                   # Android configuration
├── ios/                       # iOS configuration
└── docs/                      # Documentation
```

## 📋 Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `question`: Further information is requested

## 🎯 Priority Areas

We're particularly interested in contributions in these areas:

1. **Performance Optimization**: Making the app faster and more efficient
2. **UI/UX Improvements**: Enhancing user experience
3. **Testing**: Increasing test coverage
4. **Documentation**: Improving docs and examples
5. **Accessibility**: Making the app more accessible
6. **Internationalization**: Adding multi-language support

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Email**: For private inquiries

## 🙏 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Special thanks in major releases

Thank you for contributing to Cashtric! 🎉
