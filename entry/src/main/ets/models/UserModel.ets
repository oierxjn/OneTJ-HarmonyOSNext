export class TokenData{
  static accessToken: string;
  static expireTimeSec: bigint;
  static refreshToken: String;
  static refreshTokenExpireSec: bigint;
}

export class OAuthCode{
  static code: string | null = null;
  static error: string | null = null;
}

export class StudentInfo{
  static studentId: string | null = null;
  static studentName: string | null = null;
  static deptName : string | null = null;
  static secondDeptName :string | null = null;
  static currentGrade :string | null = null;
  static gender :string | null = null ;
}