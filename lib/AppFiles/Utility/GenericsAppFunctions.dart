import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/Tuple.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart'
    as topRated;

import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_SptopRatedServiceProvider.dart'
    as recomeded;

class GenericAppFunctions {
  static String getCityNameFromCityId(
      SkillCitiesProfessions skillCitiesProfessions, int? cityId) {
    String cityName = "";
    int cityIndex =
        skillCitiesProfessions.city.indexWhere((city) => city.cityId == cityId);
    cityName = skillCitiesProfessions.city[cityIndex].cityTitle.toString();
    return cityName;
  }

  static List<String> getGigListFromString(String? imageList) {
    print("ImagesListString$imageList");
    List<String> imgList = [];
    var retreivedImages = jsonDecode(imageList!) as List<dynamic>;
    print("ImageListSize${retreivedImages.length}");
    for (var image in retreivedImages) {
      print("GigImageName${image}");
      imgList.add(AppConstants.GIGIMAGESURLS + image);
    }
    return imgList;
  }

//review images from string
  static List<String> getReviewImageListFromString(String? imageList) {
    print("ImagesListString$imageList");
    List<String> imgList = [];
    var retreivedImages = jsonDecode(imageList!) as List<dynamic>;
    print("ImageListSize${retreivedImages.length}");
    for (var image in retreivedImages) {
      print("ReviewImageUrl${AppConstants.REVIEWIMAGESURLS + image}");
      imgList.add(AppConstants.REVIEWIMAGESURLS + image);
    }
    return imgList;
  }

  static String getReviewImageListFromStringOneUrl(
      String? imageList, int index) {
    // print("ImagesListString$imageList");
    List<String> imgList = [];
    var retreivedImages = jsonDecode(imageList!) as List<dynamic>;
    // print("ImageListSize${retreivedImages.length}");
    for (var image in retreivedImages) {
      //  print("ReviewImageUrl${AppConstants.REVIEWIMAGESURLS + image}");
      imgList.add(AppConstants.REVIEWIMAGESURLS + image);
    }
    return imgList[index];
  }

  static String getFormattedDate(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }

  static String getTimeFromDate(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    var outputFormat = DateFormat('HH:mm');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }

  static List<String> getJobImagesFromString(String? imageList) {
    print("ImagesListString$imageList");
    List<String> imgList = [];
    var retreivedImages = jsonDecode(imageList!) as List<dynamic>;
    print("ImageListSize${retreivedImages.length}");
    for (var image in retreivedImages) {
      imgList.add(AppConstants.JObIMAGESURLS + image);
      print("FirstImageUrl${imgList[0]}");
    }
    return imgList;
  }

  static List<String> getPortfolioImagesFromString(String? imageList) {
    print("ImagesListString$imageList");
    List<String> imgList = [];
    var retreivedImages = jsonDecode(imageList!) as List<dynamic>;
    print("ImageListSize${retreivedImages.length}");
    for (var image in retreivedImages) {
      imgList.add(AppConstants.PORTFOLIOIMAGESURLS + image);
      print("FirstImageUrl${imgList[0]}");
    }
    return imgList;
  }

//retrieve cityId and address
  static Future<GetCityAndAddress> getCityAndAddress(
      SkillCitiesProfessions skillCitiesProfessions,
      double currentLat,
      double currentLng,
      int? appRegion) async {
    int cityId = 0;
    String address = "";
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(currentLat, currentLng);
    geocoding.Placemark placeMark = placemarks[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? street = placeMark.street;
    if(appRegion==2){
address = GenericAppFunctions.removeDuplicateAddress(
        "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality}  ${country}");
    }
    else{
    address = GenericAppFunctions.removeDuplicateAddress(
        "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
      }
    for (var i = 0; i < skillCitiesProfessions.city.length; i++) {
      String city_name = skillCitiesProfessions.city[i].cityTitle.toString();
      String city_name1 = skillCitiesProfessions.city[i].cityTitle2.toString();
      if (city_name == locality) {
        cityId = skillCitiesProfessions.city[i].cityId;
        print("CityId$cityId");
      }
      else if(city_name1 == locality){
        cityId = skillCitiesProfessions.city[i].cityId;
        print("CityId$cityId");
      }
      print("CityName$city_name");
    }
    HeaderFilterConstant.defualtCityId = cityId;
    HeaderFilterConstant.defaultCityName = locality.toString();
    HeaderFilterConstant.defaultCityAddress = address;
    return new GetCityAndAddress(cityId, address);
  }

  static String getSkillNameFromSkillList(List<topRated.Skill>? uSkills) {
    String skillName = "";
    for (var skill in uSkills!) {
      skillName = skillName + "," + skill.skillName.toString();
    }
    return skillName;
  }

  static String getSkillNameFromSkillListRec(List<recomeded.Skill>? uSkills) {
    String skillName = "";
    for (var skill in uSkills!) {
      skillName = skillName + "," + skill.skillName.toString();
    }
    return skillName;
  }

//get Applicant list
  static String getSkillNameFromApplicantSkillList(
      List<ApplicantSkill>? uSkills) {
    String skillName = "";
    for (var skill in uSkills!) {
      skillName = skillName + "," + skill.skillName.toString();
    }
    return skillName;
  }

//get skill from job skill
  static String getSkillFromJobSkill(List<Jobskill>? jobSkills) {
    String skillName = "";
    for (var skill in jobSkills!) {
      skillName = skillName + "," + skill.skillName.toString();
    }
    return skillName;
  }

//function to remove duplicates from address
  static String removeDuplicateAddress(String retrieveAddress) {
    print("RetriveAddress$retrieveAddress");
    String updatedAddress = "";
    List<String> stringList = retrieveAddress.split(" ");

    List<String> result = LinkedHashSet<String>.from(stringList).toList();

    //print(result);
    updatedAddress = result
        .toString()
        .replaceAll(",", "")
        .replaceAll("[", "")
        .replaceAll("]", "");
    return updatedAddress;
  }
}
