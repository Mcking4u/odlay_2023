// To parse this JSON data, do
//
//     final skillCitiesProfessions = skillCitiesProfessionsFromJson(jsonString);

import 'dart:convert';

SkillCitiesProfessions skillCitiesProfessionsFromJson(String str) =>
    SkillCitiesProfessions.fromJson(json.decode(str));

String skillCitiesProfessionsToJson(SkillCitiesProfessions data) =>
    json.encode(data.toJson());

class SkillCitiesProfessions {
  SkillCitiesProfessions({
    required this.city,
    required this.skills,
    required this.topSkills,
    required this.professions,
    required this.status,
  });

  List<City> city;
  List<Skill> skills;
  List<Skill> topSkills;
  List<Profession> professions;
  String status;

  factory SkillCitiesProfessions.fromJson(Map<String, dynamic> json) =>
      SkillCitiesProfessions(
        city: List<City>.from(json["city"].map((x) => City.fromJson(x))),
        skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        topSkills:
            List<Skill>.from(json["top_skills"].map((x) => Skill.fromJson(x))),
        professions: List<Profession>.from(
            json["professions"].map((x) => Profession.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "city": List<dynamic>.from(city.map((x) => x.toJson())),
        "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
        "top_skills": List<dynamic>.from(topSkills.map((x) => x.toJson())),
        "professions": List<dynamic>.from(professions.map((x) => x.toJson())),
        "status": status,
      };
}

class City {
  City({
    required this.cityId,
    required this.cityTitle,
    required this.cityTitle2,
    required this.gid,
    required this.district,
  });

  int cityId;
  String? cityTitle;
  String? cityTitle2;
  String? gid;
  String? district;

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityId: json["city_id"],
        cityTitle: json["city_title"],
        cityTitle2: json["city_title2"],
        gid: json["gid"],
        district: json["district"],
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "city_title": cityTitle,
        "city_title2": cityTitle2,
        "gid": gid,
        "district": district,
      };
  @override
  String toString() => cityTitle.toString();
}

class Profession {
  Profession({
    required this.professionId,
    required this.professionName,
    required this.professionImage,
  });

  int professionId;
  String? professionName;
  String? professionImage;

  factory Profession.fromJson(Map<String, dynamic> json) => Profession(
        professionId: json["profession_id"],
        professionName: json["profession_name"],
        professionImage:
            json["profession_image"] == null ? null : json["profession_image"],
      );

  Map<String, dynamic> toJson() => {
        "profession_id": professionId,
        "profession_name": professionName,
        "profession_image": professionImage == null ? null : professionImage,
      };
}

class Skill {
  Skill({
    required this.skillId,
    required this.skillName,
    this.professionId,
  });

  int skillId;
  String skillName;
  int? professionId;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        skillId: json["skill_id"],
        skillName: json["skill_name"],
        professionId: json["profession_id"],
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "skill_name": skillName,
        "profession_id": professionId,
      };
  @override
  String toString() => skillName.toString();
}
