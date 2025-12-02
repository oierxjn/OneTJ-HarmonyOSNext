export class TokenData{
  accessToken: string;
  expireTimeSec: bigint;
  refreshToken: String;
  refreshTokenExpireSec: bigint;
  constructor(accessToken: string, expireTimeSec: bigint, refreshToken: String, refreshTokenExpireSec: bigint) {
    this.accessToken = accessToken;
    this.expireTimeSec = expireTimeSec;
    this.refreshToken = refreshToken;
    this.refreshTokenExpireSec = refreshTokenExpireSec;
  }
}