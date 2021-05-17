class LoginData {
  UserContext mUserContext;
  String accessToken, refreshToken;
  int accessTokenExpiry, refreshTokenExpiry;
  int uid, companyId;

  LoginData(
      {this.mUserContext,
      this.accessToken,
      this.refreshToken,
      this.accessTokenExpiry,
      this.refreshTokenExpiry,
      this.uid,
      this.companyId});

  factory LoginData.fromJson(data) {
    return LoginData(
      accessToken: data['access_token'],
      accessTokenExpiry: data['expires_in'],
      uid: data['uid'],
      companyId: data['company_id'],
      mUserContext: UserContext.fromJson(data['user_context']),
      refreshToken: data['refresh_token'],
      refreshTokenExpiry: data['refresh_expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mUserContext != null) {
      data['user_context'] = this.mUserContext.toJson();
    }
    data['refresh_token'] = this.refreshToken;
    data['refresh_expires_in'] = this.refreshTokenExpiry;
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.accessTokenExpiry;
    data['uid'] = this.uid;
    data['company_id'] = this.companyId;
    return data;
  }
}

class UserContext {
  String lang;
  String timezone;
  int uid;

  UserContext({this.lang, this.timezone, this.uid});

  factory UserContext.fromJson(Map<String, dynamic> data) {
    return UserContext(
      lang: data['lang'],
      timezone: data['tz'],
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lang'] = this.lang;
    data['tz'] = this.timezone;
    data['uid'] = this.uid;
    return data;
  }
}
