import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_profile/models/more_info.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:my_profile/models/user_info.dart';

/// Service responsible for loading and parsing local JSON data
/// Replaces API calls with local file operations for better performance
/// and offline capability
class LocalDataService {
  static const String _dataPath = 'assets/data/raw_data.json';

  // Cache the parsed data to avoid repeated file operations
  Map<String, dynamic>? _cachedData;

  /// Loads and caches the raw JSON data from assets
  Future<Map<String, dynamic>> _loadRawData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_dataPath);
      _cachedData = json.decode(jsonString) as Map<String, dynamic>;
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load local data: $e');
    }
  }

  /// Retrieves user information from local JSON data
  /// Mimics the API getUserInfo() method structure
  Future<UserInfo> getUserInfo() async {
    try {
      final data = await _loadRawData();
      final userInfoData = data['UserInfoModal'] as Map<String, dynamic>;
      return UserInfo.fromJson(userInfoData);
    } catch (e) {
      throw Exception('Failed to parse user info: $e');
    }
  }

  /// Retrieves additional information from local JSON data
  /// Mimics the API getMoreInfo() method structure
  Future<List<MoreInfo>> getMoreInfo() async {
    try {
      final data = await _loadRawData();
      final moreInfoData = data['MoreInfoModel'] as Map<String, dynamic>;

      // Convert single MoreInfoModel to List<MoreInfo> format
      // to maintain compatibility with existing state structure
      final moreInfo = MoreInfo.fromJson(moreInfoData);
      return [moreInfo];
    } catch (e) {
      throw Exception('Failed to parse more info: $e');
    }
  }

  /// Retrieves project information from local JSON data
  /// Mimics the API getProject() method structure
  Future<List<MyProject>> getProject() async {
    try {
      final data = await _loadRawData();
      final projectsData = data['MyProjectModel'] as List<dynamic>;
      return MyProject.listFromJson(projectsData);
    } catch (e) {
      throw Exception('Failed to parse projects: $e');
    }
  }

  /// Clears the cached data - useful for testing or forced refresh
  void clearCache() {
    _cachedData = null;
  }
}