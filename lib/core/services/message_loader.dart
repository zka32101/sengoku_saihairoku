import 'package:flutter/services.dart';
import 'dart:convert';

class MessageLoader {
  static final MessageLoader _instance = MessageLoader._internal();
  late Map<String, dynamic> _messages;
  bool _isInitialized = false;

  factory MessageLoader() {
    return _instance;
  }

  MessageLoader._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/messages.json');
      _messages = jsonDecode(jsonString) as Map<String, dynamic>;
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  String? getMessage(String scenarioId, String messageId) {
    if (!_isInitialized) {
      throw Exception('MessageLoader not initialized. Call initialize() first.');
    }

    try {
      final scenarioMessages =
          _messages[scenarioId] as Map<String, dynamic>?;
      if (scenarioMessages == null) return null;

      return scenarioMessages[messageId] as String?;
    } catch (e) {
      return null;
    }
  }

  List<String> getScenarioMessages(String scenarioId) {
    if (!_isInitialized) {
      throw Exception('MessageLoader not initialized. Call initialize() first.');
    }

    try {
      final scenarioMessages =
          _messages[scenarioId] as Map<String, dynamic>?;
      if (scenarioMessages == null) return [];

      return scenarioMessages.values.whereType<String>().toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> getAllMessages() {
    if (!_isInitialized) {
      throw Exception('MessageLoader not initialized. Call initialize() first.');
    }

    return _messages;
  }

  Future<void> reload() async {
    _isInitialized = false;
    await initialize();
  }
}
