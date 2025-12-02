export class WebUrlConstants {
  public static readonly BASE_URL = "https://api.tongji.edu.cn"
  public static readonly CLIENT_ID = "authorization-xxb-onedottongji-yuchen"
  public static readonly OAUTH_REDIRECT_URL = "onetj://fakeredir.gardilily.com"
  public static readonly OAUTH_AUTHORIZE_ENDPOINT = this.BASE_URL + "/keycloak/realms/OpenPlatform/protocol/openid-connect/auth"
  public static readonly OAUTH_BASE_URL =
    this.OAUTH_AUTHORIZE_ENDPOINT
    + `?redirect_uri=${this.OAUTH_REDIRECT_URL}`
    + `&client_id=${this.CLIENT_ID}`
    + `&response_type=code`
    + `&kc_idp_hint=tjiam`
  public static readonly SCOPE_LIST = [
    "dc_user_student_info",
    "rt_onetongji_cet_score",
    "rt_onetongji_school_calendar_current_term_calendar",
    "rt_onetongji_undergraduate_score",
    "rt_teaching_info_undergraduate_summarized_grades", // 暂未使用
    "rt_onetongji_student_timetable",
    // TODO:     "rt_onetongji_student_exams",
    "rt_teaching_info_sports_test_data",
    "rt_teaching_info_sports_test_health",
    "rt_onetongji_manual_arrange",
    "rt_onetongji_school_calendar_all_term_calendar",
    "rt_onetongji_msg_list",
    "rt_onetongji_msg_detail",
  ]
}