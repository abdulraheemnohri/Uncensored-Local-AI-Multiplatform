import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:get/get.dart';

class WebSearchService extends GetxService {
  final String _searchEngine = 'https://www.google.com/search?q=';
  final String _apiEndpoint = 'https://api.bravesoftware.com/api/v1/search';
  
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String get errorMessage => _errorMessage;

  Future<void> searchWeb(String query) async {
    if (query.isEmpty) return;
    
    _isSearching = true;
    _errorMessage = '';
    update();
    
    try {
      // For now, we'll use a simple web search
      // In future, we can integrate with Brave API or other search providers
      final url = _searchEngine + Uri.encodeComponent(query);
      
      // Create a simple result structure
      _searchResults = [
        {
          'title': 'Web Search: ' + query,
          'url': url,
          'snippet': 'Open in browser to view results',
          'isWebResult': true
        }
      ];
      
      update();
    } catch (e) {
      _errorMessage = 'Failed to search: ' + e.toString();
      _searchResults = [];
      update();
    } finally {
      _isSearching = false;
      update();
    }
  }

  Future<void> openInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      _errorMessage = 'Could not open URL: ' + url;
      update();
    }
  }

  Future<void> searchWithAI(String query, String aiResponse) async {
    // This method combines web search with AI processing
    // The AI can analyze search results and provide summaries
    _isSearching = true;
    update();
    
    try {
      // Simulate AI processing of search results
      await Future.delayed(const Duration(milliseconds: 500));
      
      _searchResults = [
        {
          'title': 'AI Analysis: ' + query,
          'content': aiResponse,
          'url': _searchEngine + Uri.encodeComponent(query),
          'isAIResult': true
        }
      ];
      
      update();
    } catch (e) {
      _errorMessage = 'Failed to process with AI: ' + e.toString();
      _searchResults = [];
      update();
    } finally {
      _isSearching = false;
      update();
    }
  }

  void clearResults() {
    _searchResults = [];
    _errorMessage = '';
    update();
  }

  @override
  void onClose() {
    clearResults();
    super.onClose();
  }
}