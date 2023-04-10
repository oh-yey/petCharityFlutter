import 'package:dio/dio.dart';
import 'package:pet_charity/models/question/answer_list.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/question/question_list.dart';

/// 获取问答列表
Future<QuestionList?> questionList({int classification = 1, int page = 1}) async {
  String path = '/ask/question/list?classification=$classification&page=$page';
  Response response = await DioClient().doGet(path);
  if (response.statusCode == 200) {
    return QuestionList.fromJson(response.data);
  }
  return null;
}

/// 获取问答答案列表
Future<AnswerList?> answerList(num question, {int page = 1}) async {
  String path = '/ask/answer/list?question=$question&page=$page';
  Response response = await DioClient().doGet(path);
  if (response.statusCode == 200) {
    return AnswerList.fromJson(response.data);
  }
  return null;
}

/// 问答 上传答案
Future<bool> createAnswer({required num question, required String answer}) async {
  var data = {"question": question, "answer": answer};
  Response response = await DioClient().doPost('/ask/answer/create', data: data);
  return response.statusCode == 201;
}

/// 问答 添加问题
Future<bool> createQuestion({required num classification, required String question}) async {
  var data = {"classification": classification, "question": question};
  Response response = await DioClient().doPost('/ask/question/create', data: data);
  return response.statusCode == 201;
}

/// 问答 修改问题
Future<bool> updateQuestion(num id, {required num classification, required String question}) async {
  var data = {"classification": classification, "question": question};
  Response response = await DioClient().doPatch('/ask/question/partialUpdate/$id', data: data);
  return response.statusCode == 200;
}

/// 删除问题
Future<bool> deleteQuestion(num id) async {
  Response response = await DioClient().doDelete('/ask/question/delete/$id');
  return response.statusCode == 204;
}

/// 删除答案
Future<bool> deleteAnswer(num id) async {
  Response response = await DioClient().doDelete('/ask/answer/delete/$id');
  return response.statusCode == 204;
}
