class BrowserSession {
  String? usrKey;
  String? userName;
  String? userPwd;
  DateTime? logTime;
  bool? remember;
  String? currentCmd;
  bool? cmdClosed;

  BrowserSession(
      {this.usrKey,
      this.userName,
      this.userPwd,
      this.logTime,
      this.remember,
      this.currentCmd,cmdClosed});
}
