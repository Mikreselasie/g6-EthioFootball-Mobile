class Config {
  // API Configuration
  static String get apiBaseUrl => _getApiBaseUrl();
  
  // Redis configuration - exactly as provided
  static const String redisAddress = "redis-11889.c257.us-east-1-3.ec2.redns.redis-cloud.com:11889";
  static const String redisUsername = "default";
  static const String redisPassword = "Zpiq2MStllUjbzCDgwMvvsrKcn37m9l1";
  
  // Environment-based API URL selection
  static String _getApiBaseUrl() {
    // Uncomment the line for your environment:
    
    // For local development:
    return 'http://localhost:3000';
    
    // For production (replace with your actual API URL):
    // return 'https://your-production-api.com';
    
    // For staging (replace with your staging API URL):
    // return 'https://your-staging-api.com';
  }
}
