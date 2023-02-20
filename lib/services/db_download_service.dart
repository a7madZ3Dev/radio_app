import '../models/radio.dart';
import '../utils/db_service.dart';
import '../utils/web_service.dart';

class DBDownloadService {

  static const filePath = 'lib/db.json';

  static Future<bool> isLocalDBAvailable() async {
    await DB.init();
    List<Map<String, dynamic>> _results = await DB.query(RadioModel.table);
    return _results.isEmpty ? false : true;
  }

  static Future<RadioAPIModel> fetchAllRadios() async {
    final serviceResponse =
        await LocalService().getData(filePath, RadioAPIModel());
    return serviceResponse as RadioAPIModel;
  }

  static Future<List<RadioModel>> fetchLocalDB({
    String searchQuery = '',
    bool isFavoriteOnly = false,
  }) async {
    if (!await isLocalDBAvailable()) {
      // Simulation to http call to fetch JSON Data
      RadioAPIModel radioAPIModel = await fetchAllRadios();

      //Check for data length
      if (radioAPIModel.data!.isNotEmpty) {
        //Init DB
        await DB.init();

        //ForEach api Data and Save in Local DB
        for (var radioModel in radioAPIModel.data!) {
          DB.insert(RadioModel.table, radioModel);
        }
      }
    }

    String rawQuery = '';

    if (!isFavoriteOnly) {
      rawQuery =
          ''' SELECT radios.id, radioName, radioURL, radioDesc, radioWebsite, radioPic,
          radios_bookmarks.isFavorite FROM radios LEFT JOIN radios_bookmarks ON radios.id = radios_bookmarks.id ''';

      if (searchQuery.trim() != '') {
        rawQuery = rawQuery +
            " WHERE radioName LIKE '%$searchQuery%' OR radioDesc LIKE '%$searchQuery%' ";
      }   
    } else {
      rawQuery =
          ''' SELECT radios.id, radioName, radioURL, radioDesc, radioWebsite, radioPic, radios_bookmarks.isFavorite FROM radios INNER JOIN radios_bookmarks ON radios.id = radios_bookmarks.id WHERE isFavorite = '${1}' ''';

      if (searchQuery.trim() != '') {
        rawQuery = rawQuery +
            " AND radioName LIKE '%$searchQuery%' OR radioDesc LIKE '%$searchQuery%' ";
      }
    }

    List<Map<String, dynamic>> _results = await DB.rawQuery(rawQuery);

    List<RadioModel> radioModel = [];
    radioModel = _results.map((item) => RadioModel.fromMap(item)).toList();

    return radioModel;
  }
}
