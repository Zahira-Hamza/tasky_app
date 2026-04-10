import 'package:hive/hive.dart';

class UserRepository {
  static const String _boxName = 'settingsBox';
  static const String _nameKey = 'userName';
  static const String _quoteKey = 'userQuote';
  static const String _profileImageKey = 'profileImagePath';
  static const String _isOnboardedKey = 'isOnboarded';

  Future<Box> get _box async => Hive.openBox(_boxName);

  Future<String> getUserName() async {
    final box = await _box;
    return box.get(_nameKey, defaultValue: '') as String;
  }

  Future<void> saveUserName(String name) async {
    final box = await _box;
    await box.put(_nameKey, name);
  }

  Future<String> getMotivationQuote() async {
    final box = await _box;
    return box.get(_quoteKey, defaultValue: 'One task at a time. One step closer.') as String;
  }

  Future<void> saveMotivationQuote(String quote) async {
    final box = await _box;
    await box.put(_quoteKey, quote);
  }

  Future<String?> getProfileImagePath() async {
    final box = await _box;
    return box.get(_profileImageKey) as String?;
  }

  Future<void> saveProfileImagePath(String path) async {
    final box = await _box;
    await box.put(_profileImageKey, path);
  }

  Future<bool> isOnboarded() async {
    final box = await _box;
    return box.get(_isOnboardedKey, defaultValue: false) as bool;
  }

  Future<void> setOnboarded(bool value) async {
    final box = await _box;
    await box.put(_isOnboardedKey, value);
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
