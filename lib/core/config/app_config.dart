abstract final class AppConfig {
  static const appName = 'دوائي';

  static const _configuredApiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5030/api/',
  );

  static String get apiBaseUrl {
    final value = _configuredApiUrl.trim();
    return value.endsWith('/') ? value : '$value/';
  }

  static Uri apiUri(String relativePath) {
    final cleanPath = relativePath.startsWith('/')
        ? relativePath.substring(1)
        : relativePath;
    return Uri.parse(apiBaseUrl).resolve(cleanPath);
  }
}
