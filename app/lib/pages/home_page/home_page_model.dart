import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';

class HomePageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  int? verseNo = 1;

  String? chapterName = '';

  String? verseText = '';

  String? commentaryBAbbas = '';

  String? commentaryZayd = '';

  String? commentaryBArabi = '';

  String? commentaryBAjiba = '';

  String? commentaryJilani = '';

  String? translation1 = '';

  String? translation2 = '';

  String? translation3 = '';

  String? translation4 = '';

  String? translation5 = '';

  String? translation6 = '';

  String? translation7 = '';

  String? translation8 = '';

  String? translation9 = '';

  String? translation10 = '';

  String? translation11 = '';

  String? translation12 = '';

  String? translation13 = '';

  String? translation14 = '';

  String? translation15 = '';

  String? translation16 = '';

  String? translation17 = '';

  List<String> chapterNames = [];
  void addToChapterNames(String item) => chapterNames.add(item);
  void removeFromChapterNames(String item) => chapterNames.remove(item);
  void removeAtIndexFromChapterNames(int index) => chapterNames.removeAt(index);
  void updateChapterNamesAtIndex(int index, Function(String) updateFn) =>
      chapterNames[index] = updateFn(chapterNames[index]);

  List<int> maxVerseNos = [];
  void addToMaxVerseNos(int item) => maxVerseNos.add(item);
  void removeFromMaxVerseNos(int item) => maxVerseNos.remove(item);
  void removeAtIndexFromMaxVerseNos(int index) => maxVerseNos.removeAt(index);
  void updateMaxVerseNosAtIndex(int index, Function(int) updateFn) =>
      maxVerseNos[index] = updateFn(maxVerseNos[index]);

  int? chapterNo = 1;

  int maxVerseNo = 1;

  double? progress;

  List<String> verseNames = [];
  void addToVerseNames(String item) => verseNames.add(item);
  void removeFromVerseNames(String item) => verseNames.remove(item);
  void removeAtIndexFromVerseNames(int index) => verseNames.removeAt(index);
  void updateVerseNamesAtIndex(int index, Function(String) updateFn) =>
      verseNames[index] = updateFn(verseNames[index]);

  dynamic jsonResponse;

  List<String> translations = [];
  void addToTranslations(String item) => translations.add(item);
  void removeFromTranslations(String item) => translations.remove(item);
  void removeAtIndexFromTranslations(int index) => translations.removeAt(index);
  void updateTranslationsAtIndex(int index, Function(String) updateFn) =>
      translations[index] = updateFn(translations[index]);

  List<String> similarVerses = [];
  void addToSimilarVerses(String item) => similarVerses.add(item);
  void removeFromSimilarVerses(String item) => similarVerses.remove(item);
  void removeAtIndexFromSimilarVerses(int index) =>
      similarVerses.removeAt(index);
  void updateSimilarVersesAtIndex(int index, Function(String) updateFn) =>
      similarVerses[index] = updateFn(similarVerses[index]);

  List<double> similarityScores = [];
  void addToSimilarityScores(double item) => similarityScores.add(item);
  void removeFromSimilarityScores(double item) => similarityScores.remove(item);
  void removeAtIndexFromSimilarityScores(int index) =>
      similarityScores.removeAt(index);
  void updateSimilarityScoresAtIndex(int index, Function(double) updateFn) =>
      similarityScores[index] = updateFn(similarityScores[index]);

  String dictionaryText = '';

  String previousTerm = '';

  String nextTerm = '';

  dynamic definitionJson;

  String commentaryBAbbasEnglish = '';

  String commentaryZaydEnglish = '';

  String commentaryJilaniEnglish = '';

  String commentaryBAjibaEnglish = '';

  String commentaryBArabiEnglish = '';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (getQuran)] action in HomePage widget.
  ApiCallResponse? response;
  // Stores action output result for [Backend Call - API (getChapters)] action in HomePage widget.
  ApiCallResponse? apiResultdes;
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (getDefinition)] action in TextField widget.
  ApiCallResponse? apiResultpxy;
  // Stores action output result for [Backend Call - API (getDefinition)] action in Text widget.
  ApiCallResponse? apiResultdbq;
  // Stores action output result for [Backend Call - API (getDefinition)] action in Text widget.
  ApiCallResponse? apiResultr7m;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for translationTab widget.
  TabController? translationTabController;
  int get translationTabCurrentIndex =>
      translationTabController != null ? translationTabController!.index : 0;

  // State field(s) for CommentaryTab widget.
  TabController? commentaryTabController;
  int get commentaryTabCurrentIndex =>
      commentaryTabController != null ? commentaryTabController!.index : 0;

  // State field(s) for LanguageSelector widget.
  bool? languageSelectorValue;
  // State field(s) for VerseSelector widget.
  String? verseSelectorValue;
  FormFieldController<String>? verseSelectorValueController;
  // Stores action output result for [Backend Call - API (getQuran)] action in VerseSelector widget.
  ApiCallResponse? responseTapped;
  // State field(s) for ChapterSelector widget.
  String? chapterSelectorValue;
  FormFieldController<String>? chapterSelectorValueController;
  // Stores action output result for [Backend Call - API (getQuran)] action in ChapterSelector widget.
  ApiCallResponse? response2;
  // Stores action output result for [Backend Call - API (getQuran)] action in ChapterSelector widget.
  ApiCallResponse? apiResultw6a;
  // Stores action output result for [Backend Call - API (getQuran)] action in RichText widget.
  ApiCallResponse? apiResulto4c;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
    translationTabController?.dispose();
    commentaryTabController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
