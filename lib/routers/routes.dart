import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:pet_charity/routers/router_handler.dart';

class Routes {
  static String root = "/";

  static String login = '/login'; // 登录
  static String vCode = '/vCode'; // 验证码
  static String personalCenter = '/personalCenter'; // 个人信息修改
  static String personalContact = '/personalContact'; // 个人联系方式修改
  static String personalAuthentication = '/personalAuthentication'; // 实名认证
  static String feedback = '/feedback'; // 用户反馈

  static String search = '/search'; // 搜索
  static String filter = '/filter'; // 筛选

  static String selectWeight = '/selectWeight'; // 体重选择
  static String selectBreed = '/selectBreed'; // 品种选择
  static String selectAddress = '/selectAddress'; // 地址选择
  static String selectPet = '/selectPet'; // 宠物选择

  // --------------------------------------------------宠物--------------------------------------------------
  static String petList = '/petList'; // 宠物列表
  static String petDetails = '/petDetails'; // 宠物详情
  static String petEdit = '/petEdit'; // 宠物编辑
  static String petAdd = '/petAdd'; // 宠物添加

  // --------------------------------------------------宠物帮助众筹--------------------------------------------------
  static String petDonateDetails = '/petDonateDetails'; // 宠物帮助众筹详情
  static String petDonateHelpDonationLeaderboard = '/petDonateHelpDonationLeaderboard'; // 捐赠排行榜
  static String petDonateHelpDonation = '/petDonateHelpDonation'; // 宠物帮助众筹捐赠
  static String petDonateHelpDonationPlay = '/petDonateHelpDonationPlay'; // 宠物帮助众筹捐赠支付

  // --------------------------------------------------宠物领养--------------------------------------------------
  static String petAdoptDetails = '/petAdoptDetails'; // 领养详情
  static String petAdoptDetailsContact = '/petAdoptDetailsContact'; // 领养联系方式
  static String myPetAdoptList = '/myPetAdoptList'; // 我的领养
  static String adoptEdit = '/adoptEdit'; // 宠物领养编辑
  static String adoptAdd = '/adoptAdd'; // 宠物领养添加

  // --------------------------------------------------问答--------------------------------------------------
  static String answerList = '/answerList'; // 答案列表
  static String answer = '/answer'; // 问答 回答
  static String questionEdit = '/questionEdit'; // 编辑问题
  static String questionAdd = '/questionAdd'; // 添加问题

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      debugPrint("没有找到ROUTE!!!");
      return;
    });

    router.define(root, handler: mainPageHandler);

    router.define(login, handler: loginHandler);
    router.define(vCode, handler: vCodeHandler);
    router.define(personalCenter, handler: personalCenterHandler);
    router.define(personalContact, handler: personalContactHandler);
    router.define(personalAuthentication, handler: personalAuthenticationHandler);
    router.define(feedback, handler: feedbackHandler);

    router.define(search, handler: searchHandler);
    router.define(filter, handler: filterHandler);

    router.define(selectWeight, handler: selectWeightHandler);
    router.define(selectBreed, handler: selectBreedHandler);
    router.define(selectAddress, handler: selectAddressHandler);
    router.define(selectPet, handler: selectPetHandler);

    router.define(petList, handler: petListHandler);
    router.define(petDetails, handler: petDetailsHandler);
    router.define(petEdit, handler: petEditHandler);
    router.define(petAdd, handler: petAddHandler);

    router.define(petDonateDetails, handler: petDonateDetailsHandler);
    router.define(petDonateHelpDonationLeaderboard, handler: petDonateHelpDonationLeaderboardHandler);
    router.define(petDonateHelpDonation, handler: petDonateHelpDonationHandler);
    router.define(petDonateHelpDonationPlay, handler: petDonateHelpDonationPlayHandler);

    router.define(petAdoptDetails, handler: petAdoptDetailsHandler);
    router.define(petAdoptDetailsContact, handler: petAdoptDetailsContactHandler);
    router.define(myPetAdoptList, handler: myPetAdoptListHandler);
    router.define(adoptEdit, handler: adoptEditHandler);
    router.define(adoptAdd, handler: adoptAddHandler);

    router.define(answerList, handler: answerListHandler);
    router.define(answer, handler: answerHandler);
    router.define(questionEdit, handler: questionEditHandler);
    router.define(questionAdd, handler: questionAddHandler);

  }
}
