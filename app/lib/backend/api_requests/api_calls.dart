import 'dart:convert';
import 'dart:typed_data';

import '../../flutter_flow/flutter_flow_util.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetQuranCall {
  static Future<ApiCallResponse> call({
    int? chapter = 1,
    int? verse = 1,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'getQuran',
      apiUrl:
          'https://raw.githubusercontent.com/mohammedterryjack/quran-api/main/${chapter}:${verse}.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  static dynamic chapterName(dynamic response) => getJsonField(
        response,
        r'''$.chapter''',
      );
  static dynamic verseText(dynamic response) => getJsonField(
        response,
        r'''$.text''',
      );
  static dynamic tafsirZayd(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[1].text''',
      );
  static dynamic tafsirBArabi(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[2].text''',
      );
  static dynamic tafsirJilani(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[3].text''',
      );
  static dynamic tafsirBAjiba(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[4].text''',
      );
  static dynamic bAbbas(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[0].author''',
      );
  static dynamic tafsirBAbbas(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[0].translations[0].translation''',
      );
  static dynamic zayd(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[1].author''',
      );
  static dynamic bArabi(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[2].author''',
      );
  static dynamic jilani(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[3].author''',
      );
  static dynamic bAjiba(dynamic response) => getJsonField(
        response,
        r'''$.commentaries[4].author''',
      );
  static dynamic english(dynamic response) => getJsonField(
        response,
        r'''$.translations[:].translation''',
        true,
      );
}

class GetChaptersCall {
  static Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'getChapters',
      apiUrl:
          'https://raw.githubusercontent.com/mohammedterryjack/quran-api/main/metadata.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  static dynamic chapterNames(dynamic response) => getJsonField(
        response,
        r'''$.chapters[:].chapter''',
        true,
      );
  static dynamic maxVerseNo(dynamic response) => getJsonField(
        response,
        r'''$.chapters[:].n_verses''',
        true,
      );
}

class GetDefinitionCall {
  static Future<ApiCallResponse> call({
    String? word = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'getDefinition',
      apiUrl:
          'https://raw.githubusercontent.com/mohammedterryjack/hans-wehr-api/main/${word}.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  static dynamic definition(dynamic response) => getJsonField(
        response,
        r'''$.definition''',
      );
  static dynamic previous(dynamic response) => getJsonField(
        response,
        r'''$.previous_term''',
      );
  static dynamic next(dynamic response) => getJsonField(
        response,
        r'''$.next_term''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
