import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/topic_article.dart';
import 'package:frontend/data/model/topic.dart';

class TopicArticleController extends ChangeNotifier {
  final TopicArticleApi service = TopicArticleApi();
  List<Topic> listTopic = [];

  Future<void> getTopics(BuildContext context) async {
    try {
      final response = await service.getTopics();
      final resultList = response['result'] as List;

      listTopic = resultList.map((e) => Topic.fromJson(e)).toList();
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }
}
