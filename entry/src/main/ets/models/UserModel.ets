export class TokenData{
  static accessToken: string | null;
  static expireTimeSec: bigint | null;
  static refreshToken: String | null;
  static refreshTokenExpireSec: bigint | null;
  constructor(accessToken: string, expireTimeSec: bigint, refreshToken: string, refreshTokenExpireSec: bigint) {
    TokenData.accessToken = accessToken;
    TokenData.expireTimeSec = expireTimeSec;
    TokenData.refreshToken = refreshToken;
    TokenData.refreshTokenExpireSec = refreshTokenExpireSec;
  }
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
  constructor(studentId: string, studentName: string, deptName: string, secondDeptName: string, currentGrade: string, gender: string) {
    StudentInfo.studentId = studentId;
    StudentInfo.studentName = studentName;
    StudentInfo.deptName = deptName;
    StudentInfo.secondDeptName = secondDeptName;
    StudentInfo.currentGrade = currentGrade;
    StudentInfo.gender = gender;
  }
}