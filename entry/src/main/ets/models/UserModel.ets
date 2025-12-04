
export class TokenData{
  static accessToken: string | null;
  static expireTimeSec: number | null;
  static refreshToken: String | null;
  static refreshTokenExpireSec: number | null;
  static isFetched: boolean = false;
  constructor(accessToken: string, expireTimeSec: number, refreshToken: string, refreshTokenExpireSec: number) {
    TokenData.accessToken = accessToken;
    TokenData.expireTimeSec = expireTimeSec;
    TokenData.refreshToken = refreshToken;
    TokenData.refreshTokenExpireSec = refreshTokenExpireSec;
  }
  static loadFromKV(){
    // TODO
  }
  static clearFromKV(){
    // TODO
  }
}

export class OAuthCode{
  static code: string | null = null;
  static error: string | null = null;
  static isFetched: boolean = false;
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