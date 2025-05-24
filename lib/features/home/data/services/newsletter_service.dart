// lib/features/home/data/services/newsletter_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// 📧 NEWSLETTER SERVICE - DATABASE INTEGRATION 📧
/// Handles email subscriptions, validation, and database operations
class NewsletterService {
  // TODO: Replace with your actual API endpoints
  static const String _baseUrl = 'https://api.shamil.app';
  static const String _subscribeEndpoint = '$_baseUrl/newsletter/subscribe';
  static const String _unsubscribeEndpoint = '$_baseUrl/newsletter/unsubscribe';
  static const String _apiKey = 'your-api-key'; // TODO: Use environment variables

  /// Subscribe user to newsletter
  Future<NewsletterResponse> subscribeToNewsletter(String email) async {
    try {
      // Validate email format
      if (!_isValidEmail(email)) {
        throw NewsletterException('Please enter a valid email address');
      }

      // Prepare request data
      final requestData = {
        'email': email.toLowerCase().trim(),
        'source': 'website_footer',
        'timestamp': DateTime.now().toIso8601String(),
        'ip_address': await _getUserIP(),
        'user_agent': 'Shamil Web App',
        'consent': true,
        'language': 'en', // TODO: Get from app locale
      };

      // Make API call
      final response = await http.post(
        Uri.parse(_subscribeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'X-Source': 'shamil-web',
        },
        body: json.encode(requestData),
      ).timeout(const Duration(seconds: 10));

      // Handle response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NewsletterResponse.fromJson(data);
      } else if (response.statusCode == 409) {
        throw NewsletterException('You\'re already part of our community! 🎉');
      } else {
        throw NewsletterException('Failed to subscribe. Please try again.');
      }

    } on SocketException {
      throw NewsletterException('No internet connection. Please check your network.');
    } on http.ClientException {
      throw NewsletterException('Connection failed. Please try again.');
    } on NewsletterException {
      rethrow;
    } catch (e) {
      throw NewsletterException('Something went wrong. Please try again.');
    }
  }

  /// Unsubscribe user from newsletter
  Future<void> unsubscribeFromNewsletter(String email) async {
    try {
      final response = await http.post(
        Uri.parse(_unsubscribeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'email': email.toLowerCase().trim(),
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw NewsletterException('Failed to unsubscribe');
      }

    } catch (e) {
      throw NewsletterException('Failed to unsubscribe. Please try again.');
    }
  }

  /// Send welcome email (called automatically after subscription)
  Future<void> _sendWelcomeEmail(String email) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/emails/welcome'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'email': email,
          'template': 'welcome',
          'personalization': {
            'user_name': email.split('@')[0], // Simple name extraction
            'welcome_gift': 'SHAMIL20', // 20% discount code
          },
        }),
      );
    } catch (e) {
      // Don't throw error for welcome email failure
      print('Welcome email failed to send: $e');
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Get user IP for analytics (optional)
  Future<String> _getUserIP() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org'),
      ).timeout(const Duration(seconds: 3));
      
      return response.body;
    } catch (e) {
      return 'unknown';
    }
  }
}

/// Newsletter response model
class NewsletterResponse {
  final bool success;
  final String message;
  final String? subscriptionId;
  final DateTime? subscribedAt;
  final Map<String, dynamic>? metadata;

  NewsletterResponse({
    required this.success,
    required this.message,
    this.subscriptionId,
    this.subscribedAt,
    this.metadata,
  });

  factory NewsletterResponse.fromJson(Map<String, dynamic> json) {
    return NewsletterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Subscription successful',
      subscriptionId: json['subscription_id'],
      subscribedAt: json['subscribed_at'] != null 
          ? DateTime.parse(json['subscribed_at'])
          : null,
      metadata: json['metadata'],
    );
  }
}

/// Newsletter exception for error handling
class NewsletterException implements Exception {
  final String message;
  
  NewsletterException(this.message);
  
  @override
  String toString() => message;
}

/// Newsletter analytics service
class NewsletterAnalytics {
  static void trackSubscription(String email, {String source = 'footer'}) {
    // TODO: Implement analytics tracking
    // Examples:
    // - Google Analytics
    // - Firebase Analytics
    // - Mixpanel
    // - Custom analytics
    
    print('Newsletter subscription tracked: $email from $source');
    
    // Example with Firebase Analytics:
    /*
    FirebaseAnalytics.instance.logEvent(
      name: 'newsletter_subscribe',
      parameters: {
        'email_domain': email.split('@').last,
        'source': source,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    */
  }

  static void trackUnsubscription(String email) {
    print('Newsletter unsubscription tracked: $email');
  }
}

// MOCK IMPLEMENTATION FOR DEVELOPMENT
/// Mock newsletter service for testing/development
class MockNewsletterService extends NewsletterService {
  static final Set<String> _subscribedEmails = {};

  @override
  Future<NewsletterResponse> subscribeToNewsletter(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Validate email
    if (!_isValidEmail(email)) {
      throw NewsletterException('Please enter a valid email address');
    }

    // Check if already subscribed
    if (_subscribedEmails.contains(email.toLowerCase())) {
      throw NewsletterException('You\'re already part of our community! 🎉');
    }

    // Simulate subscription
    _subscribedEmails.add(email.toLowerCase());
    
    // Track analytics
    NewsletterAnalytics.trackSubscription(email);

    return NewsletterResponse(
      success: true,
      message: 'Welcome to the Shamil community!',
      subscriptionId: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      subscribedAt: DateTime.now(),
      metadata: {
        'welcome_gift': 'SHAMIL20',
        'subscription_source': 'website_footer',
      },
    );
  }

  @override
  Future<void> unsubscribeFromNewsletter(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    _subscribedEmails.remove(email.toLowerCase());
    NewsletterAnalytics.trackUnsubscription(email);
  }

  /// Helper method to check subscription status (for testing)
  bool isSubscribed(String email) {
    return _subscribedEmails.contains(email.toLowerCase());
  }

  /// Get all subscriptions (for testing)
  Set<String> getAllSubscriptions() {
    return Set.from(_subscribedEmails);
  }

  @override
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Database schema example for backend implementation
/// 
/// CREATE TABLE newsletter_subscriptions (
///   id SERIAL PRIMARY KEY,
///   email VARCHAR(255) UNIQUE NOT NULL,
///   subscription_id VARCHAR(100) UNIQUE NOT NULL,
///   source VARCHAR(50) DEFAULT 'website',
///   ip_address INET,
///   user_agent TEXT,
///   consent BOOLEAN DEFAULT TRUE,
///   language VARCHAR(10) DEFAULT 'en',
///   subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
///   unsubscribed_at TIMESTAMP NULL,
///   is_active BOOLEAN DEFAULT TRUE,
///   metadata JSONB,
///   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
///   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
/// );
/// 
/// CREATE INDEX idx_newsletter_email ON newsletter_subscriptions(email);
/// CREATE INDEX idx_newsletter_active ON newsletter_subscriptions(is_active);
/// CREATE INDEX idx_newsletter_source ON newsletter_subscriptions(source);

/// API endpoint examples for backend implementation:
/// 
/// POST /api/newsletter/subscribe
/// {
///   "email": "user@example.com",
///   "source": "website_footer",
///   "consent": true,
///   "language": "en"
/// }
/// 
/// POST /api/newsletter/unsubscribe
/// {
///   "email": "user@example.com"
/// }
/// 
/// GET /api/newsletter/status/:email
/// Returns subscription status and metadata