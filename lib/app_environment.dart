enum Environment { dev, staging, prod }

class AppEnvironment {
  // Override at build or run time via --dart-define=ENVIRONMENT=prod.
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static Environment get currentEnvironment {
    switch (environment.toLowerCase()) {
      case 'prod':
        return Environment.prod;
      case 'staging':
        return Environment.staging;
      case 'dev':
        return Environment.dev;
      default:
        return Environment.dev;
    }
  }

  static String get baseApiUrl {
    switch (currentEnvironment) {
      case Environment.prod:
        return 'https://api.yourdomain.com';
      case Environment.staging:
        return 'https://staging-api.yourdomain.com';
      case Environment.dev:
        return 'https://dev-api.yourdomain.com';
    }
  }

  static bool get isDev => currentEnvironment == Environment.dev;
  static bool get isStaging => currentEnvironment == Environment.staging;
  static bool get isProd => currentEnvironment == Environment.prod;
}
