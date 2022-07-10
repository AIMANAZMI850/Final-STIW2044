class Tutor {
  String? tutorId;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorDescription;
  String? tutorDateReg;
  String? subjectsown;

  Tutor(
      {this.tutorId,
      this.tutorEmail,
      this.tutorPhone,
      this.tutorName,
      this.tutorDescription,
      this.tutorDateReg,
      this.subjectsown});

  Tutor.fromJson(Map<String, dynamic> json) {
    tutorId = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
    tutorName = json['tutor_name'];
    tutorDescription = json['tutor_description'];
    tutorDateReg = json['tutor_datereg'];
    subjectsown = json['subjects_own'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutorId;
    data['tutor_email'] = tutorEmail;
    data['tutor_phone'] = tutorPhone;
    data['tutor_name'] = tutorName;
    data['tutor_description'] = tutorDescription;
    data['tutor_datereg'] = tutorDateReg;
    data['subjects_own'] = subjectsown;
    return data;
  }
}
