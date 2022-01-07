import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/chapter_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_about.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_facalties.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_faqs.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_key_points.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/entry.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/lecture.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/app/widgets/slidder_depart/slidder_image_model.dart';
import 'package:fastguide/login/data_models/payment_history.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_device_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_online_model.dart';
import 'package:fastguide/login/data_models/user_subcribe_batch_model.dart';
import 'package:fastguide/login/data_models/user_subcribed_class_model.dart';
import 'package:fastguide/services/api_path.dart';
import 'package:fastguide/services/firestore_service.dart';

abstract class Database {
  // ----------- UserData-------------
  Future<void> setUser({required UserData userData});
  Stream<List<UserData>> UsersStream();
  Stream<List<UserData>> UsersStreamSortByAlphabet();
  Stream<List<UserData>> UsersStreamForSearchName({required String searchName});
  Stream<List<UserData>> UsersStreamForSearchMobileNo(
      {required String searchName});
  Stream<UserData> UserStream();
  Future<void> deleteUser();
  // ---userclass ---
  Future<void> setUserClass({
    required UserClassData userClassData,
  });
  Stream<List<UserClassData>> UsersClassStream({required UserData userData});

  Stream<UserClassData> UserClassStream(
      {required UserClassData userClassData, required UserData userData});
  Future<void> deleteUserClass(
      {required UserClassData userClassData, required UserData userData});
  // ---userSubcribed ---
  //--- user device data ---
  Future<void> setUserDevice({
    required UserDeviceData userDeviceData,
  });
  Stream<List<UserDeviceData>> usersDeviceStream();
  Stream<UserDeviceData> userDeviceStream({required UserData userData});
  Future<void> deleteDeviceUser({required UserData userData});
  // --- ---- ---
  //--------------- online Status ----------------------
  Future<void> setUserstatus({
    required UserStatusData userStatusData,
  });
  Stream<List<UserStatusData>> usersStatus();
  Stream<UserStatusData> userStatus({required UserData userData});
  Future<void> deleteStatus({required UserData userData});

  //-----------------------------------------------------
  ///----
  Stream<List<UserSubcribedBatch>> UsersSubcribedBatchStream({
    required UserData userData,
  });
  Future<void> setUserSubcribedBatch({
    required UserSubcribedBatch userSubcribedBatch,
    required UserData userData,
  });

  ///------
  Future<void> setUserSubcribedClass({
    required UserSubcribedClassData userSubcribedClassData,
    required UserData userData,
  });
  Stream<List<UserSubcribedClassData>> UsersSubcribedClassStream({
    required Batch batch,
    required UserData userData,
  });
  Stream<UserSubcribedClassData> UserSubcribedClassStream({
    required Batch batch,
    required Course course,
    required UserData userData,
  });
  Future<void> deleteUserSubcribedClass({
    required UserSubcribedClassData userSubcribedClassData,
    required UserData userData,
  });
  // --------------------------------
  // ----------------- Slider -------------
  Future<void> setSlidder({required SlidderModel slidderModel});
  Stream<List<SlidderModel>> slidders();
  Stream<SlidderModel> slidder();
  Future<void> deleteSlidder();

  //-----------------------------------
  // ------------- TEAM ---------------
  //--- member ---
  Future<void> setMember({required Member member});
  Stream<List<Member>> membersStream();
  Stream<Member> memberStream({required Member member});
  Future<void> deleteMember({required Member member});

  // --- code redeem user ---
  Future<void> setCodeRedeemUser({
    required Member member,
    required CodeRedeemUser codeRedeemUser,
  });
  Stream<List<CodeRedeemUser>> codeRedeemUsersStream({
    required Member member,
  });
  Stream<CodeRedeemUser> codeRedeemUserStream({
    required Member member,
    required CodeRedeemUser codeRedeemUser,
  });
  Future<void> deleteCodeRedeemUser({
    required Member member,
    required CodeRedeemUser codeRedeemUser,
  });
  // --- --- ---
  // ------------------------------------
  //-------- payment History -----------
  Future<void> setPaymentHistory({
    required PaymentHistory paymentHistory,
    required UserData userData,
  });
  Stream<List<PaymentHistory>> paymentsHistoryStream(
      {required UserData userData});
  Stream<PaymentHistory> paymentHistoryStream(
      {required PaymentHistory paymentHistory, required UserData userData});
  Future<void> deletepaymentHistory({
    required PaymentHistory paymentHistory,
    required UserData userData,
  });
  //------------Batch ----------------
  Future<void> setBatch(Batch batch);
  Future<void> deleteBatch(Batch batch);
  Stream<List<Batch>> batchesStream();
  Stream<Batch> batchStream({required String batchId});
  // ------ entry -----
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Batch job});
  // ---- course ----
  Stream<Course> courseStream(
      {required String jobId,
      required String batchId,
      required String courseId});
  Future<void> setCourse({required Course course, required Batch batch});
  Stream<List<Course>> coursesStream({required String batchId});
  Future<void> deleteCourse(Batch batch, Course course);
  // ----------- section -----------
  Future<void> setSection({
    required Batch batch,
    required Course course,
    required Section section,
  });
  Stream<List<Section>> sectionsStream({
    required String batchId,
    required String courseId,
  });
  Stream<Section> sectionStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
  });
  Future<void> deleteSection(
    Batch batch,
    Course course,
    Section section,
  );
  // ------- chapter -----
  Future<void> setChapter({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
  });
  Stream<List<Chapter>> chaptersStream({
    required String batchId,
    required String courseId,
    required String sectionId,
  });
  Stream<Chapter> chapterStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
  });
  Future<void> deleteChapter(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
  );
  // ------------- topic ---------
  Future<void> setTopic({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
    required Topic topic,
  });
  Stream<List<Topic>> topicsStream({
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
  });
  Stream<Topic> topicStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String topicId,
  });
  Future<void> deleteTopic(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    Topic topic,
  );
  // -------- Lecture ----------
  Future<void> setLecture({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
    required Topic topic,
    required Lecture lecture,
  });
  Stream<List<Lecture>> lecturesStream({
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String topicId,
  });
  Stream<Lecture> lectureStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String topicId,
    required String lectureId,
  });
  Future<void> deleteLecture(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    Topic topic,
    Lecture lecture,
  );
  //--------
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// /////////////////// PART 1 ///////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// ---------- Course CONTENT --------------------------
  Future<void> setCourseContent({
    required Batch batch,
    required Course course,
    required CourseContent courseContent,
  });
  courseContentsStream({
    required String batchId,
    required String courseId,
  });
  Stream<CourseContent> courseContentStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseContentId,
  });
  Future<void> deleteCourseContent(
    Batch batch,
    Course course,
    CourseContent courseContent,
  );

  /// ---------- Chapter Content  -------------------------------

  Future<void> setChapterContent({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
    required ChapterContent chapterContent,
  });
  Stream<List<ChapterContent>> chapterContentsStream({
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
  });

  Stream<ChapterContent> chapterContentStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String chapterContentId,
  });

  Future<void> deleteChapterContent(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    ChapterContent chapterContent,
  );

  /// ---------- Course ABOUT --------------------------
  Future<void> setCourseAbout({
    required Batch batch,
    required Course course,
    required CourseAbout courseAbout,
  });
  Stream<List<CourseAbout>> courseAboutsStream({
    required String batchId,
    required String courseId,
  });
  Stream<CourseAbout> courseAboutStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseAboutId,
  });
  Future<void> deleteCourseAbout(
    Batch batch,
    Course course,
    CourseAbout courseAbout,
  );

  /// ---------- Course FACULTIES --------------------------
  Future<void> setCourseFaculties({
    required Batch batch,
    required Course course,
    required CourseFaculties courseFacalties,
  });
  Stream<List<CourseFaculties>> courseFacultiesStream({
    required String batchId,
    required String courseId,
  });
  Stream<CourseFaculties> courseFacultieStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseFacultieId,
  });
  Future<void> deleteCourseFacultie(
    Batch batch,
    Course course,
    CourseFaculties courseFacalties,
  );

  /// ---------- Course FAQs --------------------------
  Future<void> setCourseFAQs({
    required Batch batch,
    required Course course,
    required CourseFAQs courseFAQs,
  });
  Stream<List<CourseFAQs>> courseFAQsStream({
    required String batchId,
    required String courseId,
  });
  Stream<CourseFAQs> courseFAQStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseFAQId,
  });
  Future<void> deleteCourseFAQ(
    Batch batch,
    Course course,
    CourseFAQs courseFAQs,
  );

  /// ---------- Course KEY POINTS --------------------------
  Future<void> setCourseKeyPoint({
    required Batch batch,
    required Course course,
    required CourseKeyPoints courseKeyPoints,
  });
  Stream<List<CourseKeyPoints>> courseKeyPointsStream({
    required String batchId,
    required String courseId,
  });
  Stream<CourseKeyPoints> courseKeyPointStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseKeyPointId,
  });
  Future<void> deleteCourseKeyPoint(
    Batch batch,
    Course course,
    CourseKeyPoints courseKeyPoints,
  );

  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// ///////////////////// PART 1 END /////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
String currentDate() => DateTime.now().toString().substring(0, 16);

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.UserId}) : assert(UserId != null);
  final String UserId;
  final String AdminId = "3M4eRPvs8QcMEgURx2by5LbrZFY2";

  final _service = FirestoreService.instance;
// -------------------USER DATABASE----------------------

// -------- UserDataBase ----------
  @override
  Future<void> setUser({required UserData userData}) {
    return _service.setData(
      path: APIPath.user(UserId),
      data: userData.toMap(),
    );
  }

  @override
  Stream<List<UserData>> UsersStream() => _service.collectionStream(
        path: APIPath.Users(UserId),
        builder: (data, documentId) => UserData.fromMap(data, documentId),
        sort: (a, b) => a.registerDate.compareTo(b.registerDate),
      );
  @override
  Stream<List<UserData>> UsersStreamSortByAlphabet() =>
      _service.collectionStream(
        path: APIPath.Users(UserId),
        builder: (data, documentId) => UserData.fromMap(data, documentId),
        sort: (a, b) => b.userName.compareTo(a.userName),
      );
  // --- search User --
  @override
  Stream<List<UserData>> UsersStreamForSearchName(
          {required String searchName}) =>
      _service.collectionStreamSearch(
        path: APIPath.Users(UserId),
        builder: (data, documentId) => UserData.fromMap(data, documentId),
        search: (a) =>
            a.userName.toLowerCase().contains(searchName.toLowerCase()),
      );
  @override
  Stream<List<UserData>> UsersStreamForSearchMobileNo(
          {required String searchName}) =>
      _service.collectionStreamSearch(
        path: APIPath.Users(UserId),
        builder: (data, documentId) => UserData.fromMap(data, documentId),
        search: (a) =>
            a.mobileNo.toLowerCase().contains(searchName.toLowerCase()),
      );
  // -- -- --
  @override
  Stream<UserData> UserStream() => _service.documentStream(
        path: APIPath.user(UserId),
        builder: (data, documentId) => UserData.fromMap(data, documentId),
      );

  @override
  Future<void> deleteUser() => _service.deleteData(
        path: APIPath.user(UserId),
      );
  // --------------------------
  // -------------device Detail --------------------
  @override
  Future<void> setUserDevice({
    required UserDeviceData userDeviceData,
  }) {
    return _service.setData(
      path: APIPath.userDeviceData(UserId),
      data: userDeviceData.toMap(),
    );
  }

  @override
  Stream<List<UserDeviceData>> usersDeviceStream() => _service.collectionStream(
        path: APIPath.usersDeviceData(),
        builder: (data, documentId) => UserDeviceData.fromMap(data, documentId),
      );

  @override
  Stream<UserDeviceData> userDeviceStream({required UserData userData}) =>
      _service.documentStream(
        path: APIPath.userDeviceData(userData.id),
        builder: (data, documentId) => UserDeviceData.fromMap(data, documentId),
      );

  @override
  Future<void> deleteDeviceUser({required UserData userData}) =>
      _service.deleteData(
        path: APIPath.userDeviceData(userData.id),
      );
  // ---------------------------------------------
  // ------------------ user online Status --------------
  @override
  Future<void> setUserstatus({
    required UserStatusData userStatusData,
  }) {
    return _service.setData(
      path: APIPath.userStatus(UserId),
      data: userStatusData.toMap(),
    );
  }

  @override
  Stream<List<UserStatusData>> usersStatus() => _service.collectionStream(
        path: APIPath.usersStatus(),
        builder: (data, documentId) => UserStatusData.fromMap(data, documentId),
      );

  @override
  Stream<UserStatusData> userStatus({required UserData userData}) =>
      _service.documentStream(
        path: APIPath.userStatus(userData.id),
        builder: (data, documentId) => UserStatusData.fromMap(data, documentId),
      );

  @override
  Future<void> deleteStatus({required UserData userData}) =>
      _service.deleteData(
        path: APIPath.userStatus(userData.id),
      );
  // -----------------------------------------------------
  // --------------------- Slidder -------------------

  @override
  Future<void> setSlidder({
    required SlidderModel slidderModel,
  }) {
    return _service.setData(
      path: APIPath.slidder(documentIdFromCurrentDate()),
      data: slidderModel.toMap(),
    );
  }

  @override
  Stream<List<SlidderModel>> slidders() => _service.collectionStream(
        path: APIPath.slidders(),
        builder: (data, documentId) => SlidderModel.fromMap(data, documentId),
      );

  @override
  Stream<SlidderModel> slidder() => _service.documentStream(
        path: APIPath.slidder(documentIdFromCurrentDate()),
        builder: (data, documentId) => SlidderModel.fromMap(data, documentId),
      );

  @override
  Future<void> deleteSlidder() => _service.deleteData(
        path: APIPath.slidder(documentIdFromCurrentDate()),
      );

  //------------------------------------------------
// -------- UserClass Database ----------
  @override
  Future<void> setUserClass({
    required UserClassData userClassData,
  }) {
    return _service.upDateData(
      path: APIPath.userClass(UserId, userClassData.id),
      data: userClassData.toMap(),
    );
  }

  @override
  Stream<List<UserClassData>> UsersClassStream({required UserData userData}) =>
      _service.collectionStream(
        path: APIPath.UsersClass(userData.id),
        builder: (data, documentId) => UserClassData.fromMap(data, documentId),
      );

  @override
  Stream<UserClassData> UserClassStream({
    required UserClassData userClassData,
    required UserData userData,
  }) =>
      _service.documentStream(
        path: APIPath.userClass(userData.id, userClassData.id),
        builder: (data, documentId) => UserClassData.fromMap(data, documentId),
      );

  @override
  Future<void> deleteUserClass({
    required UserClassData userClassData,
    required UserData userData,
  }) =>
      _service.deleteData(
        path: APIPath.userClass(userData.id, userClassData.id),
      );
  // --------------------------
  /// ------------------///////////

  @override
  Future<void> setUserSubcribedBatch({
    required UserSubcribedBatch userSubcribedBatch,
    required UserData userData,
  }) {
    return _service.setData(
      path: APIPath.userSubcribedBatch(userData.id, userSubcribedBatch.id),
      data: userSubcribedBatch.toMap(),
    );
  }

  @override
  Stream<List<UserSubcribedBatch>> UsersSubcribedBatchStream({
    required UserData userData,
  }) =>
      _service.collectionStream(
        path: APIPath.usersSubcribedBatch(userData.id),
        builder: (data, documentId) =>
            UserSubcribedBatch.fromMap(data, documentId),
      );

  /// ------------------///////////
  // -------- UserSubcribedClassData Database ----------
  @override
  Future<void> setUserSubcribedClass({
    required UserSubcribedClassData userSubcribedClassData,
    required UserData userData,
  }) {
    return _service.upDateData(
      path: APIPath.userSubcribedClass(
        userData.id,
        userSubcribedClassData.userSubcribedBatch,
        userSubcribedClassData.userSubcribedCourse,
      ),
      data: userSubcribedClassData.toMap(),
    );
  }

  @override
  Stream<List<UserSubcribedClassData>> UsersSubcribedClassStream({
    required Batch batch,
    required UserData userData,
  }) =>
      _service.collectionStream(
        path: APIPath.usersSubcribedClass(
          userData.id,
          batch.id,
        ),
        builder: (data, documentId) =>
            UserSubcribedClassData.fromMap(data, documentId),
      );

  @override
  Stream<UserSubcribedClassData> UserSubcribedClassStream({
    required Batch batch,
    required Course course,
    required UserData userData,
  }) =>
      _service.documentStream(
        path: APIPath.userSubcribedClass(
          userData.id,
          batch.id,
          course.id,
        ),
        builder: (data, documentId) =>
            UserSubcribedClassData.fromMap(data, documentId),
      );

  @override
  Future<void> deleteUserSubcribedClass({
    required UserSubcribedClassData userSubcribedClassData,
    required UserData userData,
  }) =>
      _service.deleteData(
        path: APIPath.userSubcribedClass(
          userData.id,
          userSubcribedClassData.userSubcribedBatch,
          userSubcribedClassData.userSubcribedCourse,
        ),
      );
  // --------------------------
  // --------------- TEAM DATABASE ----------------
  // --- Member ---
  @override
  Future<void> setMember({required Member member}) {
    return _service.setData(
      path: APIPath.member(AdminId, member.id),
      data: member.toMap(),
    );
  }

  @override
  Stream<List<Member>> membersStream() => _service.collectionStream(
        path: APIPath.members(AdminId),
        builder: (data, documentId) => Member.fromMap(data, documentId),
      );

  @override
  Stream<Member> memberStream({required Member member}) =>
      _service.documentStream(
        path: APIPath.member(AdminId, member.id),
        builder: (data, documentId) => Member.fromMap(data, documentId),
      );

  @override
  Future<void> deleteMember({required Member member}) => _service.deleteData(
        path: APIPath.member(AdminId, member.id),
      );
  // --- code redeem user ---
  @override
  Future<void> setCodeRedeemUser({
    required Member member,
    required CodeRedeemUser codeRedeemUser,
  }) {
    return _service.setData(
      path: APIPath.codeRedeemUser(AdminId, member.id, codeRedeemUser.id),
      data: codeRedeemUser.toMap(),
    );
  }

  @override
  Stream<List<CodeRedeemUser>> codeRedeemUsersStream({
    required Member member,
  }) =>
      _service.collectionStream(
        path: APIPath.codeRedeemUsers(AdminId, member.id),
        builder: (data, documentId) => CodeRedeemUser.fromMap(data, documentId),
      );

  @override
  Stream<CodeRedeemUser> codeRedeemUserStream({
    required Member member,
    required CodeRedeemUser codeRedeemUser,
  }) =>
      _service.documentStream(
        path: APIPath.codeRedeemUser(AdminId, member.id, codeRedeemUser.id),
        builder: (data, documentId) => CodeRedeemUser.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCodeRedeemUser({
    required Member member,
    required CodeRedeemUser codeRedeemUser,
  }) =>
      _service.deleteData(
        path: APIPath.codeRedeemUser(AdminId, member.id, codeRedeemUser.id),
      );
  // ----------------------------------------------

  // --------------- Payment History --------------
  @override
  Future<void> setPaymentHistory({
    required PaymentHistory paymentHistory,
    required UserData userData,
  }) {
    return _service.setData(
      path: APIPath.paymentHistory(userData.id, paymentHistory.id),
      data: paymentHistory.toMap(),
    );
  }

  @override
  Stream<List<PaymentHistory>> paymentsHistoryStream(
          {required UserData userData}) =>
      _service.collectionStream(
        path: APIPath.paymentsHistory(userData.id),
        builder: (data, documentId) => PaymentHistory.fromMap(data, documentId),
      );

  @override
  Stream<PaymentHistory> paymentHistoryStream(
          {required PaymentHistory paymentHistory,
          required UserData userData}) =>
      _service.documentStream(
        path: APIPath.paymentHistory(userData.id, paymentHistory.id),
        builder: (data, documentId) => PaymentHistory.fromMap(data, documentId),
      );

  @override
  Future<void> deletepaymentHistory({
    required PaymentHistory paymentHistory,
    required UserData userData,
  }) =>
      _service.deleteData(
        path: APIPath.paymentHistory(userData.id, paymentHistory.id),
      );
  // ------------------------------------------------
// -----------------------------------------------
  @override
  Future<void> setBatch(Batch batch) => _service.setData(
        path: APIPath.batch(AdminId, batch.id),
        data: batch.toMap(),
      );

  @override
  Future<void> deleteBatch(Batch batch) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: batch).first;
    for (Entry entry in allEntries) {
      if (entry.batchId == batch.id) {
        await deleteEntry(entry);
      }
    }
    final allCourses = await coursesStream(batchId: batch.id).first;
    for (Course courses in allCourses) {
      if (courses.id == batch.id) {
        await deleteCourse(batch, courses);
      } else {
        await deleteCourse(batch, courses);
      }
    }

    // delete job
    await _service.deleteData(path: APIPath.batch(AdminId, batch.id));
  }

  @override
  Stream<Batch> batchStream({required String batchId}) =>
      _service.documentStream(
        path: APIPath.batch(AdminId, batchId),
        builder: (data, documentId) => Batch.fromMap(data, documentId),
      );

  @override
  Stream<List<Batch>> batchesStream() => _service.collectionStream(
        path: APIPath.baches(AdminId),
        builder: (data, documentId) => Batch.fromMap(data, documentId),
      );

  // -------- Course ----------
  @override
  Future<void> setCourse({required Course course, required Batch batch}) =>
      _service.setData(
        path: APIPath.course(AdminId, batch.id, course.id),
        data: course.toMap(),
      );

  @override
  Stream<List<Course>> coursesStream({required String batchId}) =>
      _service.collectionStream(
        path: APIPath.courses(AdminId, batchId),
        builder: (data, documentId) => Course.fromMap(data, documentId),
      );

  @override
  Stream<Course> courseStream({
    required String jobId,
    required String batchId,
    required String courseId,
  }) =>
      _service.documentStream(
        path: APIPath.course(AdminId, batchId, courseId),
        builder: (data, documentId) => Course.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCourse(Batch batch, Course course) => _service.deleteData(
        path: APIPath.course(AdminId, batch.id, course.id),
      );
  // --------------------------
  // -------- Section ----------
  @override
  Future<void> setSection({
    required Batch batch,
    required Course course,
    required Section section,
  }) {
    return _service.setData(
      path: APIPath.section(AdminId, batch.id, course.id, section.id),
      data: section.toMap(),
    );
  }

  @override
  Stream<List<Section>> sectionsStream({
    required String batchId,
    required String courseId,
  }) =>
      _service.collectionStream(
        path: APIPath.sections(AdminId, batchId, courseId),
        builder: (data, documentId) => Section.fromMap(data, documentId),
        sort: (a, b) => a.sectionNo.compareTo(b.sectionNo),
      );

  @override
  Stream<Section> sectionStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
  }) =>
      _service.documentStream(
        path: APIPath.section(AdminId, batchId, courseId, sectionId),
        builder: (data, documentId) => Section.fromMap(data, documentId),
      );

  @override
  Future<void> deleteSection(
    Batch batch,
    Course course,
    Section section,
  ) =>
      _service.deleteData(
        path: APIPath.section(AdminId, batch.id, course.id, section.id),
      );
  // --------------------------
  // -------- Chapters ----------
  @override
  Future<void> setChapter({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
  }) =>
      _service.setData(
        path: APIPath.chapter(
            AdminId, batch.id, course.id, section.id, chapter.id),
        data: chapter.toMap(),
      );

  @override
  Stream<List<Chapter>> chaptersStream({
    required String batchId,
    required String courseId,
    required String sectionId,
  }) =>
      _service.collectionStream(
        path: APIPath.chapters(AdminId, batchId, courseId, sectionId),
        builder: (data, documentId) => Chapter.fromMap(data, documentId),
        sort: (a, b) => a.chapterNo.compareTo(b.chapterNo),
      );

  @override
  Stream<Chapter> chapterStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
  }) =>
      _service.documentStream(
        path: APIPath.chapter(AdminId, batchId, courseId, sectionId, chapterId),
        builder: (data, documentId) => Chapter.fromMap(data, documentId),
      );

  @override
  Future<void> deleteChapter(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
  ) =>
      _service.deleteData(
        path: APIPath.chapter(
            AdminId, batch.id, course.id, section.id, chapter.id),
      );
// --------------------------

  // -------- Topic ----------
  @override
  Future<void> setTopic({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
    required Topic topic,
  }) =>
      _service.setData(
        path: APIPath.topic(
            AdminId, batch.id, course.id, section.id, chapter.id, topic.id),
        data: topic.toMap(),
      );

  @override
  Stream<List<Topic>> topicsStream({
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
  }) =>
      _service.collectionStream(
        path: APIPath.topics(AdminId, batchId, courseId, sectionId, chapterId),
        builder: (data, documentId) => Topic.fromMap(data, documentId),
        sort: (a, b) => a.topicNo.compareTo(b.topicNo),
      );

  @override
  Stream<Topic> topicStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String topicId,
  }) =>
      _service.documentStream(
        path: APIPath.topic(
            AdminId, batchId, courseId, sectionId, chapterId, topicId),
        builder: (data, documentId) => Topic.fromMap(data, documentId),
      );

  @override
  Future<void> deleteTopic(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    Topic topic,
  ) =>
      _service.deleteData(
        path: APIPath.topic(
            AdminId, batch.id, course.id, section.id, chapter.id, topic.id),
      );
  // --------------------------
  // -------- Lecture ----------
  @override
  Future<void> setLecture({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
    required Topic topic,
    required Lecture lecture,
  }) =>
      _service.setData(
        path: APIPath.lecture(AdminId, batch.id, course.id, section.id,
            chapter.id, topic.id, lecture.id),
        data: lecture.toMap(),
      );

  @override
  Stream<List<Lecture>> lecturesStream({
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String topicId,
  }) =>
      _service.collectionStream(
        path: APIPath.lectures(
            AdminId, batchId, courseId, sectionId, chapterId, topicId),
        builder: (data, documentId) => Lecture.fromMap(data, documentId),
        sort: (a, b) => a.lectureNo.compareTo(b.lectureNo),
      );

  @override
  Stream<Lecture> lectureStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String topicId,
    required String lectureId,
  }) =>
      _service.documentStream(
        path: APIPath.lecture(AdminId, batchId, courseId, sectionId, chapterId,
            topicId, lectureId),
        builder: (data, documentId) => Lecture.fromMap(data, documentId),
      );

  @override
  Future<void> deleteLecture(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    Topic topic,
    Lecture lecture,
  ) =>
      _service.deleteData(
        path: APIPath.lecture(AdminId, batch.id, course.id, section.id,
            chapter.id, topic.id, lecture.id),
      );
  // --------------------------
  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPath.entry(AdminId, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPath.entry(AdminId, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Batch? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(AdminId),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// /////////////////// PART 1 ///////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
// -------- courseContent ----------
  @override
  Future<void> setCourseContent({
    required Batch batch,
    required Course course,
    required CourseContent courseContent,
  }) {
    return _service.setData(
      path:
          APIPath.courseContent(AdminId, batch.id, course.id, courseContent.id),
      data: courseContent.toMap(),
    );
  }

  @override
  Stream<List<CourseContent>> courseContentsStream({
    required String batchId,
    required String courseId,
  }) =>
      _service.collectionStream(
        path: APIPath.courseContents(AdminId, batchId, courseId),
        builder: (data, documentId) => CourseContent.fromMap(data, documentId),
        sort: (a, b) => a.contentNo.compareTo(b.contentNo),
      );

  @override
  Stream<CourseContent> courseContentStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseContentId,
  }) =>
      _service.documentStream(
        path:
            APIPath.courseContent(AdminId, batchId, courseId, courseContentId),
        builder: (data, documentId) => CourseContent.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCourseContent(
    Batch batch,
    Course course,
    CourseContent courseContent,
  ) =>
      _service.deleteData(
        path: APIPath.courseContent(
            AdminId, batch.id, course.id, courseContent.id),
      );

  /// ---------- Chapter Content  -------------------------------
  @override
  Future<void> setChapterContent({
    required Batch batch,
    required Course course,
    required Section section,
    required Chapter chapter,
    required ChapterContent chapterContent,
  }) =>
      _service.setData(
        path: APIPath.chapterContent(AdminId, batch.id, course.id, section.id,
            chapter.id, chapterContent.id),
        data: chapterContent.toMap(),
      );

  @override
  Stream<List<ChapterContent>> chapterContentsStream({
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
  }) =>
      _service.collectionStream(
        path: APIPath.chapterContents(
            AdminId, batchId, courseId, sectionId, chapterId),
        builder: (data, documentId) => ChapterContent.fromMap(data, documentId),
        sort: (a, b) => a.contentNo.compareTo(b.contentNo),
      );

  @override
  Stream<ChapterContent> chapterContentStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String sectionId,
    required String chapterId,
    required String chapterContentId,
  }) =>
      _service.documentStream(
        path: APIPath.chapterContent(
            AdminId, batchId, courseId, sectionId, chapterId, chapterContentId),
        builder: (data, documentId) => ChapterContent.fromMap(data, documentId),
      );

  @override
  Future<void> deleteChapterContent(
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    ChapterContent chapterContent,
  ) =>
      _service.deleteData(
        path: APIPath.chapterContent(AdminId, batch.id, course.id, section.id,
            chapter.id, chapterContent.id),
      );

  /// -----------------------------------------------------------
  /// ---------- Course ABOUT -------------------------------
  @override
  Future<void> setCourseAbout({
    required Batch batch,
    required Course course,
    required CourseAbout courseAbout,
  }) {
    return _service.setData(
      path: APIPath.courseAbout(AdminId, batch.id, course.id, courseAbout.id),
      data: courseAbout.toMap(),
    );
  }

  @override
  Stream<List<CourseAbout>> courseAboutsStream({
    required String batchId,
    required String courseId,
  }) =>
      _service.collectionStream(
        path: APIPath.courseAbouts(AdminId, batchId, courseId),
        builder: (data, documentId) => CourseAbout.fromMap(data, documentId),
        // sort: (a, b) => a..compareTo(b.contentNo),
      );

  @override
  Stream<CourseAbout> courseAboutStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseAboutId,
  }) =>
      _service.documentStream(
        path: APIPath.courseAbout(AdminId, batchId, courseId, courseAboutId),
        builder: (data, documentId) => CourseAbout.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCourseAbout(
    Batch batch,
    Course course,
    CourseAbout courseAbout,
  ) =>
      _service.deleteData(
        path: APIPath.courseAbout(AdminId, batch.id, course.id, courseAbout.id),
      );

  /// ---------- Course FACULTIES ---------------------------
  @override
  Future<void> setCourseFaculties({
    required Batch batch,
    required Course course,
    required CourseFaculties courseFacalties,
  }) {
    return _service.setData(
      path: APIPath.courseFacultie(
          AdminId, batch.id, course.id, courseFacalties.id),
      data: courseFacalties.toMap(),
    );
  }

  @override
  Stream<List<CourseFaculties>> courseFacultiesStream({
    required String batchId,
    required String courseId,
  }) =>
      _service.collectionStream(
        path: APIPath.courseFaculties(AdminId, batchId, courseId),
        builder: (data, documentId) =>
            CourseFaculties.fromMap(data, documentId),
        sort: (a, b) => a.facultieNo.compareTo(b.facultieNo),
      );

  @override
  Stream<CourseFaculties> courseFacultieStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseFacultieId,
  }) =>
      _service.documentStream(
        path: APIPath.courseFacultie(
            AdminId, batchId, courseId, courseFacultieId),
        builder: (data, documentId) =>
            CourseFaculties.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCourseFacultie(
    Batch batch,
    Course course,
    CourseFaculties courseFacalties,
  ) =>
      _service.deleteData(
        path: APIPath.courseFacultie(
            AdminId, batch.id, course.id, courseFacalties.id),
      );

  /// ---------- Course FAQs --------------------------------
  @override
  Future<void> setCourseFAQs({
    required Batch batch,
    required Course course,
    required CourseFAQs courseFAQs,
  }) {
    return _service.setData(
      path: APIPath.courseFAQ(AdminId, batch.id, course.id, courseFAQs.id),
      data: courseFAQs.toMap(),
    );
  }

  @override
  Stream<List<CourseFAQs>> courseFAQsStream({
    required String batchId,
    required String courseId,
  }) =>
      _service.collectionStream(
        path: APIPath.courseFAQs(AdminId, batchId, courseId),
        builder: (data, documentId) => CourseFAQs.fromMap(data, documentId),
        sort: (a, b) => a.faqsNo.compareTo(b.faqsNo),
      );

  @override
  Stream<CourseFAQs> courseFAQStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseFAQId,
  }) =>
      _service.documentStream(
        path: APIPath.courseFAQ(AdminId, batchId, courseId, courseFAQId),
        builder: (data, documentId) => CourseFAQs.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCourseFAQ(
    Batch batch,
    Course course,
    CourseFAQs courseFAQs,
  ) =>
      _service.deleteData(
        path: APIPath.courseFAQ(AdminId, batch.id, course.id, courseFAQs.id),
      );

  /// ---------- Course KEY POINTS --------------------------
  @override
  Future<void> setCourseKeyPoint({
    required Batch batch,
    required Course course,
    required CourseKeyPoints courseKeyPoints,
  }) {
    return _service.setData(
      path: APIPath.courseKeyPoint(
          AdminId, batch.id, course.id, courseKeyPoints.id),
      data: courseKeyPoints.toMap(),
    );
  }

  @override
  Stream<List<CourseKeyPoints>> courseKeyPointsStream({
    required String batchId,
    required String courseId,
  }) =>
      _service.collectionStream(
        path: APIPath.courseKeyPoints(AdminId, batchId, courseId),
        builder: (data, documentId) =>
            CourseKeyPoints.fromMap(data, documentId),
        sort: (a, b) => a.keyPointsNo.compareTo(b.keyPointsNo),
      );

  @override
  Stream<CourseKeyPoints> courseKeyPointStream({
    required String jobId,
    required String batchId,
    required String courseId,
    required String courseKeyPointId,
  }) =>
      _service.documentStream(
        path: APIPath.courseKeyPoint(
            AdminId, batchId, courseId, courseKeyPointId),
        builder: (data, documentId) =>
            CourseKeyPoints.fromMap(data, documentId),
      );

  @override
  Future<void> deleteCourseKeyPoint(
    Batch batch,
    Course course,
    CourseKeyPoints courseKeyPoints,
  ) =>
      _service.deleteData(
        path: APIPath.courseKeyPoint(
            AdminId, batch.id, course.id, courseKeyPoints.id),
      );

  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// ///////////////////// PART 1 END /////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////
}
