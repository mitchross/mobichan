mixin class Model<T> { // Changed from 'abstract class' to 'mixin class'
  // Static methods in mixin classes are not directly mixed in,
  // but can be called on the mixin class itself if needed.
  // For the purpose of being used as a mixin, this change allows it.
  // The original static fromJson might indicate a helper method, not something for the instance.
  static dynamic fromJson(Map<String, dynamic> json) {}
}
