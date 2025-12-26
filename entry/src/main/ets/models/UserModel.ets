import { distributedKVStore } from "@kit.ArkData";
import { CommonMsgData, kvManager } from "../DisplayUtils/DataUtils";
import { tongjiApi } from "./TongjiApi";
import { JSON } from "@kit.ArkTS";

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

export class SchoolCalendarInfo {
  static calendarId: string | null
  static year: string | null
  static term: string | null
  static schoolWeek: number | undefined
  static simpleName: string | null
  static updateTime: number = 0
  static isFetched: boolean = false

  static schoolCalendarInfoKey = 'schoolCalendarInfoKey'
  static calendarIdKey = 'calendarIdKey'
  static yearKey = 'yearKey'
  static termKey = 'termKey'
  static schoolWeekKey = 'schoolWeekKey'
  static simpleNameKey = 'simpleNameKey'
  static updateTimeKey = 'updateTimeKey'

  static KVStore: distributedKVStore.SingleKVStore | undefined;

  static storeSchoolCalendarInfo(calendarId: string, year: string, term: string, schoolWeek: number, simpleName: string, updateTime?: number){
    SchoolCalendarInfo.calendarId = calendarId
    SchoolCalendarInfo.year = year
    SchoolCalendarInfo.term = term
    SchoolCalendarInfo.schoolWeek = schoolWeek
    SchoolCalendarInfo.simpleName = simpleName
    SchoolCalendarInfo.updateTime = updateTime ?? Date.now()
    SchoolCalendarInfo.isFetched = true
  }

  static async storeIntoKV(){
    try {
      let calendarIdTask = SchoolCalendarInfo.KVStore!!.put(SchoolCalendarInfo.calendarIdKey, SchoolCalendarInfo.calendarId!!)
      let yearTask = SchoolCalendarInfo.KVStore!!.put(SchoolCalendarInfo.yearKey, SchoolCalendarInfo.year!!)
      let termTask = SchoolCalendarInfo.KVStore!!.put(SchoolCalendarInfo.termKey, SchoolCalendarInfo.term!!)
      let schoolWeekTask = SchoolCalendarInfo.KVStore!!.put(SchoolCalendarInfo.schoolWeekKey, SchoolCalendarInfo.schoolWeek!!)
      let simpleNameTask = SchoolCalendarInfo.KVStore!!.put(SchoolCalendarInfo.simpleNameKey, SchoolCalendarInfo.simpleName!!)
      let updateTimeTask = SchoolCalendarInfo.KVStore!!.put(SchoolCalendarInfo.updateTimeKey, SchoolCalendarInfo.updateTime)

      await Promise.all([calendarIdTask, yearTask, termTask, schoolWeekTask, simpleNameTask, updateTimeTask])
    } catch (e){
      console.error(`储存 SchoolCalendar 时发生错误`)
    }
  }
  static async loadFromKV(){
    try {
      let calendarIdTask = SchoolCalendarInfo.KVStore!!.get(SchoolCalendarInfo.calendarIdKey)
      let yearTask = SchoolCalendarInfo.KVStore!!.get(SchoolCalendarInfo.yearKey)
      let termTask = SchoolCalendarInfo.KVStore!!.get(SchoolCalendarInfo.termKey)
      let schoolWeekTask = SchoolCalendarInfo.KVStore!!.get(SchoolCalendarInfo.schoolWeekKey)
      let simpleNameTask = SchoolCalendarInfo.KVStore!!.get(SchoolCalendarInfo.simpleNameKey)
      let updateTimeTask = SchoolCalendarInfo.KVStore!!.get(SchoolCalendarInfo.updateTimeKey)
      let calendarId = await calendarIdTask as string
      let year = await yearTask as string
      let term = await termTask as string
      let schoolWeek = await schoolWeekTask as number
      let simpleName = await simpleNameTask as string
      let updateTime = await updateTimeTask as number
      SchoolCalendarInfo.storeSchoolCalendarInfo(
        calendarId!!,
        year!!,
        term!!,
        schoolWeek!!,
        simpleName!!,
        updateTime!!
      )
    } catch (e){
      console.error(`加载 SchollCalendar 数据库时发生错误：${e}`)
    }
  }
  static async clearFromKV(){
    try {
      let calendarIdTask = SchoolCalendarInfo.KVStore!!.delete(SchoolCalendarInfo.calendarIdKey)
      let yearTask = SchoolCalendarInfo.KVStore!!.delete(SchoolCalendarInfo.yearKey)
      let termTask = SchoolCalendarInfo.KVStore!!.delete(SchoolCalendarInfo.termKey)
      let schoolWeekTask = SchoolCalendarInfo.KVStore!!.delete(SchoolCalendarInfo.schoolWeekKey)
      let simpleNameTask = SchoolCalendarInfo.KVStore!!.delete(SchoolCalendarInfo.simpleNameKey)
      let updateTimeTask = SchoolCalendarInfo.KVStore!!.delete(SchoolCalendarInfo.updateTimeKey)

      await Promise.all([calendarIdTask, yearTask, termTask, schoolWeekTask, simpleNameTask, updateTimeTask])
    } catch (e){
      console.error(`清除 SchollCalendar 数据库时发生错误：${e}`)
    }
  }
  static async initKV(){
    try {
      SchoolCalendarInfo.KVStore = await kvManager!!.getKVStore<distributedKVStore.SingleKVStore>(SchoolCalendarInfo.schoolCalendarInfoKey, KVConfig)
    } catch (e) {
      console.error(`初始化 SchollCalendar 数据库时发生错误：${e}`)
    }
  }
}

export class CourseInfo{
  courseName: string;
  timeStart: number;
  timeEnd: number;
  teacher: string;
  room: string;
  dayOfWeek: number;
  weeks: Array<number>;
  constructor(
    courseName: string = '',
    timeStart: number = 1,
    timeEnd: number = 1,
    teacher: string = '',
    room: string ='',
    dayOfWeek: number,
    weeks: Array<number>
  ){
    this.courseName = courseName
    this.timeStart = timeStart
    this.timeEnd = timeEnd
    this.teacher = teacher
    this.room = room
    this.dayOfWeek = dayOfWeek
    this.weeks = weeks
  }
}

export class CourseInfoList{
  static courseInfoArray: CourseInfo[] = new Array<CourseInfo>();
  static updateTime: number = 0;
  static isFetched: boolean = false;

  static courseInfoKey: string = 'courseInfoKey';
  static courseInfoArrayKey: string = 'courseInfoArrayKey';
  static updateTimeKey: string = 'updateTimeKey';

  static KVStore: distributedKVStore.SingleKVStore | undefined;

  static processCourseInfoData(courseInfoData: Object[]){
    let infoList = new Array<CourseInfo>();
    for(let course of courseInfoData) {
      try {
        let timeTableList: Array<Object> = (course as object)?.['timeTableList'];
        for(let item of timeTableList){
          let courseName: string = (item as object)?.['courseName']
          let timeStart: number = (item as object)?.['timeStart']
          let timeEnd: number = (item as object)?.['timeEnd']
          let teacher: string = (item as object)?.['teacherName']
          let room: string = (item as object)?.['roomIdI18n'] ?? (item as object)?.['roomLable']
          let dayOfWeek: number = (item as object)?.['dayOfWeek']
          let weeks: Array<number> = (item as object)?.['weeks']

          let courseObj = new CourseInfo(
            courseName!!,
            timeStart!!,
            timeEnd!!,
            teacher!!,
            room!!,
            dayOfWeek!!,
            weeks!!
          )
          infoList.push(courseObj)
        }
      } catch (e){
        console.error(`解析课程表时发生错误：${JSON.stringify(e)}\n本条解析忽略`)
      }
    }
    CourseInfoList.storeCourseInfoList(infoList)
  }

  static getWeekCourseInfo(week: number, courseInfoArray: CourseInfo[] = CourseInfoList.courseInfoArray): CourseInfo[]{
    if(!CourseInfoList.isFetched)throw new Error('CourseInfoList 未初始化')
    let infoList: CourseInfo[] = new Array<CourseInfo>();
    for(let course of courseInfoArray){
      if(course.weeks.includes(week))
        infoList.push(course)
    }
    return infoList
  }

  static getDayOfWeekCourseInfo(dayOfWeek: number, courseInfoArray: CourseInfo[]): CourseInfo[]{
    if(!CourseInfoList.isFetched)throw new Error('CourseInfoList 未初始化')
    let infoList: CourseInfo[] = new Array<CourseInfo>();
    for(let course of courseInfoArray){
      if(course.dayOfWeek == dayOfWeek)
        infoList.push(course)
    }
    return infoList
  }

  static storeCourseInfoList(courseInfoArray: CourseInfo[], updateTime?: number){
    CourseInfoList.courseInfoArray = courseInfoArray
    CourseInfoList.updateTime = updateTime ?? Date.now()
    CourseInfoList.isFetched = true
  }

  static async storeIntoKV(){
    try {
      let courseInfoArrayTask = CourseInfoList.KVStore!!.put(CourseInfoList.courseInfoArrayKey, JSON.stringify(CourseInfoList.courseInfoArray))
      let updateTimeTask = CourseInfoList.KVStore!!.put(CourseInfoList.updateTimeKey, CourseInfoList.updateTime)

      await Promise.all([courseInfoArrayTask, updateTimeTask])
    } catch (e){
      console.error(`存储课程表时发生错误：${e}`)

    }
  }
  static async loadFromKV(){
    try {
      let courseInfoArrayTask = CourseInfoList.KVStore!!.get(CourseInfoList.courseInfoArrayKey)
      let updateTimeTask = CourseInfoList.KVStore!!.get(CourseInfoList.updateTimeKey)

      let courseInfoArrayString = await courseInfoArrayTask as string
      let updateTime = await updateTimeTask as number

      let courseInfoArray = JSON.parse(courseInfoArrayString) as Array<CourseInfo>
      CourseInfoList.storeCourseInfoList(
        courseInfoArray!!,
        updateTime!!
      )
    } catch (e){
      console.error(`加载课程表数据库时发生错误：${e}`)
    }
  }
  static async clearFromKV(){
    try {
      let courseInfoArrayTask = CourseInfoList.KVStore!!.delete(CourseInfoList.courseInfoArrayKey)
      let updateTimeTask = CourseInfoList.KVStore!!.delete(CourseInfoList.updateTimeKey)

      await Promise.all([courseInfoArrayTask, updateTimeTask])
    } catch (e){
      console.error(`清除 CourseInfo 数据库时发生错误：${e}`)
    }
  }
  static async initKV() {
    try {
      CourseInfoList.KVStore = await kvManager!!.getKVStore<distributedKVStore.SingleKVStore>(CourseInfoList.courseInfoKey, KVConfig)
    } catch (e) {
      console.error(`初始化 CourseInfo 数据库时发生错误：${e}`)
    }
  }
}

export class MsgList{
  static msgArray: CommonMsgData[] = new Array<CommonMsgData>();
  static updateTime: number = 0;
  static isFetched: boolean = false;
}