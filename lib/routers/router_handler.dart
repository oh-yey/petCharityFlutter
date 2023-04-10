import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:pet_charity/models/address/area.dart';
import 'package:pet_charity/models/adopt/pet_adopt.dart';
import 'package:pet_charity/models/donate/donate.dart';
import 'package:pet_charity/models/donate/pet_donate.dart';
import 'package:pet_charity/models/filter/filter_result.dart';
import 'package:pet_charity/models/pet/pet.dart';
import 'package:pet_charity/models/question/question.dart';
import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/view/adopt/adopt_edit_page.dart';
import 'package:pet_charity/view/adopt/my_adopt_list_page.dart';
import 'package:pet_charity/view/adopt/select_pet_page.dart';
import 'package:pet_charity/view/adopt/adopt_details_contact_page.dart';
import 'package:pet_charity/view/adopt/adopt_details_page.dart';
import 'package:pet_charity/view/donate/donate_details_page.dart';
import 'package:pet_charity/view/donate/donate_help_donation_leaderboard_page.dart';
import 'package:pet_charity/view/donate/donate_help_donation_page.dart';
import 'package:pet_charity/view/donate/donate_help_donation_play_page.dart';
import 'package:pet_charity/view/main_page.dart';
import 'package:pet_charity/view/login/login_page.dart';
import 'package:pet_charity/view/login/verification_code_page.dart';
import 'package:pet_charity/view/personal/feedback_view.dart';
import 'package:pet_charity/view/personal/personal_authentication_page.dart';
import 'package:pet_charity/view/personal/personal_center_page.dart';
import 'package:pet_charity/view/personal/personal_contact_view.dart';
import 'package:pet_charity/view/personal/select_address_page.dart';
import 'package:pet_charity/view/pet/pet_details_page.dart';
import 'package:pet_charity/view/pet/pet_edit_page.dart';
import 'package:pet_charity/view/pet/pet_list_page.dart';
import 'package:pet_charity/view/pet/select_breed_page.dart';
import 'package:pet_charity/view/pet/select_weight_page.dart';
import 'package:pet_charity/view/question/answer_list_page.dart';
import 'package:pet_charity/view/question/answer_page.dart';
import 'package:pet_charity/view/question/question_edit_page.dart';
import 'package:pet_charity/view/search/filter_page.dart';
import 'package:pet_charity/view/search/search_page.dart';

// APP入口
Handler mainPageHandler = Handler(handlerFunc: (context, parameters) => const MainPage());

// 登录
Handler loginHandler = Handler(handlerFunc: (context, parameters) => const LoginPage());
// 验证码
Handler vCodeHandler = Handler(handlerFunc: (context, parameters) => VerificationCodePage(parameters["phone"]?.first));
// 个人信息修改
Handler personalCenterHandler = Handler(handlerFunc: (context, parameters) => const PersonalCenterPage());
// 个人联系方式修改
Handler personalContactHandler = Handler(handlerFunc: (context, parameters) => const PersonalContactView());
// 实名认证
Handler personalAuthenticationHandler = Handler(handlerFunc: (context, parameters) => const PersonalAuthenticationPage());
// 用户反馈
Handler feedbackHandler = Handler(handlerFunc: (context, parameters) => const FeedbackView());

// 搜索
Handler searchHandler = Handler(handlerFunc: (c, p) => const SearchPage());
// 筛选
Handler filterHandler = Handler(handlerFunc: (c, p) => FilterPage(FilterResult.fromJson(jsonDecode(p['filterResult']?.first ?? ''))));

// 体重选择
Handler selectWeightHandler = Handler(handlerFunc: (c, p) => SelectWeightPage(double.parse(p['defaultWeight']?.first ?? '0'), p['breedName']?.first));
// 品种选择
Handler selectBreedHandler = Handler(handlerFunc: (c, p) => SelectBreedPage(race: int.parse(p['race']?.first ?? '0')));
// 地址选择
Handler selectAddressHandler = Handler(handlerFunc: (c, p) => SelectAddressPage(area: Area.fromJson(jsonDecode(p['area']?.first ?? ''))));
// 宠物选择
Handler selectPetHandler = Handler(handlerFunc: (c, p) => const SelectPetPage());

// --------------------------------------------------宠物--------------------------------------------------
// 宠物列表
Handler petListHandler = Handler(handlerFunc: (c, p) => const PetListPage());
// 宠物详情
Handler petDetailsHandler = Handler(handlerFunc: (c, p) => PetDetailsPage(Pet.fromJson(jsonDecode(p['pet']?.first ?? ''))));
// 宠物编辑
Handler petEditHandler = Handler(handlerFunc: (c, p) => PetEditPage(isAdd: false, pet: Pet.fromJson(jsonDecode(p['pet']?.first ?? ''))));
// 宠物添加
Handler petAddHandler = Handler(handlerFunc: (c, p) => const PetEditPage(isAdd: true));

// --------------------------------------------------宠物帮助众筹--------------------------------------------------
// 宠物帮助众筹详情
Handler petDonateDetailsHandler = Handler(handlerFunc: (c, p) => DonateDetailsPage(PetDonate.fromJson(jsonDecode(p['donate']?.first ?? ''))));
// 捐赠排行榜
Handler petDonateHelpDonationLeaderboardHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  List<Donate> donationList = [];
  dynamic json = jsonDecode(parameters['donationList']?.first ?? '');
  if (json != null) {
    json.forEach((item) => donationList.add(Donate.fromJson(item)));
  }
  return DonateHelpDonationLeaderboardPage(donationList);
});
// 宠物帮助众筹捐赠
Handler petDonateHelpDonationHandler = Handler(handlerFunc: (c, p) => DonateHelpDonationPage(PetDonate.fromJson(jsonDecode(p['donate']?.first ?? ''))));
// 宠物帮助众筹捐赠支付
Handler petDonateHelpDonationPlayHandler =
    Handler(handlerFunc: (c, p) => DonateHelpDonationPlayPage(PetDonate.fromJson(jsonDecode(p['donate']?.first ?? '')), num.parse(p['money']?.first ?? '0')));

// --------------------------------------------------宠物领养--------------------------------------------------
// 宠物领养详情
Handler petAdoptDetailsHandler = Handler(handlerFunc: (c, p) => AdoptDetailsPage(PetAdopt.fromJson(jsonDecode(p['adopt']?.first ?? ''))));
// 领养联系方式
Handler petAdoptDetailsContactHandler = Handler(handlerFunc: (c, p) => AdoptDetailsContactPage(User.fromJson(jsonDecode(p['user']?.first ?? ''))));
// 我的领养
Handler myPetAdoptListHandler = Handler(handlerFunc: (c, p) => const MyAdoptListPage());
// 宠物领养编辑
Handler adoptEditHandler = Handler(handlerFunc: (c, p) => AdoptEditPage(isAdd: false, adopt: PetAdopt.fromJson(jsonDecode(p['adopt']?.first ?? ''))));
// 宠物领养添加
Handler adoptAddHandler = Handler(handlerFunc: (c, p) => const AdoptEditPage(isAdd: true));

// --------------------------------------------------问答--------------------------------------------------
// 答案列表
Handler answerListHandler = Handler(handlerFunc: (c, p) => AnswerListPage(Question.fromJson(jsonDecode(p['question']?.first ?? ''))));
Handler answerHandler = Handler(handlerFunc: (c, p) => AnswerPage(Question.fromJson(jsonDecode(p['question']?.first ?? ''))));
// 编辑问题
Handler questionEditHandler = Handler(
  handlerFunc: (c, p) => QuestionEditPage(
    isAdd: false,
    question: Question.fromJson(jsonDecode(p['question']?.first ?? '')),
  ),
);
// 添加问题
Handler questionAddHandler = Handler(handlerFunc: (c, p) => const QuestionEditPage(isAdd: true));
