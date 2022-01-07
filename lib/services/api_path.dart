class APIPath {
  final String adminUid = "3M4eRPvs8QcMEgURx2by5LbrZFY2";
  // -------- User ---------------------------------------------------
  static String user(String uid) => 'user/$uid/';
  static String Users(String uid) => 'user/';
  //--
  static String userClass(String uid, String userClassId) =>
      'user/$uid/userClass/$userClassId';
  static String UsersClass(String uid) => 'user/$uid/userClass';

  //---
  static String usersSubcribedBatch(String uid) =>
      'user/$uid/userSubcribedBatch/';

  static String userSubcribedBatch(
    String uid,
    String userSubcribedBatchId,
  ) =>
      'user/$uid/userSubcribedBatch/$userSubcribedBatchId';
  //---

  static String userSubcribedClass(String uid, String userSubcribedBatchId,
          String userSubcribedCourseId) =>
      'user/$uid/userSubcribedBatch/$userSubcribedBatchId/course/$userSubcribedCourseId';

  static String usersSubcribedClass(String uid, String userSubcribedBatchId) =>
      'user/$uid/userSubcribedBatch/$userSubcribedBatchId/course';

  // --------------  payment History -----------
  static String paymentsHistory(String uid) => 'user/$uid/payment_history/';

  static String paymentHistory(
    String uid,
    String paymentHistoryId,
  ) =>
      'user/$uid/payment_history/$paymentHistoryId';

  // -------------------------------------------------------------------
  // ----------------- Device Detailed -----------------------
  static String userDeviceData(String mobileNo) =>
      'user_device_detail/$mobileNo/';
  static String usersDeviceData() => 'user_device_detail/';
  // -----------------------------------------------------------
  //-----------------------  User Status ------------------------
  static String userStatus(String userId) => 'user_status/$userId/';
  static String usersStatus() => 'user_status/';
  // -------------------------------------------------------------
  // ------------------ Slidder Image ----------------
  static String slidder(String adminId) => 'slidder/$adminId/';
  static String slidders() => 'slidder/';
  //---------------------------------------------------
  // -------------------------- TEAM Path-------------------------------
  static String team(String uid) => 'team/$uid/';

  static String member(String uid, String membersId) =>
      'team/$uid/members/$membersId';

  static String members(String uid) => 'team/$uid/members/';

  static String codeRedeemUser(
          String uid, String membersId, String codeRedeemUserId) =>
      'team/$uid/members/$membersId/codeRedeemUsers/$codeRedeemUserId';

  static String codeRedeemUsers(String uid, String membersId) =>
      'team/$uid/members/$membersId/codeRedeemUsers/';

  //--------------------------------------------------------------------
  static String batch(
    String uid,
    String batchId,
  ) =>
      'admin/$uid/batches/$batchId';
  static String baches(String uid) => 'admin/$uid/batches';
  // -------- entries ------
  static String entry(
    String uid,
    String entryId,
  ) =>
      'admin/$uid/entries/$entryId';
  static String entries(String uid) => 'admin/$uid/entries';
  // ------- course ----
  static String course(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId';

  static String courses(
    String uid,
    String batchId,
  ) =>
      'admin/$uid/batches/$batchId/courses/';
  // ------- section ----
  static String section(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/';

  static String sections(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/';
  // ------- chapter ----
  static String chapter(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId';

  static String chapters(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/';

  // ------- topic ----
  static String topic(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
    String topicId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId/topics/$topicId';

  static String topics(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId/topics/';
  // ------- lecture ----
  static String lecture(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
    String topicId,
    String lectureId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId/topics/$topicId/lectures/$lectureId';

  static String lectures(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
    String topicId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId/topics/$topicId/lectures/';

  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// /////////////////// PART 1 ///////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
// ------- courseContent ----
  static String courseContent(
    String uid,
    String batchId,
    String courseId,
    String courseContentId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseContents/$courseContentId/';

  static String courseContents(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseContents/';
  // ------- chapterContent ----
  static String chapterContent(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
    String chapterContentId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId/chapterContents/$chapterContentId';

  static String chapterContents(
    String uid,
    String batchId,
    String courseId,
    String sectionId,
    String chapterId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/sections/$sectionId/chapters/$chapterId/chapterContents/';

  // ------- courseAbout ----
  static String courseAbout(
    String uid,
    String batchId,
    String courseId,
    String courseAboutId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseAbouts/$courseAboutId/';

  static String courseAbouts(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseAbouts/';
  // ------- courseFaculties ----
  static String courseFacultie(
    String uid,
    String batchId,
    String courseId,
    String courseFacultieId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseFaculties/$courseFacultieId/';

  static String courseFaculties(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseFaculties/';
  // ------- courseFAQs ----
  static String courseFAQ(
    String uid,
    String batchId,
    String courseId,
    String courseFAQId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseFAQs/$courseFAQId/';

  static String courseFAQs(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseFAQs/';
  // ------- courseKeyPoints ----
  static String courseKeyPoint(
    String uid,
    String batchId,
    String courseId,
    String courseKeyPointId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseKeyPoints/$courseKeyPointId/';

  static String courseKeyPoints(
    String uid,
    String batchId,
    String courseId,
  ) =>
      'admin/$uid/batches/$batchId/courses/$courseId/courseKeyPoints/';

  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// ///////////////////// PART 1 END /////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////

}
