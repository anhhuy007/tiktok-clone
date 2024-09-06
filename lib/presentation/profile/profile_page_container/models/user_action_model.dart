class UserAction {
  bool followed;

  UserAction({required this.followed});
  UserAction copyWith({required bool follow}) {
    return UserAction(followed: this.followed);
  }
}
