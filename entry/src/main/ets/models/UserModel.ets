import { distributedKVStore } from "@kit.ArkData";
import { kvManager } from "../DisplayUtils/DataUtils";

const KVConfig: distributedKVStore.Options = {
  encrypt: true,
  securityLevel: distributedKVStore.SecurityLevel.S3
}

export class TokenData{
  static accessToken: string | null;
  static expireTimeSec: number | null;
  static refreshToken: string | null;
  static refreshTokenExpireSec: number | null;
  static isFetched: boolean = false;
  static updateTime: number = 0;

  static TokenDataKey = 'TokenDataKey'
  static accessTokenKey = 'accessTokenKey'
  static expireTimeSecKey = 'expireTimeSecKey'
  static refreshTokenKey = 'refreshTokenKey'
  static refreshTokenExpireSecKey = 'refreshTokenExpireSecKey'
  static updateTimeKey = 'updateTimeKey'

  static KVStore: distributedKVStore.SingleKVStore | undefined;

  static async storeTokenData(accessToken: string, expireTimeSec: number, refreshToken: string, refreshTokenExpireSec: number) {
    TokenData.accessToken = accessToken;
    TokenData.expireTimeSec = expireTimeSec;
    TokenData.refreshToken = refreshToken;
    TokenData.refreshTokenExpireSec = refreshTokenExpireSec;
    TokenData.updateTime = Date.now()
  }
  static async loadIntoKV(){
    try {
      let accessTokenTask = TokenData.KVStore!!.put(TokenData.accessTokenKey, TokenData.accessToken!!)
      let expireTimeSecTask = TokenData.KVStore!!.put(TokenData.expireTimeSecKey, TokenData.expireTimeSec!!)
      let refreshTokenTask = TokenData.KVStore!!.put(TokenData.refreshTokenKey, TokenData.refreshToken!!)
      let refreshTokenExpireSecTask = TokenData.KVStore!!.put(TokenData.refreshTokenExpireSecKey, TokenData.refreshTokenExpireSec!!)
      let updateTimeTask = TokenData.KVStore!!.put(TokenData.updateTimeKey, TokenData.updateTime!!)
      await Promise.all([accessTokenTask, expireTimeSecTask, refreshTokenTask, refreshTokenExpireSecTask, updateTimeTask])
    } catch (e){
      console.error(e)
    }
  }
  static async loadFromKV(){
    try {
      let accessTokenTask = TokenData.KVStore!!.get(TokenData.accessTokenKey)
      let expireTimeSecTask = TokenData.KVStore!!.get(TokenData.expireTimeSecKey)
      let refreshTokenTask = TokenData.KVStore!!.get(TokenData.refreshTokenKey)
      let refreshTokenExpireSecTask = TokenData.KVStore!!.get(TokenData.refreshTokenExpireSecKey)
      let accessToken = await accessTokenTask as string
      let expireTimeSec = await expireTimeSecTask as number
      let refreshToken = await refreshTokenTask as string
      let refreshTokenExpireSec = await refreshTokenExpireSecTask as number
      TokenData.storeTokenData(accessToken!!, expireTimeSec!!, refreshToken!!, refreshTokenExpireSec!!)
    } catch (e){
      console.error(e)
    }
  }
  static async clearFromKV(){
    try {
      let accessTokenTask = TokenData.KVStore!!.delete(TokenData.accessTokenKey)
      let expireTimeSecTask = TokenData.KVStore!!.delete(TokenData.expireTimeSecKey)
      let refreshTokenTask = TokenData.KVStore!!.delete(TokenData.refreshTokenKey)
      let refreshTokenExpireSecTask = TokenData.KVStore!!.delete(TokenData.refreshTokenExpireSecKey)
      await Promise.all([accessTokenTask, expireTimeSecTask, refreshTokenTask, refreshTokenExpireSecTask])
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
  static gender :string | null = null ;
  static updateTime: number = 0;

  static storeStudentInfo(studentId: string, studentName: string, deptName: string, secondDeptName: string, currentGrade: string, gender: string) {
    StudentInfo.studentId = studentId;
    StudentInfo.studentName = studentName;
    StudentInfo.deptName = deptName;
    StudentInfo.secondDeptName = secondDeptName;
    StudentInfo.currentGrade = currentGrade;
    StudentInfo.gender = gender;
    StudentInfo.updateTime = Date.now()
  }
}