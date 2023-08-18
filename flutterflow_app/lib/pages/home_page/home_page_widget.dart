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
            r'''$.commentaries[0].translations[0].translation''',
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
      } else {
        return;
      }
    });

    _model.translationTabController = TabController(
      vsync: this,
      length: 17,
      initialIndex: 0,
    );
    _model.commentaryTabController = TabController(
      vsync: this,
      length: 5,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).success,
          automaticallyImplyLeading: false,
          leading: CircularPercentIndicator(
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
            Container(
              width: 120.0,
              height: 120.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/sandala.jpeg',
                fit: BoxFit.scaleDown,
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
                              child: Align(
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
                              child: Column(
                                children: [
                                  Expanded(
                                    child: TabBarView(
                                      controller:
                                          _model.commentaryTabController,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.commentaryBAbbas!,
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.commentaryZayd!,
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.commentaryBArabi!,
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.commentaryJilani!,
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                          )),
                                        ),
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => SelectionArea(
                                              child: AutoSizeText(
                                            _model.commentaryBAjiba!,
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w200,
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
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      unselectedLabelColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleMedium,
                                      unselectedLabelStyle: TextStyle(),
                                      indicatorColor:
                                          FlutterFlowTheme.of(context).primary,
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                      controller: _model.verseSelectorValueController ??=
                          FormFieldController<String>(null),
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
                            r'''$.commentaries[0].translations[0].translation''',
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
                        if (_shouldSetState) setState(() {});
                      },
                      width: 145.0,
                      height: 50.0,
                      searchHintTextStyle:
                          FlutterFlowTheme.of(context).labelMedium,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                        _model.chapterSelectorValue ??= 'الفاتحة',
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
                            r'''$.commentaries[0].translations[0].translation''',
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
                        if (_shouldSetState) setState(() {});
                      },
                      width: 205.0,
                      height: 50.0,
                      searchHintTextStyle:
                          FlutterFlowTheme.of(context).labelMedium,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
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
