import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
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
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ShakeDetector shakeDetector;
  var shakeActionInProgress = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.response = await GetQuranCall.call(
        verse: _model.verseNo,
        chapter: _model.chapterNo,
      );
      if ((_model.response?.succeeded ?? true)) {
        setState(() {
          _model.jsonResponse = (_model.response?.jsonBody ?? '');
        });
        // ExtractJsonData
        setState(() {
          _model.chapterName = getJsonField(
            _model.jsonResponse,
            r'''$.chapter''',
          ).toString().toString();
          _model.verseText = getJsonField(
            _model.jsonResponse,
            r'''$.text''',
          ).toString().toString();
          _model.commentaryBAbbas = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[0].text''',
          ).toString().toString();
          _model.commentaryZayd = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[1].text''',
          ).toString().toString();
          _model.commentaryBArabi = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[2].text''',
          ).toString().toString();
          _model.commentaryBAjiba = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[4].text''',
          ).toString().toString();
          _model.commentaryJilani = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[3].text''',
          ).toString().toString();
          _model.translations = (getJsonField(
            _model.jsonResponse,
            r'''$.translations[:].translation''',
          ) as List)
              .map<String>((s) => s.toString())
              .toList()!
              .toList()
              .cast<String>();
          _model.similarVerses = (getJsonField(
            _model.jsonResponse,
            r'''$.most_similar_verses[:].verse''',
          ) as List)
              .map<String>((s) => s.toString())
              .toList()!
              .toList()
              .cast<String>();
          _model.similarityScores = getJsonField(
            _model.jsonResponse,
            r'''$.most_similar_verses[:].similarity''',
          )!
              .toList()
              .cast<double>();
          _model.commentatorNames = (getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[:].author''',
          ) as List)
              .map<String>((s) => s.toString())
              .toList()!
              .toList()
              .cast<String>();
          _model.allCommentaries = (getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[:].text''',
          ) as List)
              .map<String>((s) => s.toString())
              .toList()!
              .toList()
              .cast<String>();
        });
        // English Commentary Updates
        setState(() {
          _model.commentaryBAbbasEnglish = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[0].translations[0].translation''',
          ).toString().toString();
          _model.commentaryZaydEnglish = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[1].translations[0].translation''',
          ).toString().toString();
          _model.commentaryBArabiEnglish = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[2].translations[0].translation''',
          ).toString().toString();
          _model.commentaryJilaniEnglish = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[3].translations[0].translation''',
          ).toString().toString();
          _model.commentaryBAjibaEnglish = getJsonField(
            _model.jsonResponse,
            r'''$.commentaries[4].translations[0].translation''',
          ).toString().toString();
        });
      } else {
        return;
      }

      _model.apiResultdes = await GetChaptersCall.call();
      if ((_model.apiResultdes?.succeeded ?? true)) {
        // ExtractJsonMetadata
        setState(() {
          _model.chapterNames = (GetChaptersCall.chapterNames(
            (_model.apiResultdes?.jsonBody ?? ''),
          ) as List)
              .map<String>((s) => s.toString())
              .toList()!
              .toList()
              .cast<String>();
          _model.maxVerseNos = GetChaptersCall.maxVerseNo(
            (_model.apiResultdes?.jsonBody ?? ''),
          )!
              .toList()
              .cast<int>();
        });
        // UpdateDependentVariables
        setState(() {
          _model.maxVerseNo = (int indexChapter, List<int> totals) {
            return totals[indexChapter - 1];
          }(_model.chapterNo!, _model.maxVerseNos.toList());
          _model.progress = _model.verseNo! / _model.maxVerseNo;
          _model.verseNames = (int endIndex) {
            return List.generate(endIndex, (index) => (index + 1).toString());
          }(_model.maxVerseNo)
              .toList()
              .cast<String>();
        });
        // setAudioPath
        setState(() {
          _model.audioPaths = (getJsonField(
            _model.jsonResponse,
            r'''$.audio[:].path''',
          ) as List)
              .map<String>((s) => s.toString())
              .toList()!
              .toList()
              .cast<String>();
          _model.audioURL = functions.getAudioUrl(
              _model.recitationSelectorValue, _model.audioPaths.toList());
        });
      } else {
        return;
      }
    });

    // On shake action.
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () async {
        if (shakeActionInProgress) {
          return;
        }
        shakeActionInProgress = true;
        try {
          scaffoldKey.currentState!.openEndDrawer();
        } finally {
          shakeActionInProgress = false;
        }
      },
      shakeThresholdGravity: 1.5,
    );

    _model.translationTabController = TabController(
      vsync: this,
      length: 18,
      initialIndex: 0,
    );
    _model.commentaryTabController = TabController(
      vsync: this,
      length: 5,
      initialIndex: 0,
    );
    _model.textController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        drawer: Container(
          width: 250.0,
          child: Drawer(
            elevation: 16.0,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'ﷺ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).success,
                          fontSize: 20.0,
                        ),
                  ),
                  Container(
                    width: 120.0,
                    height: 120.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/sandala.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Commentary',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context).success,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text: _model.commentatorNames[
                              _model.commentaryTabCurrentIndex],
                          style: TextStyle(),
                        )
                      ],
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                  AutoSizeText(
                    _model.allCommentaries[_model.commentaryTabCurrentIndex],
                    textAlign: TextAlign.end,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).success,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        endDrawer: Container(
          width: 200.0,
          child: Drawer(
            elevation: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ﷺ',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).warning,
                        fontSize: 20.0,
                      ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: CircularPercentIndicator(
                    percent: _model.progress!,
                    radius: 25.0,
                    lineWidth: 10.0,
                    animation: true,
                    progressColor: FlutterFlowTheme.of(context).warning,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    center: Text(
                      (double percent) {
                        return "${(percent * 100).toInt()}%";
                      }(_model.progress!),
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                fontSize: 15.0,
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      var _shouldSetState = false;
                      setState(() {
                        _model.verseNo = (String mostSimilar) {
                          return int.parse(mostSimilar.split(":")[1]);
                        }(_model.similarVerses.first);
                        _model.chapterNo = (String mostSimilar) {
                          return int.parse(mostSimilar.split(":")[0]);
                        }(_model.similarVerses.first);
                        _model.chapterName =
                            _model.chapterNames[_model.chapterNo! - 1];
                      });
                      setState(() {
                        _model.chapterSelectorValueController?.value =
                            _model.chapterName!;
                      });
                      setState(() {
                        _model.maxVerseNo =
                            _model.maxVerseNos[_model.chapterNo!];
                      });
                      setState(() {
                        _model.verseSelectorValueController?.value =
                            _model.verseNo!.toString();
                      });
                      _model.apiResulto4c1 = await GetQuranCall.call(
                        chapter: _model.chapterNo,
                        verse: _model.verseNo,
                      );
                      _shouldSetState = true;
                      if ((_model.apiResulto4c1?.succeeded ?? true)) {
                        setState(() {
                          _model.jsonResponse =
                              (_model.apiResulto4c1?.jsonBody ?? '');
                        });
                      } else {
                        if (_shouldSetState) setState(() {});
                        return;
                      }

                      // ExtractJsonData
                      setState(() {
                        _model.chapterName = getJsonField(
                          _model.jsonResponse,
                          r'''$.chapter''',
                        ).toString();
                        _model.verseText = getJsonField(
                          _model.jsonResponse,
                          r'''$.text''',
                        ).toString();
                        _model.commentaryBAbbas = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[0].text''',
                        ).toString();
                        _model.commentaryZayd = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[1].text''',
                        ).toString();
                        _model.commentaryBArabi = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[2].text''',
                        ).toString();
                        _model.commentaryBAjiba = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[4].text''',
                        ).toString();
                        _model.commentaryJilani = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[3].text''',
                        ).toString();
                        _model.translations = (getJsonField(
                          _model.jsonResponse,
                          r'''$.translations[:].translation''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.similarVerses = (getJsonField(
                          _model.jsonResponse,
                          r'''$.most_similar_verses[:].verse''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.similarityScores = getJsonField(
                          _model.jsonResponse,
                          r'''$.most_similar_verses[:].similarity''',
                        )!
                            .toList()
                            .cast<double>();
                        _model.commentatorNames = (getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[:].author''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.allCommentaries = (getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[:].text''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                      });
                      // English Commentary Updates
                      setState(() {
                        _model.commentaryBAbbasEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[0].translations[0].translation''',
                        ).toString();
                        _model.commentaryZaydEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[1].translations[0].translation''',
                        ).toString();
                        _model.commentaryBArabiEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[2].translations[0].translation''',
                        ).toString();
                        _model.commentaryJilaniEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[3].translations[0].translation''',
                        ).toString();
                        _model.commentaryBAjibaEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[4].translations[0].translation''',
                        ).toString();
                      });
                      // UpdateDependentVariables
                      setState(() {
                        _model.maxVerseNo =
                            (int indexChapter, List<int> totals) {
                          return totals[indexChapter - 1];
                        }(_model.chapterNo!, _model.maxVerseNos.toList());
                        _model.progress = _model.verseNo! / _model.maxVerseNo;
                        _model.verseNames = (int endIndex) {
                          return List.generate(
                              endIndex, (index) => (index + 1).toString());
                        }(_model.maxVerseNo)
                            .toList()
                            .cast<String>();
                      });
                      // setAudioPath
                      setState(() {
                        _model.audioPaths = (getJsonField(
                          _model.jsonResponse,
                          r'''$.audio[:].path''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.audioURL = functions.getAudioUrl(
                            _model.recitationSelectorValue,
                            _model.audioPaths.toList());
                      });
                      if (scaffoldKey.currentState!.isDrawerOpen ||
                          scaffoldKey.currentState!.isEndDrawerOpen) {
                        Navigator.pop(context);
                      }

                      if (_shouldSetState) setState(() {});
                    },
                    child: GradientText(
                      (int chapter, int verse) {
                        return "Verses similar to ${chapter}:${verse}";
                      }(_model.chapterNo!, _model.verseNo!),
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).secondary,
                            fontSize: 20.0,
                          ),
                      colors: [
                        FlutterFlowTheme.of(context).secondary,
                        FlutterFlowTheme.of(context).error
                      ],
                      gradientDirection: GradientDirection.ltr,
                      gradientType: GradientType.linear,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      var _shouldSetState = false;
                      setState(() {
                        _model.verseNo = (String mostSimilar) {
                          return int.parse(mostSimilar.split(":")[1]);
                        }(_model.similarVerses.first);
                        _model.chapterNo = (String mostSimilar) {
                          return int.parse(mostSimilar.split(":")[0]);
                        }(_model.similarVerses.first);
                        _model.chapterName =
                            _model.chapterNames[_model.chapterNo! - 1];
                      });
                      setState(() {
                        _model.chapterSelectorValueController?.value =
                            _model.chapterName!;
                      });
                      setState(() {
                        _model.maxVerseNo =
                            _model.maxVerseNos[_model.chapterNo!];
                      });
                      setState(() {
                        _model.verseSelectorValueController?.value =
                            _model.verseNo!.toString();
                      });
                      _model.apiResulto4c2 = await GetQuranCall.call(
                        chapter: _model.chapterNo,
                        verse: _model.verseNo,
                      );
                      _shouldSetState = true;
                      if ((_model.apiResulto4c2?.succeeded ?? true)) {
                        setState(() {
                          _model.jsonResponse =
                              (_model.apiResulto4c2?.jsonBody ?? '');
                        });
                      } else {
                        if (_shouldSetState) setState(() {});
                        return;
                      }

                      // ExtractJsonData
                      setState(() {
                        _model.chapterName = getJsonField(
                          _model.jsonResponse,
                          r'''$.chapter''',
                        ).toString();
                        _model.verseText = getJsonField(
                          _model.jsonResponse,
                          r'''$.text''',
                        ).toString();
                        _model.commentaryBAbbas = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[0].text''',
                        ).toString();
                        _model.commentaryZayd = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[1].text''',
                        ).toString();
                        _model.commentaryBArabi = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[2].text''',
                        ).toString();
                        _model.commentaryBAjiba = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[4].text''',
                        ).toString();
                        _model.commentaryJilani = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[3].text''',
                        ).toString();
                        _model.translations = (getJsonField(
                          _model.jsonResponse,
                          r'''$.translations[:].translation''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.similarVerses = (getJsonField(
                          _model.jsonResponse,
                          r'''$.most_similar_verses[:].verse''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.similarityScores = getJsonField(
                          _model.jsonResponse,
                          r'''$.most_similar_verses[:].similarity''',
                        )!
                            .toList()
                            .cast<double>();
                        _model.commentatorNames = (getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[:].author''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.allCommentaries = (getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[:].text''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                      });
                      // English Commentary Updates
                      setState(() {
                        _model.commentaryBAbbasEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[0].translations[0].translation''',
                        ).toString();
                        _model.commentaryZaydEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[1].translations[0].translation''',
                        ).toString();
                        _model.commentaryBArabiEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[2].translations[0].translation''',
                        ).toString();
                        _model.commentaryJilaniEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[3].translations[0].translation''',
                        ).toString();
                        _model.commentaryBAjibaEnglish = getJsonField(
                          _model.jsonResponse,
                          r'''$.commentaries[4].translations[0].translation''',
                        ).toString();
                      });
                      // UpdateDependentVariables
                      setState(() {
                        _model.maxVerseNo =
                            (int indexChapter, List<int> totals) {
                          return totals[indexChapter - 1];
                        }(_model.chapterNo!, _model.maxVerseNos.toList());
                        _model.progress = _model.verseNo! / _model.maxVerseNo;
                        _model.verseNames = (int endIndex) {
                          return List.generate(
                              endIndex, (index) => (index + 1).toString());
                        }(_model.maxVerseNo)
                            .toList()
                            .cast<String>();
                      });
                      // setAudioPath
                      setState(() {
                        _model.audioPaths = (getJsonField(
                          _model.jsonResponse,
                          r'''$.audio[:].path''',
                        ) as List)
                            .map<String>((s) => s.toString())
                            .toList()!
                            .toList()
                            .cast<String>();
                        _model.audioURL = functions.getAudioUrl(
                            _model.recitationSelectorValue,
                            _model.audioPaths.toList());
                      });
                      if (scaffoldKey.currentState!.isDrawerOpen ||
                          scaffoldKey.currentState!.isEndDrawerOpen) {
                        Navigator.pop(context);
                      }

                      if (_shouldSetState) setState(() {});
                    },
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowBarChart(
                        barData: [
                          FFBarChartData(
                            yData: _model.similarityScores,
                            color: FlutterFlowTheme.of(context).secondary,
                          )
                        ],
                        xLabels: _model.similarVerses,
                        barWidth: 16.0,
                        barBorderRadius: BorderRadius.circular(8.0),
                        groupSpace: 8.0,
                        chartStylingInfo: ChartStylingInfo(
                          backgroundColor: FlutterFlowTheme.of(context).info,
                          showBorder: false,
                        ),
                        axisBounds: AxisBounds(),
                        xAxisLabelInfo: AxisLabelInfo(
                          showLabels: true,
                          labelTextStyle: TextStyle(
                            color: FlutterFlowTheme.of(context).secondary,
                            fontWeight: FontWeight.w300,
                            fontSize: 7.0,
                          ),
                          labelInterval: 10.0,
                        ),
                        yAxisLabelInfo: AxisLabelInfo(
                          title: 'Similarity',
                          titleTextStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          showLabels: true,
                          labelTextStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 8.0,
                          ),
                          labelInterval: 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).accent4,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Dictionary',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).success,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        text: 'Hans Wehr',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: TextFormField(
                    controller: _model.textController,
                    onFieldSubmitted: (_) async {
                      _model.apiResultpxy = await GetDefinitionCall.call(
                        word: _model.textController.text,
                      );
                      if ((_model.apiResultpxy?.succeeded ?? true)) {
                        setState(() {
                          _model.definitionJson =
                              (_model.apiResultpxy?.jsonBody ?? '');
                        });
                        // Extract Definition Json
                        setState(() {
                          _model.dictionaryText = getJsonField(
                            _model.definitionJson,
                            r'''$.definition''',
                          ).toString();
                          _model.previousTerm = getJsonField(
                            _model.definitionJson,
                            r'''$.previous_term''',
                          ).toString();
                          _model.nextTerm = getJsonField(
                            _model.definitionJson,
                            r'''$.next_term''',
                          ).toString();
                        });
                      } else {
                        // No Definition Found
                        setState(() {
                          _model.dictionaryText = 'No definition found';
                        });
                      }

                      setState(() {});
                    },
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                      hintText: 'Search term',
                      hintStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).warning,
                              ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).warning,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).warning,
                        ),
                    textAlign: TextAlign.end,
                    validator:
                        _model.textControllerValidator.asValidator(context),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        var _shouldSetState = false;
                        _model.apiResultdbq = await GetDefinitionCall.call(
                          word: _model.previousTerm,
                        );
                        _shouldSetState = true;
                        if ((_model.apiResultdbq?.succeeded ?? true)) {
                          setState(() {
                            _model.definitionJson =
                                (_model.apiResultdbq?.jsonBody ?? '');
                          });
                          // Extract Definition Json
                          setState(() {
                            _model.dictionaryText = getJsonField(
                              _model.definitionJson,
                              r'''$.definition''',
                            ).toString();
                            _model.previousTerm = getJsonField(
                              _model.definitionJson,
                              r'''$.previous_term''',
                            ).toString();
                            _model.nextTerm = getJsonField(
                              _model.definitionJson,
                              r'''$.next_term''',
                            ).toString();
                          });
                        } else {
                          // No Definition Found
                          setState(() {
                            _model.dictionaryText = 'No definition found';
                          });
                          if (_shouldSetState) setState(() {});
                          return;
                        }

                        if (_shouldSetState) setState(() {});
                      },
                      child: Text(
                        _model.previousTerm,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        var _shouldSetState = false;
                        _model.apiResultr7m = await GetDefinitionCall.call(
                          word: _model.nextTerm,
                        );
                        _shouldSetState = true;
                        if ((_model.apiResultr7m?.succeeded ?? true)) {
                          setState(() {
                            _model.definitionJson =
                                (_model.apiResultr7m?.jsonBody ?? '');
                          });
                          // Extract Definition Json
                          setState(() {
                            _model.dictionaryText = getJsonField(
                              _model.definitionJson,
                              r'''$.definition''',
                            ).toString();
                            _model.previousTerm = getJsonField(
                              _model.definitionJson,
                              r'''$.previous_term''',
                            ).toString();
                            _model.nextTerm = getJsonField(
                              _model.definitionJson,
                              r'''$.next_term''',
                            ).toString();
                          });
                        } else {
                          // No Definition Found
                          setState(() {
                            _model.dictionaryText = 'No definition found';
                          });
                          if (_shouldSetState) setState(() {});
                          return;
                        }

                        if (_shouldSetState) setState(() {});
                      },
                      child: Text(
                        _model.nextTerm,
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                      ),
                    ),
                  ],
                ),
                SelectionArea(
                    child: AutoSizeText(
                  _model.dictionaryText,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).success,
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                      ),
                  minFontSize: 5.0,
                )),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).success,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Container(
              width: 120.0,
              height: 120.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/sandala.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _model.chapterName!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: valueOrDefault<String>(
                      _model.verseNo?.toString(),
                      '1',
                    ),
                    style: TextStyle(),
                  )
                ],
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          actions: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                scaffoldKey.currentState!.openEndDrawer();
              },
              child: CircularPercentIndicator(
                percent: _model.progress!,
                radius: 25.0,
                lineWidth: 10.0,
                animation: true,
                progressColor: FlutterFlowTheme.of(context).warning,
                backgroundColor: FlutterFlowTheme.of(context).accent4,
                center: Text(
                  (double percent) {
                    return "${(percent * 100).toInt()}%";
                  }(_model.progress!),
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Outfit',
                        fontSize: 15.0,
                      ),
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 500.0,
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                        child: PageView(
                          controller: _model.pageViewController ??=
                              PageController(initialPage: 0),
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.asset(
                                    'assets/images/parchment.jpeg',
                                  ).image,
                                ),
                                shape: BoxShape.rectangle,
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: SelectionArea(
                                        child: AutoSizeText(
                                      _model.verseText!,
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: TabBarView(
                                      controller:
                                          _model.translationTabController,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[0],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[1],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[2],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[3],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[4],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[5],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[6],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[7],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[8],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[9],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[10],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[11],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[12],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[13],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[14],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[15],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[16],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.translations[17],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 32.0,
                                                ),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.0, 0),
                                    child: FlutterFlowButtonTabBar(
                                      useToggleButtonStyle: false,
                                      isScrollable: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleMedium,
                                      unselectedLabelStyle: TextStyle(),
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      unselectedLabelColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).warning,
                                      unselectedBackgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      borderColor:
                                          FlutterFlowTheme.of(context).warning,
                                      unselectedBorderColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      borderWidth: 2.0,
                                      borderRadius: 8.0,
                                      elevation: 0.0,
                                      buttonMargin:
                                          EdgeInsetsDirectional.fromSTEB(
                                              8.0, 0.0, 8.0, 0.0),
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 4.0, 4.0, 4.0),
                                      tabs: [
                                        Tab(
                                          text: '1',
                                        ),
                                        Tab(
                                          text: '2',
                                        ),
                                        Tab(
                                          text: '3',
                                        ),
                                        Tab(
                                          text: '4',
                                        ),
                                        Tab(
                                          text: '5',
                                        ),
                                        Tab(
                                          text: '6',
                                        ),
                                        Tab(
                                          text: '7',
                                        ),
                                        Tab(
                                          text: '8',
                                        ),
                                        Tab(
                                          text: '9',
                                        ),
                                        Tab(
                                          text: '10',
                                        ),
                                        Tab(
                                          text: '11',
                                        ),
                                        Tab(
                                          text: '12',
                                        ),
                                        Tab(
                                          text: '13',
                                        ),
                                        Tab(
                                          text: '14',
                                        ),
                                        Tab(
                                          text: '15',
                                        ),
                                        Tab(
                                          text: '16',
                                        ),
                                        Tab(
                                          text: '17',
                                        ),
                                        Tab(
                                          text: '18',
                                        ),
                                      ],
                                      controller:
                                          _model.translationTabController,
                                      onTap: (value) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: TabBarView(
                                          controller:
                                              _model.commentaryTabController,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            KeepAliveWidgetWrapper(
                                              builder: (context) =>
                                                  SelectionArea(
                                                      child: AutoSizeText(
                                                valueOrDefault<String>(
                                                  _model.languageSelectorValue!
                                                      ? _model
                                                          .commentaryBAbbasEnglish
                                                      : _model.commentaryBAbbas,
                                                  '\'\'',
                                                ),
                                                textAlign: TextAlign.end,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                              )),
                                            ),
                                            KeepAliveWidgetWrapper(
                                              builder: (context) =>
                                                  SelectionArea(
                                                      child: AutoSizeText(
                                                valueOrDefault<String>(
                                                  _model.languageSelectorValue!
                                                      ? _model
                                                          .commentaryZaydEnglish
                                                      : _model.commentaryZayd,
                                                  '\'\'',
                                                ),
                                                textAlign: TextAlign.end,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                              )),
                                            ),
                                            KeepAliveWidgetWrapper(
                                              builder: (context) =>
                                                  SelectionArea(
                                                      child: AutoSizeText(
                                                valueOrDefault<String>(
                                                  _model.languageSelectorValue!
                                                      ? _model
                                                          .commentaryBArabiEnglish
                                                      : _model.commentaryBArabi,
                                                  '\'\'',
                                                ),
                                                textAlign: TextAlign.end,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                              )),
                                            ),
                                            KeepAliveWidgetWrapper(
                                              builder: (context) =>
                                                  SelectionArea(
                                                      child: AutoSizeText(
                                                valueOrDefault<String>(
                                                  _model.languageSelectorValue!
                                                      ? _model
                                                          .commentaryJilaniEnglish
                                                      : _model.commentaryJilani,
                                                  '\'\'',
                                                ),
                                                textAlign: TextAlign.end,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                              )),
                                            ),
                                            KeepAliveWidgetWrapper(
                                              builder: (context) =>
                                                  SelectionArea(
                                                      child: AutoSizeText(
                                                valueOrDefault<String>(
                                                  _model.languageSelectorValue!
                                                      ? _model
                                                          .commentaryBAjibaEnglish
                                                      : _model.commentaryBAjiba,
                                                  '\'\'',
                                                ),
                                                textAlign: TextAlign.end,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(0.0, 0),
                                        child: TabBar(
                                          isScrollable: true,
                                          labelColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          unselectedLabelColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium,
                                          unselectedLabelStyle: TextStyle(),
                                          indicatorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 4.0, 4.0, 4.0),
                                          tabs: [
                                            Tab(
                                              text: 'ابن عباس',
                                            ),
                                            Tab(
                                              text: 'زيد بن علي',
                                            ),
                                            Tab(
                                              text: 'ابن عربي',
                                            ),
                                            Tab(
                                              text: 'الجيلاني',
                                            ),
                                            Tab(
                                              text: 'ابن عجيبة',
                                            ),
                                          ],
                                          controller:
                                              _model.commentaryTabController,
                                          onTap: (value) => setState(() {}),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-0.99, 0.8),
                                    child: Switch.adaptive(
                                      value: _model.languageSelectorValue ??=
                                          true,
                                      onChanged: (newValue) async {
                                        setState(() => _model
                                            .languageSelectorValue = newValue!);
                                      },
                                      activeColor:
                                          FlutterFlowTheme.of(context).info,
                                      activeTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      inactiveTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      inactiveThumbColor:
                                          FlutterFlowTheme.of(context).info,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 16.0),
                          child: smooth_page_indicator.SmoothPageIndicator(
                            controller: _model.pageViewController ??=
                                PageController(initialPage: 0),
                            count: 3,
                            axisDirection: Axis.horizontal,
                            onDotClicked: (i) async {
                              await _model.pageViewController!.animateToPage(
                                i,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            effect: smooth_page_indicator.ExpandingDotsEffect(
                              expansionFactor: 3.0,
                              spacing: 8.0,
                              radius: 16.0,
                              dotWidth: 16.0,
                              dotHeight: 8.0,
                              dotColor: FlutterFlowTheme.of(context).success,
                              activeDotColor:
                                  FlutterFlowTheme.of(context).warning,
                              paintStyle: PaintingStyle.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FlutterFlowAudioPlayer(
                audio: Audio.network(
                  _model.audioURL!,
                  metas: Metas(
                    id: '2vqf7_-c5d15a21',
                    title: _model.chapterName! + _model.verseNo.toString(),
                  ),
                ),
                titleTextStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w100,
                    ),
                playbackDurationTextStyle:
                    FlutterFlowTheme.of(context).labelMedium,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                playbackButtonColor: FlutterFlowTheme.of(context).success,
                activeTrackColor: FlutterFlowTheme.of(context).alternate,
                elevation: 4.0,
                playInBackground: PlayInBackground.disabledPause,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 81.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/parchment.jpeg',
                    ).image,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FlutterFlowDropDown<String>(
                      controller: _model.recitationSelectorValueController ??=
                          FormFieldController<String>(null),
                      options: ['حفص', 'ورش', 'خلف عن حمزة'],
                      onChanged: (val) async {
                        setState(() => _model.recitationSelectorValue =
                            val); // setAudioPath
                        setState(() {
                          _model.audioPaths = (getJsonField(
                            _model.jsonResponse,
                            r'''$.audio[:].path''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.audioURL = functions.getAudioUrl(
                              _model.recitationSelectorValue,
                              _model.audioPaths.toList());
                        });
                      },
                      width: 80.0,
                      height: 50.0,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w200,
                              ),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                    FlutterFlowDropDown<String>(
                      controller: _model.verseSelectorValueController ??=
                          FormFieldController<String>(
                        _model.verseSelectorValue ??= '1',
                      ),
                      options: _model.verseNames,
                      onChanged: (val) async {
                        setState(() => _model.verseSelectorValue = val);
                        var _shouldSetState = false;
                        setState(() {
                          _model.verseNo =
                              int.parse(_model.verseSelectorValue!);
                        });
                        _model.responseTapped = await GetQuranCall.call(
                          chapter: _model.chapterNo,
                          verse: _model.verseNo,
                        );
                        _shouldSetState = true;
                        if ((_model.responseTapped?.succeeded ?? true)) {
                          setState(() {
                            _model.jsonResponse =
                                (_model.responseTapped?.jsonBody ?? '');
                          });
                        } else {
                          if (_shouldSetState) setState(() {});
                          return;
                        }

                        // ExtractJsonData
                        setState(() {
                          _model.chapterName = getJsonField(
                            _model.jsonResponse,
                            r'''$.chapter''',
                          ).toString();
                          _model.verseText = getJsonField(
                            _model.jsonResponse,
                            r'''$.text''',
                          ).toString();
                          _model.commentaryBAbbas = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[0].text''',
                          ).toString();
                          _model.commentaryZayd = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[1].text''',
                          ).toString();
                          _model.commentaryBArabi = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[2].text''',
                          ).toString();
                          _model.commentaryBAjiba = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[4].text''',
                          ).toString();
                          _model.commentaryJilani = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[3].text''',
                          ).toString();
                          _model.translations = (getJsonField(
                            _model.jsonResponse,
                            r'''$.translations[:].translation''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.similarVerses = (getJsonField(
                            _model.jsonResponse,
                            r'''$.most_similar_verses[:].verse''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.similarityScores = getJsonField(
                            _model.jsonResponse,
                            r'''$.most_similar_verses[:].similarity''',
                          )!
                              .toList()
                              .cast<double>();
                          _model.commentatorNames = (getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[:].author''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.allCommentaries = (getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[:].text''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                        });
                        // English Commentary Updates
                        setState(() {
                          _model.commentaryBAbbasEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[0].translations[0].translation''',
                          ).toString();
                          _model.commentaryZaydEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[1].translations[0].translation''',
                          ).toString();
                          _model.commentaryBArabiEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[2].translations[0].translation''',
                          ).toString();
                          _model.commentaryJilaniEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[3].translations[0].translation''',
                          ).toString();
                          _model.commentaryBAjibaEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[4].translations[0].translation''',
                          ).toString();
                        });
                        // UpdateDependentVariables
                        setState(() {
                          _model.maxVerseNo =
                              (int indexChapter, List<int> totals) {
                            return totals[indexChapter - 1];
                          }(_model.chapterNo!, _model.maxVerseNos.toList());
                          _model.progress = _model.verseNo! / _model.maxVerseNo;
                          _model.verseNames = (int endIndex) {
                            return List.generate(
                                endIndex, (index) => (index + 1).toString());
                          }(_model.maxVerseNo)
                              .toList()
                              .cast<String>();
                        });
                        // setAudioPath
                        setState(() {
                          _model.audioPaths = (getJsonField(
                            _model.jsonResponse,
                            r'''$.audio[:].path''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.audioURL = functions.getAudioUrl(
                              _model.recitationSelectorValue,
                              _model.audioPaths.toList());
                        });
                        if (_shouldSetState) setState(() {});
                      },
                      width: 113.0,
                      height: 50.0,
                      searchHintTextStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 10.0,
                              ),
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 10.0,
                              ),
                      searchHintText: 'Search Verse...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: true,
                      isMultiSelect: false,
                    ),
                    FlutterFlowDropDown<String>(
                      controller: _model.chapterSelectorValueController ??=
                          FormFieldController<String>(
                        _model.chapterSelectorValue ??= _model.chapterName,
                      ),
                      options: _model.chapterNames,
                      onChanged: (val) async {
                        setState(() => _model.chapterSelectorValue = val);
                        var _shouldSetState = false;
                        setState(() {
                          _model.chapterNo = valueOrDefault<int>(
                            (String? chosenChapterName,
                                    List<String> allChapterNames) {
                              return allChapterNames
                                      .indexOf(chosenChapterName ?? '') +
                                  1;
                            }(_model.chapterSelectorValue,
                                _model.chapterNames.toList()),
                            1,
                          );
                        });
                        _model.response2 = await GetQuranCall.call(
                          chapter: _model.chapterNo,
                          verse: _model.verseNo,
                        );
                        _shouldSetState = true;
                        if ((_model.response2?.succeeded ?? true)) {
                          setState(() {
                            _model.jsonResponse =
                                (_model.response2?.jsonBody ?? '');
                          });
                        } else {
                          setState(() {
                            _model.verseNo = 1;
                          });
                          _model.apiResultw6a = await GetQuranCall.call(
                            chapter: _model.chapterNo,
                            verse: _model.verseNo,
                          );
                          _shouldSetState = true;
                          if ((_model.apiResultw6a?.succeeded ?? true)) {
                            setState(() {
                              _model.jsonResponse =
                                  (_model.apiResultw6a?.jsonBody ?? '');
                            });
                          } else {
                            if (_shouldSetState) setState(() {});
                            return;
                          }
                        }

                        // ExtractJsonData
                        setState(() {
                          _model.chapterName = getJsonField(
                            _model.jsonResponse,
                            r'''$.chapter''',
                          ).toString();
                          _model.verseText = getJsonField(
                            _model.jsonResponse,
                            r'''$.text''',
                          ).toString();
                          _model.commentaryBAbbas = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[0].text''',
                          ).toString();
                          _model.commentaryZayd = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[1].text''',
                          ).toString();
                          _model.commentaryBArabi = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[2].text''',
                          ).toString();
                          _model.commentaryBAjiba = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[4].text''',
                          ).toString();
                          _model.commentaryJilani = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[3].text''',
                          ).toString();
                          _model.translations = (getJsonField(
                            _model.jsonResponse,
                            r'''$.translations[:].translation''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.similarVerses = (getJsonField(
                            _model.jsonResponse,
                            r'''$.most_similar_verses[:].verse''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.similarityScores = getJsonField(
                            _model.jsonResponse,
                            r'''$.most_similar_verses[:].similarity''',
                          )!
                              .toList()
                              .cast<double>();
                          _model.commentatorNames = (getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[:].author''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.allCommentaries = (getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[:].text''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                        });
                        // English Commentary Updates
                        setState(() {
                          _model.commentaryBAbbasEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[0].translations[0].translation''',
                          ).toString();
                          _model.commentaryZaydEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[1].translations[0].translation''',
                          ).toString();
                          _model.commentaryBArabiEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[2].translations[0].translation''',
                          ).toString();
                          _model.commentaryJilaniEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[3].translations[0].translation''',
                          ).toString();
                          _model.commentaryBAjibaEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[4].translations[0].translation''',
                          ).toString();
                        });
                        // UpdateDependentVariables
                        setState(() {
                          _model.maxVerseNo =
                              (int indexChapter, List<int> totals) {
                            return totals[indexChapter - 1];
                          }(_model.chapterNo!, _model.maxVerseNos.toList());
                          _model.progress = _model.verseNo! / _model.maxVerseNo;
                          _model.verseNames = (int endIndex) {
                            return List.generate(
                                endIndex, (index) => (index + 1).toString());
                          }(_model.maxVerseNo)
                              .toList()
                              .cast<String>();
                        });
                        // setAudioPath
                        setState(() {
                          _model.audioPaths = (getJsonField(
                            _model.jsonResponse,
                            r'''$.audio[:].path''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.audioURL = functions.getAudioUrl(
                              _model.recitationSelectorValue,
                              _model.audioPaths.toList());
                        });
                        if (_shouldSetState) setState(() {});
                      },
                      width: 159.0,
                      height: 50.0,
                      searchHintTextStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w100,
                              ),
                      searchHintText: 'Search Chapter...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: true,
                      isMultiSelect: false,
                    ),
                    FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 50.0,
                      fillColor: FlutterFlowTheme.of(context).info,
                      icon: Icon(
                        Icons.navigate_next_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        var _shouldSetState = false;
                        // incrementChapter
                        setState(() {
                          _model.chapterNo = (int verseIndex, int maxVerseIndex,
                                  int chapterIndex) {
                            return verseIndex < maxVerseIndex
                                ? chapterIndex
                                : math.min(chapterIndex + 1, 114);
                          }(_model.verseNo!, _model.maxVerseNo,
                              _model.chapterNo!);
                          _model.chapterName =
                              _model.chapterNames[_model.chapterNo! - 1];
                        });
                        // incrementVerse
                        setState(() {
                          _model.verseNo = (int verseIndex, int maxVerseIndex) {
                            return verseIndex < maxVerseIndex
                                ? verseIndex + 1
                                : 1;
                          }(_model.verseNo!, _model.maxVerseNo);
                        });
                        setState(() {
                          _model.verseSelectorValueController?.value =
                              _model.verseNo!.toString();
                        });
                        setState(() {
                          _model.chapterSelectorValueController?.value =
                              _model.chapterName!;
                        });
                        _model.apiResultz75 = await GetQuranCall.call(
                          chapter: _model.chapterNo,
                          verse: _model.verseNo,
                        );
                        _shouldSetState = true;
                        if ((_model.apiResultz75?.succeeded ?? true)) {
                          setState(() {
                            _model.jsonResponse =
                                (_model.apiResultz75?.jsonBody ?? '');
                          });
                        } else {
                          if (_shouldSetState) setState(() {});
                          return;
                        }

                        // ExtractJsonData
                        setState(() {
                          _model.chapterName = getJsonField(
                            _model.jsonResponse,
                            r'''$.chapter''',
                          ).toString();
                          _model.verseText = getJsonField(
                            _model.jsonResponse,
                            r'''$.text''',
                          ).toString();
                          _model.commentaryBAbbas = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[0].text''',
                          ).toString();
                          _model.commentaryZayd = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[1].text''',
                          ).toString();
                          _model.commentaryBArabi = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[2].text''',
                          ).toString();
                          _model.commentaryBAjiba = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[4].text''',
                          ).toString();
                          _model.commentaryJilani = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[3].text''',
                          ).toString();
                          _model.translations = (getJsonField(
                            _model.jsonResponse,
                            r'''$.translations[:].translation''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.similarVerses = (getJsonField(
                            _model.jsonResponse,
                            r'''$.most_similar_verses[:].verse''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.similarityScores = getJsonField(
                            _model.jsonResponse,
                            r'''$.most_similar_verses[:].similarity''',
                          )!
                              .toList()
                              .cast<double>();
                          _model.commentatorNames = (getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[:].author''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.allCommentaries = (getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[:].text''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                        });
                        // English Commentary Updates
                        setState(() {
                          _model.commentaryBAbbasEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[0].translations[0].translation''',
                          ).toString();
                          _model.commentaryZaydEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[1].translations[0].translation''',
                          ).toString();
                          _model.commentaryBArabiEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[2].translations[0].translation''',
                          ).toString();
                          _model.commentaryJilaniEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[3].translations[0].translation''',
                          ).toString();
                          _model.commentaryBAjibaEnglish = getJsonField(
                            _model.jsonResponse,
                            r'''$.commentaries[4].translations[0].translation''',
                          ).toString();
                        });
                        // UpdateDependentVariables
                        setState(() {
                          _model.maxVerseNo =
                              (int indexChapter, List<int> totals) {
                            return totals[indexChapter - 1];
                          }(_model.chapterNo!, _model.maxVerseNos.toList());
                          _model.progress = _model.verseNo! / _model.maxVerseNo;
                          _model.verseNames = (int endIndex) {
                            return List.generate(
                                endIndex, (index) => (index + 1).toString());
                          }(_model.maxVerseNo)
                              .toList()
                              .cast<String>();
                        });
                        // setAudioPath
                        setState(() {
                          _model.audioPaths = (getJsonField(
                            _model.jsonResponse,
                            r'''$.audio[:].path''',
                          ) as List)
                              .map<String>((s) => s.toString())
                              .toList()!
                              .toList()
                              .cast<String>();
                          _model.audioURL = functions.getAudioUrl(
                              _model.recitationSelectorValue,
                              _model.audioPaths.toList());
                        });
                        if (_shouldSetState) setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
