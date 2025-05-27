class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateJournalTitle(String? value) {
    if (value == null || value.isEmpty) return 'Title is required';
    if (value.length > 50) return 'Title too long (max 50 chars)';
    return null;
  }

  static String? validateJournalContent(String? value) {
    if (value == null || value.isEmpty) return 'Content is required';
    if (value.length > 1000) return 'Content too long (max 1000 chars)';
    return null;
  }

  static String? validateMoodNotes(String? value) {
    if (value != null && value.length > 200) {
      return 'Notes too long (max 200 chars)';
    }
    return null;
  }
}
