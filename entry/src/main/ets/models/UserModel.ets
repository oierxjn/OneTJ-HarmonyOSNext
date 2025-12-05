import { distributedKVStore } from "@kit.ArkData";
import { kvManager } from "../DisplayUtils/DataUtils";
import { tongjiApi } from "./TongjiApi";

const KVConfig: distributedKVStore.Options = {
  encrypt: true,
  securityLevel: distributedKVStore.SecurityLevel.S3
}

export enum Gender{
  UNKNOWN = 0,
  MALE = 1,
  FEMALE = 2,
  UNTOLD = 9
}

export class TokenData{
  static accessToken: string | null;
  static expireTimeSec: number | null;
  static refreshToken: string | null;
  static refreshTokenExpireSec: number | null;
  static updateTime: number = 0;
  static isFetched: boolean = false;

  static TokenDataKey = 'TokenDataKey'
  static accessTokenKey = 'accessTokenKey'
  static expireTimeSecKey = 'expireTimeSecKey'
  static refreshTokenKey = 'refreshTokenKey'
  static refreshTokenExpireSecKey = 'refreshTokenExpireSecKey'
  static updateTimeKey = 'updateTimeKey'

  static KVStore: distributedKVStore.SingleKVStore | undefined;

  /**
   * 建议用储存函数储存token数据
   * @param accessToken
   * @param expireTimeSec
   * @param refreshToken
   * @param refreshTokenExpireSec
   * @param updateTime
   */
  static storeTokenData(accessToken: string, expireTimeSec: number, refreshToken: string, refreshTokenExpireSec: number, updateTime?: number) {
    TokenData.accessToken = accessToken;
    TokenData.expireTimeSec = expireTimeSec;
    TokenData.refreshToken = refreshToken;
    TokenData.refreshTokenExpireSec = refreshTokenExpireSec;
    TokenData.updateTime = updateTime ?? Date.now()
    TokenData.isFetched = true

    tongjiApi.initAuthorizationHeader()

    console.debug(`调试：储存完成：\n${updateTime}\n${expireTimeSec}\n${TokenData.refreshTokenExpireSec}`)
  }
  static async storeIntoKV(){
    try {
      let accessTokenTask = TokenData.KVStore!!.put(TokenData.accessTokenKey, TokenData.accessToken!!)
      let expireTimeSecTask = TokenData.KVStore!!.put(TokenData.expireTimeSecKey, TokenData.expireTimeSec!!)
      let refreshTokenTask = TokenData.KVStore!!.put(TokenData.refreshTokenKey, TokenData.refreshToken!!)
      let refreshTokenExpireSecTask = TokenData.KVStore!!.put(TokenData.refreshTokenExpireSecKey, TokenData.refreshTokenExpireSec!!)
      let updateTimeTask = TokenData.KVStore!!.put(TokenData.updateTimeKey, TokenData.updateTime!!)

      await Promise.all([accessTokenTask, expireTimeSecTask, refreshTokenTask, refreshTokenExpireSecTask, updateTimeTask])
      console.debug("Token数据库储存完成")
    } catch (e){
      console.error(`Token数据库储存失败：\n${e}`)
    }
  }
  static async loadFromKV(){
    try {
      let accessTokenTask = TokenData.KVStore!!.get(TokenData.accessTokenKey)
      let expireTimeSecTask = TokenData.KVStore!!.get(TokenData.expireTimeSecKey)
      let refreshTokenTask = TokenData.KVStore!!.get(TokenData.refreshTokenKey)
      let refreshTokenExpireSecTask = TokenData.KVStore!!.get(TokenData.refreshTokenExpireSecKey)
      let updateTimeTask = TokenData.KVStore!!.get(TokenData.updateTimeKey)
      let accessToken = await accessTokenTask as string
      let expireTimeSec = await expireTimeSecTask as number
      let refreshToken = await refreshTokenTask as string
      let refreshTokenExpireSec = await refreshTokenExpireSecTask as number
      let updateTime = await updateTimeTask as number
      TokenData.storeTokenData(
        accessToken!!,
        expireTimeSec!!,
        refreshToken!!,
        refreshTokenExpireSec!!,
        updateTime!!
      )
    } catch (e){
      console.error(`加载Token数据库时发生错误：${e}`)
    }
  }
  static async clearFromKV(){
    try {
      let accessTokenTask = TokenData.KVStore!!.delete(TokenData.accessTokenKey)
      let expireTimeSecTask = TokenData.KVStore!!.delete(TokenData.expireTimeSecKey)
      let refreshTokenTask = TokenData.KVStore!!.delete(TokenData.refreshTokenKey)
      let refreshTokenExpireSecTask = TokenData.KVStore!!.delete(TokenData.refreshTokenExpireSecKey)
      let updateTimeTask = TokenData.KVStore!!.delete(TokenData.updateTimeKey)
      await Promise.all([accessTokenTask, expireTimeSecTask, refreshTokenTask, refreshTokenExpireSecTask, updateTimeTask])
    } catch (e){
      console.error(e)
    }
  }
  static async initKV(){
    try {
      TokenData.KVStore = await kvManager!!.getKVStore<distributedKVStore.SingleKVStore>(TokenData.TokenDataKey, KVConfig)
    } catch (e){
      console.error(e)
    }
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
  static gender :number | null = null ;
  static updateTime: number = 0;
  static isFetched: boolean = false;

  static StudentInfoKey = 'StudentInfoKey'
  static studentIdKey = 'studentIdKey'
  static studentNameKey = 'studentNameKey'
  static deptNameKey = 'deptNameKey'
  static secondDeptNameKey = 'secondDeptNameKey'
  static currentGradeKey = 'currentGradeKey'
  static genderKey = 'genderKey'
  static updateTimeKey = 'updateTimeKey'

  static KVStore: distributedKVStore.SingleKVStore | undefined;

  static storeStudentInfo(studentId: string, studentName: string, deptName: string, secondDeptName: string, currentGrade: string, gender: number, updateTime?: number) {
    StudentInfo.studentId = studentId;
    StudentInfo.studentName = studentName;
    StudentInfo.deptName = deptName;
    StudentInfo.secondDeptName = secondDeptName;
    StudentInfo.currentGrade = currentGrade;
    StudentInfo.gender = gender;
    StudentInfo.updateTime = updateTime ?? Date.now()
    StudentInfo.isFetched = true
  }
  static async storeIntoKV(){
    try {
      let studentIdTask = StudentInfo.KVStore!!.put(StudentInfo.studentIdKey, StudentInfo.studentId!!)
      let studentNameTask = StudentInfo.KVStore!!.put(StudentInfo.studentNameKey, StudentInfo.studentName!!)
      let deptNameTask = StudentInfo.KVStore!!.put(StudentInfo.deptNameKey, StudentInfo.deptName!!)
      let secondDeptNameTask = StudentInfo.KVStore!!.put(StudentInfo.secondDeptNameKey, StudentInfo.secondDeptName!!)
      let currentGradeTask = StudentInfo.KVStore!!.put(StudentInfo.currentGradeKey, StudentInfo.currentGrade!!)
      let genderTask = StudentInfo.KVStore!!.put(StudentInfo.genderKey, StudentInfo.gender!!)
      let updateTimeTask = StudentInfo.KVStore!!.put(StudentInfo.updateTimeKey, StudentInfo.updateTime!!)
      await Promise.all([studentIdTask, studentNameTask, deptNameTask, secondDeptNameTask, currentGradeTask, genderTask, updateTimeTask])
    } catch (e){
      console.error(e)
    }
  }
  static async loadFromKV(){
    try {
      let studentIdTask = StudentInfo.KVStore!!.get(StudentInfo.studentIdKey)
      let studentNameTask = StudentInfo.KVStore!!.get(StudentInfo.studentNameKey)
      let deptNameTask = StudentInfo.KVStore!!.get(StudentInfo.deptNameKey)
      let secondDeptNameTask = StudentInfo.KVStore!!.get(StudentInfo.secondDeptNameKey)
      let currentGradeTask = StudentInfo.KVStore!!.get(StudentInfo.currentGradeKey)
      let genderTask = StudentInfo.KVStore!!.get(StudentInfo.genderKey)
      let updateTimeTask = StudentInfo.KVStore!!.get(StudentInfo.updateTimeKey)

      let studentId = await studentIdTask as string
      let studentName = await studentNameTask as string
      let deptName = await deptNameTask as string
      let secondDeptName = await secondDeptNameTask as string
      let currentGrade = await currentGradeTask as string
      let gender = await genderTask as number
      let updateTime = await updateTimeTask as number

      StudentInfo.storeStudentInfo(
        studentId!!,
        studentName!!,
        deptName!!,
        secondDeptName!!,
        currentGrade!!,
        gender!!,
        updateTime!!
      )
    } catch (e){
      console.error(e)
    }
  }
  static async clearFromKV(){
    try {
      let studentIdTask = StudentInfo.KVStore!!.delete(StudentInfo.studentIdKey)
      let studentNameTask = StudentInfo.KVStore!!.delete(StudentInfo.studentNameKey)
      let deptNameTask = StudentInfo.KVStore!!.delete(StudentInfo.deptNameKey)
      let secondDeptNameTask = StudentInfo.KVStore!!.delete(StudentInfo.secondDeptNameKey)
      let currentGradeTask = StudentInfo.KVStore!!.delete(StudentInfo.currentGradeKey)
      let genderTask = StudentInfo.KVStore!!.delete(StudentInfo.genderKey)
      let updateTimeTask = StudentInfo.KVStore!!.delete(StudentInfo.updateTimeKey)

      await Promise.all([studentIdTask, studentNameTask, deptNameTask, secondDeptNameTask, currentGradeTask, genderTask, updateTimeTask])
    } catch (e){
      console.error(e)
    }
  }
  static async initKV(){
    try {
      StudentInfo.KVStore = await kvManager!!.getKVStore<distributedKVStore.SingleKVStore>(StudentInfo.StudentInfoKey, KVConfig)
    } catch (e) {
      console.error(e)
    }
  }
}