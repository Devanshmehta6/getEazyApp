import 'dart:convert';

import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/customers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class Detailspage extends StatefulWidget {
  const Detailspage({Key? key}) : super(key: key);

  @override
  _DetailspageState createState() => _DetailspageState();
}

class Config {
  late String name;
  late String rera_carpet;

  Config(this.name, this.rera_carpet);
}

class _DetailspageState extends State<Detailspage> {
  String cust_name = '';
  bool _isEnabled = false;
  bool _isEditingText = false;
  late TextEditingController emailController;
  late TextEditingController nameController;
  final GlobalKey<_DetailspageState> expansionTile = new GlobalKey();

  String initialFirstName = '';
  String initialLastName = '';
  String initialEmail = '';
  String initialPhone = '';
  String initialWhatsapp = '';
  String initialLocation = '';
  String initialResidence = '';

  String initialOccupation = '';
  String initialOrganization = '';
  String initialOffice = '';
  String initialDesignation = '';

  String initialCurrentResi = '';
  String initialFamilyType = '';
  String initialConfigReq = '';
  String initialBudget = '';
  String initialMode = '';
  String initialPurpose = '';
  String? valueChoose;
  String? valueChooseOccupation;
  String? valueChooseForLocationForBasicInfo;
  String? valueChooseForLocationForWorkInfo;
  String? valueChooseForLocationForBudget;
  String? valueChooseForOutcome;

  final locationList = [
    'Aarey Road',
    'Agashi',
    'Agripada',
    'Alibag',
    'Altamount Road',
    'Ambernath',
    'Ambernath East',
    'Ambernath West',
    'Ambivali',
    'Amboli',
    'Anand park',
    'Andheri East',
    'Andheri West',
    'Andheri-Kurla Road',
    'Antop Hill',
    'Anushakti Nagar',
    'Asangaon',
    'Atgaon',
    'Azad Nagar',
    'Badlapur East',
    'Badlapur West',
    'Bandra East',
    'Bandra Kurla Complex',
    'Bandra West',
    'Bangur Nagar',
    'Barve Nagar',
    'Behram Baug',
    'Best Nagar',
    'Beverly Park',
    'Bhadane',
    'Bhandup East',
    'Bhandup West',
    'Bhayandar East',
    'Bhayandar West',
    'Bhivpuri',
    'Bhiwandi',
    'Bhuleshwar',
    'Boisar',
    'Boraj',
    'Borivali East',
    'Borivali West',
    'Borla',
    'Breach Candy',
    'Byculla East',
    'Byculla West',
    'C.P. Tank',
    'Carter Road',
    'Chakala',
    'Chandivali',
    'Charkop',
    'Charni Road',
    'Chedda Nagar',
    'Chembur East',
    'Chembur West',
    'Chembur Colony',
    'Chikuwadi',
    'Chinchpada',
    'Chinchpokli',
    'Chiplun',
    'Chira Bazar',
    'chirag Nagar',
    'Chuna Bhatti',
    'Church Gate',
    'Colaba',
    'Cuffe Parade',
    'Cumballa Hill',
    'Currey Road',
    'Dadar',
    'Dadar East',
    'Dadar West',
    'Dahanu',
    'Dahanu Road',
    'Dahisar East',
    'Dahisar West',
    'Deonar',
    'Dhamote',
    'Dharavi',
    'Dindoshi',
    'Dohole',
    'Dombivli East',
    'Dombivli West',
    'Dongri',
    'Elphinstone Road',
    'Evershine Nagar',
    'Fort',
    'G T B Nagar',
    'Gaibi Nagar',
    'Gamdevi',
    'Gandhi Nagar',
    'Ghatkopar East',
    'Ghatkopar West',
    'Ghatla',
    'Ghera Sudhagad',
    'Ghodbunder',
    'Girgaon',
    'Gokuldam',
    'Gokuldham Colony',
    'Golibar',
    'Gorai',
    'Goregaon Eas',
    'Goregaon West',
    'Govandi West',
    'Govandi East',
    'Govand Nagar',
    'Grant Road East',
    'Grant Road West',
    'Gulmohar Road',
    'Haji Ali',
    'Harihareshwar',
    'Hariyali',
    'IC Colony',
    'J B Nagar',
    'Jacob Circle',
    'Jai Ambe Nagar',
    'Jawhar',
    'Jogeshwari East ',
    'Jogeshwari West',
    'Juhu',
    'Juhu Tara Road',
    'Kajupada',
    'Kalbadevi',
    'Kalher',
    'Kalina',
    'Kalyan East',
    'Kalyan West',
    'Kalyan-Shil Road',
    'Kamatghar',
    'Kanakia Road',
    'Kandivali East',
    'Kandivali West',
    'Kanjurmarg',
    'Kanjurmarg East',
    'Kanjurmarg West',
    'Kannamwar Nagar',
    'Kanti Park',
    'Karjat',
    'Kasara',
    'Kashimira',
    'Kemps Corner',
    'Khadakpada',
    'Khan Abdul Gafar Road',
    'Khandale',
    'Khandas Road',
    'Khar East',
    'Khar West',
    'Kharbao',
    'Khardi',
    'Kharodi',
    'Khetwadi',
    'Khodala',
    'Khopoli',
    'Kidwai Nagar',
    'Kolad',
    'Kopargaon',
    'Kurla East',
    'Kurla West',
    'Lal Baug',
    'LBS Marg',
    'LBS Marg-Mulund',
    'Link Road',
    'Linking Road',
    'Lokhandwala',
    'Lonere',
    'Lower Parel',
    'Madh',
    'Magathane',
    'Mahad',
    'Mahalaxmi',
    'Mahavir Nagar',
    'Mahim',
    'Malabar Hill',
    'Malad East',
    'Malad West',
    'Malvani',
    'Mandapeshwar',
    'Mandvi',
    'Mankhurd',
    'Manor',
    'Manori',
    'Marine Lines',
    'Marol',
    'Masjid Bunder',
    'Matunga',
    'Matunga East',
    'Matunga West',
    'Mazgaon',
    'MHADA Colony',
    'Mhatwali',
    'Mira Bhayandar',
    'Mira Road',
    'Mulund Colony',
    'Mulund East',
    'Mulund West',
    'Mumbai - Nasik Highway',
    'Mumbai Central',
    'Murbad',
    'Murbad Karjat Road',
    'Murbad Road',
    'Murud',
    'Nagaon',
    'Nagothane',
    'Nagpada',
    'Nahur East',
    'Nahur West',
    'Naigaon East',
    'Naigaon West',
    'Nalasopara East',
    'Nalasopara West',
    'Narayan Patil Wadi',
    'Nariman Point',
    'Navapada',
    'Navghar',
    'Naya Nagar',
    'Nehru Nagar',
    'Nehru Road',
    'Neral',
    'Netaji Nagar',
    'Opera House',
    'Orlem Malad',
    'Oshiwara',
    'Palghar',
    'Pali',
    'Pali Hill',
    'Panth Nagar',
    'Parel',
    'Peddar Road',
    'Poonam Nagar',
    'Postal Colony',
    'Powai',
    'Prabhadevi',
    'Prabhu Ali',
    'Pydhonie',
    'Raigad',
    'Ramnagar',
    'Roha',
    'Royal Palms',
    'S V Road',
    'Sahakar Nagar',
    'Sahar',
    'Sakawar',
    'Sakinaka',
    'Samat Nagar',
    'Santacruz East',
    'Santacruz West',
    'Saralgoan',
    'Saravali',
    'Sarvodaya Nagar',
    'Senapati Bapat Marg',
    'Sewri',
    'Sewri West',
    'Shahad',
    'Shahapur',
    'Shastri Nagar',
    'Shivaji Nagar',
    'Shivaji Park',
    'Sindhi Society',
    'Sion Circle',
    'Sion East',
    'Sion West',
    'Sir JJ Road',
    'Tagore Nagar',
    'Talasari',
    'Tardeo',
    'Thakurdwar',
    'Thakurli',
    'Tilak Nagar',
    'Titwala',
    'Triveni Nagar',
    'Trombay',
    'Tulsiwadi',
    'Tungareshwar',
    'Ulhasnagar',
    'Umerkhadi',
    'Umroli',
    'Upper Parel',
    'Upper Worli',
    'Uttan',
    'V P ROAD',
    'Vakola',
    'Vangani',
    'Vasai East',
    'Vasai West',
    'Vasai Road',
    'Vasai-Nallasopara Link Road',
    'Vasind',
    'Veera Desai Road',
    'Vehloli',
    'Versova',
    'Vidya Nagari',
    'Vidyavihar',
    'Vidyavihar East',
    'Vidyavihar West',
    'Vijay Nagar',
    'Vikhroli East',
    'Vikhroli West',
    'Vikramgad',
    'Vile Parle East',
    'Vile Parle West',
    'Virar East',
    'Virar West',
    'Vitthalwadi',
    'Wada',
    'Wadala East',
    'Wadala West',
    'Walkeshwar',
    'Warden Road',
    'Western Express Highway',
    'Worli',
    'Yari Road',
    'Yogi Jawraj Nagar',
    'Zadghar',
  ];

  final items = ['Hot', 'Warm', 'Cold', 'Lost'];
  final status = [
    'Busy',
    'Connected',
    'No answer',
    'Wrong Number',
    'Sent a text',
    'Sent a voice message'
  ];
  String? valueChooseForStatus;
  final occ_list = [
    'Self Employeed',
    'Employeed-Private',
    'Employeed-Government',
  ];
  final budgetList = [
    '50L - 75L',
    '75L - 1CR',
    '1CR - 1.25CR',
    '1.25CR - 1.50CR',
    '1.50CR - 1.75CR',
    '1.75CR - 2CR',
    '2CR AND ABOVE',
  ];
  final family = ['Joint Family', 'Nuclear Family'];
  String _value = '';
  String _value3 = '';
  List selectedConfigs = [];
  String _value2 = "";
  String _value4 = '';
  DateTime date = DateTime(2021);
  TimeOfDay time = TimeOfDay(hour: 10, minute: 0);
  final outcomes = [
    'Busy',
    'Connected',
    'No answer',
    'Wrong number',
    'Sent a text',
    'Sent a voice message'
  ];

  late Future cust;
  getName() async {
    setState(() {});
    final snp = '$initialFirstName $initialLastName';
    //final name = '${snp.substring(0, 12)}' + '...';
    return snp;
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  putBasic() async {
    final pref = await SharedPreferences.getInstance();
    final cust_url = pref.getString('cust_url');
    final project_url = pref.getString('project_url');
    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersprofile_api/$cust_url');
      print('>>>>>>> url <>>>>>>>> $url');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');
      print('>>>>>>> $initialFirstName');
      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'first_name': initialFirstName,
        'last_name': initialLastName,
        'email': initialEmail,
        'mobile': initialPhone,
        'whatsapp': initialWhatsapp,
        'residence_location': valueChooseForLocationForBasicInfo,
        'residence_address': initialResidence
      });
      print('>>>>>>>> PUT BASIC >>>>>>>>. ${response.body}');
      print('----------------${response.statusCode}');
    } else {
      print('Logged out ');
    }
  }

  putWork() async {
    final pref = await SharedPreferences.getInstance();
    final cust_url = pref.getString('cust_url');
    final project_url = pref.getString('project_url');
    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersprofile_api/$cust_url');
      print('>>>>>>> url <>>>>>>>> $url');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'occupation': valueChooseOccupation,
        'organization': initialOrganization,
        'designation': initialDesignation,
        'location': valueChooseForLocationForWorkInfo
      });
      print('>>>>>>>> PUT WORK >>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  putreq() async {
    final pref = await SharedPreferences.getInstance();
    final cust_url = pref.getString('cust_url');
    final project_url = pref.getString('project_url');
    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersprofile_api/$cust_url');
      print('>>>>>>> url <>>>>>>>> $url');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'budget': valueChooseForLocationForBudget,
        'funding_mode': _value2,
        'purpose_of_purchase': _value3,
        'family_type': _value,
        'current_residence': _value4,
      });
      print('>>>>>>>> checkout response >>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  List<Config> configurations = [];
  List<bool?> checkedValue = [];
  late Future con;
  List selectedValue = [];
  List<bool?> isChecked = [];
  bool? test = true;

  getCustomers() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in visit page : $isLoggedIn');
    final cust_url = pref.getString('cust_url');

    if (isLoggedIn == true) {
      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersprofile_api/$cust_url');
      print('urlllllllll $url');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      String? authorization = sp.getString('token');

      String? tokenn = authorization;
      final cookie = sp.getString('cookie');
      final token = await AuthService.getToken();
      final settoken = 'Token ${token['token']}';

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      });

      print('>>>>>>>>>>>> RESPONSE >>>>>>>>> ${response.body}');
      print('>>>>>>>>. ${response.statusCode}');
      final jsonData = jsonDecode(response.body);
      // final cust_data = jsonData[0]['customers'];
      final cust_data = jsonData['customers_ser'];
      final work_info = jsonData['workinfo_ser'];
      final req = jsonData['requiremnt_ser'];
      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.            ${jsonData['customer_history']}');
      print('>>>>>>>>>>>.          $cust_data');
      setState(() {
        initialEmail = cust_data['email'];
        initialFirstName = '${cust_data['first_name']}';
        initialLastName = '${cust_data['last_name']}';

        initialPhone = cust_data['mobile'];
        initialWhatsapp = cust_data['whatsapp'] == null
            ? cust_data['mobile']
            : cust_data['whatsapp'];
        valueChooseForLocationForBasicInfo = cust_data['residence_location'];
        initialResidence = cust_data['residence_address'] == null
            ? '-'
            : cust_data['residence_address'];
        initialOccupation = work_info['occupation'];
        initialOrganization = work_info['organization'];
        valueChooseForLocationForWorkInfo = work_info['location'];
        initialDesignation = work_info['designtion'];
        _value4 = cust_data['current_residence'];
        _value = cust_data['family_type'];
        initialConfigReq = req['residence_configuration'];
        valueChooseForLocationForBudget = req['budget'];
        _value2 = req['funding_mode'];
        _value3 = req['purpose_of_purchase'];
        selectedConfigs = initialConfigReq.split(',');

        //selectedConfigs.add('2 Bhk');
        print('>>>>>>>>>>> selectedC ======== $selectedConfigs');
        //checkedValue = List<bool?>.filled(selectedConfigs.length, true);
        //checkedValue = List<bool?>.noSuchMethod(invocation)
      });
    } else {
      print('Logged out');
    }
  }

  getData() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';
      final cust_url = pref.getString('cust_url');

      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersprofile_api/$cust_url');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";

      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': settoken,
          HttpHeaders.cookieHeader: setcookie,
        },
      );
      final jsonData = jsonDecode(response.body);
      final config_rcvd = jsonData['project_configuration'];
      configurations.clear();
      for (var i in config_rcvd) {
        Config c = Config(i['name'], i['rera']);
        configurations.add(c);
        print('>>>>>>>>  $configurations');
      }
    }
    print('>. before return >>>>>>> $configurations');
    isChecked = List<bool?>.filled(configurations.length, false);
    return configurations;
  }

  showAlertDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        color: Color(0xff4044fc),
        height: 40,
        width: double.infinity,
        //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.3, vertical: 9),
          child: Text(
            'Log a Visit',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 250,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 240,
                  // margin: EdgeInsets.only(left: 0, right: 0),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(top: 10, left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                      top: BorderSide(color: Colors.grey),
                      left: BorderSide(color: Colors.grey),
                      right: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    iconSize: 30,
                    iconEnabledColor: Colors.grey,
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                    //hint : Text(' $valueChoose'),
                    value: valueChoose,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    items: items.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                        valueChoose = newValue;
                        //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 210, top: 10),
              child: Text(
                'Feedback',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              //height: 80,

              width: 300,
              margin: EdgeInsets.only(top: 10, left: 10),
              child: TextFormField(
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
                minLines: 4,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 11, right: 15, bottom: 10),
                  hintText: 'Feedback',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      color: Colors.white,
                      height: 47,
                      child: Center(
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      color: Color(0xff4044fc),
                      height: 47,
                      child: Center(
                        child: Text(
                          'Save',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.only(top: 20),
      /* actions: [
       Container(
         color : Colors.yellow,
            padding: EdgeInsets.zero,
            width: 330,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  
                  width: width * 0.3,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                    color: Colors.red,
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  width: width * 0.3,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        
      ],*/
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  var isExpanded = false;
  _onExpansionChanged(bool val) {
    setState(() {
      print('>>>>...val >>>>>>>> $val');
      isExpanded = !val;
      print('>>>>>> iss >>>>>>. $isExpanded');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cust = getCustomers();

    //nameController = TextEditingController();
    //emailController = TextEditingController();
    print('>>>>>confi >>>>>. ${configurations.length}');
    con = getData().whenComplete(() {});

    // con = getConfig();
  }
  //getCustomers();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    //nameController = TextEditingController(text: initialName)
    // ..addListener(
    //   () {
    //     setState(() {});
    //   },
    // );

    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(110),
                child: Column(
                  children: [
                    Container(
                      color: Colors.black,
                      height: 55,
                      width: double.infinity,
                      child: FutureBuilder(
                          future: getName(),
                          builder: (context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.active:
                                return Text('active');
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              case ConnectionState.none:
                                return Text('none');
                              case ConnectionState.done:
                                return Container(
                                  margin: EdgeInsets.only(left: 20, top: 14),
                                  child: Text(
                                    'Details : ${snapshot.data}',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                );
                            }
                          }),
                    ),
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'Profile',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'History',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Follow Ups',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              iconTheme: IconThemeData(color: Colors.blue.shade800),
              backgroundColor: Colors.white,
              title: Row(
                children: <Widget>[
                  SizedBox(width: width * 0.2),
                  Text(
                    'EazyCustomers',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: myColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: width * 0.2),
                  Image.asset('images/eazyapp-logo-blue.png',
                      height: 45, width: 40),
                ],
              ),
            ),
            backgroundColor: Colors.grey.shade300,
            body: TabBarView(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            margin: EdgeInsets.only(top: 8, left: 4, right: 4),
                            //color: Colors.pink,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              onExpansionChanged: (value) {
                                print('>>>> event >>>>>>>');
                              },
                              key: expansionTile,
                              //collapsedBackgroundColor: Colors.red,
                              textColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              collapsedTextColor: Colors.black,
                              iconColor: Colors.black,

                              title: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Basic Information',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 8, left: 5, right: 5),
                                  //height: height * 0.42,

                                  width: double.infinity,

                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'First Name:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.65,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),
                                              child: TextFormField(
                                                onEditingComplete: () {},
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,
                                                onFieldSubmitted: (value) {
                                                  setState(() {
                                                    initialFirstName =
                                                        value.toString();
                                                  });
                                                  //snapshot.data = value
                                                },
                                                initialValue:
                                                    '$initialFirstName', //snapshot.data
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                                //controller: nameController,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,

                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff4044fc)),
                                                  ),
                                                  //helperText: 'Helper Text',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'Last Name:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.65,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),
                                              child: TextFormField(
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,
                                                onFieldSubmitted: (value) {
                                                  initialLastName =
                                                      value; //snapshot.data = value
                                                },
                                                initialValue:
                                                    '$initialLastName', //snapshot.data
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                                //controller: nameController,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,

                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff4044fc)),
                                                  ),
                                                  //helperText: 'Helper Text',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'Email:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.7,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),
                                              child: TextFormField(
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,
                                                onFieldSubmitted: (value) {
                                                  initialEmail =
                                                      value; //snapshot.data = value
                                                },
                                                initialValue:
                                                    '$initialEmail', //snapshot.data
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                                //controller: nameController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff4044fc)),
                                                  ),
                                                  //helperText: 'Helper Text',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'Phone:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.7,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),
                                              child: TextFormField(
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,
                                                onFieldSubmitted: (value) {
                                                  initialPhone =
                                                      value; //snapshot.data = value
                                                },
                                                initialValue:
                                                    '$initialPhone', //snapshot.data
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                                //controller: nameController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff4044fc)),
                                                  ),
                                                  //helperText: 'Helper Text',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'Whatsapp:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.65,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),
                                              child: TextFormField(
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,
                                                onFieldSubmitted: (value) {
                                                  initialWhatsapp =
                                                      value; //snapshot.data = value
                                                },
                                                initialValue:
                                                    '$initialWhatsapp', //snapshot.data
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                                //controller: nameController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff4044fc)),
                                                  ),
                                                  //helperText: 'Helper Text',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'Location:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.65,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),

                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                iconSize: 40,
                                                iconEnabledColor:
                                                    Color(0xff4044fc),
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                underline: SizedBox(),
                                                value:
                                                    valueChooseForLocationForBasicInfo,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                                items: locationList
                                                    .map((valueItem) {
                                                  return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem));
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    valueChooseForLocationForBasicInfo =
                                                        newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                'Residence:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.65,
                                              padding: EdgeInsets.zero,
                                              //margin: EdgeInsets.only(left: 8),
                                              //padding: EdgeInsets.only(right  : 30),
                                              child: TextFormField(
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,
                                                onFieldSubmitted: (value) {
                                                  initialResidence =
                                                      value; //snapshot.data = value
                                                },
                                                initialValue:
                                                    '$initialResidence', //snapshot.data
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                                //controller: nameController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff4044fc)),
                                                  ),
                                                  //helperText: 'Helper Text',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.7),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff4044fc)),
                                              onPressed: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                putBasic();
                                              },
                                              child: Text(
                                                'Save',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 8, left: 4, right: 4),
                              //color: Colors.pink,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                
                              ),
                              child: ExpansionTile(
                                textColor: Colors.black,
                                collapsedIconColor: Colors.black,
                                collapsedTextColor: Colors.grey,
                                iconColor: Colors.black,
                                initiallyExpanded: false,
                                //tilePadding: EdgeInsets.symmetric(horizontal: 8),
                                //collapsedBackgroundColor: Color(0xff007bff),
                                title: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Work Information',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                children: [
                                  Container(
                                    //height: height * 0.42,
                                    margin: EdgeInsets.only(
                                        bottom: 5, left: 5, right: 5),
                                    width: double.infinity,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  'Occupation:',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.60,
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  iconSize: 40,
                                                  iconEnabledColor:
                                                      Color(0xff4044fc),
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  underline: SizedBox(),
                                                  hint: Text(
                                                    '$initialOccupation',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  value: valueChooseOccupation,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                  items:
                                                      occ_list.map((valueItem) {
                                                    return DropdownMenuItem(
                                                        value: valueItem,
                                                        child: Text(valueItem));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueChooseOccupation =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  'Organization:',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.6,
                                                padding: EdgeInsets.zero,
                                                //margin: EdgeInsets.only(left: 8),
                                                //padding: EdgeInsets.only(right  : 30),
                                                child: TextFormField(
                                                  //scrollPadding: EdgeInsets.zero,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  onFieldSubmitted: (value) {
                                                    initialOrganization =
                                                        value; //snapshot.data = value
                                                  },
                                                  initialValue:
                                                      '$initialOrganization', //snapshot.data
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                  //controller: nameController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xff4044fc)),
                                                    ),
                                                    //helperText: 'Helper Text',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  'Office:',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.715,
                                                padding: EdgeInsets.zero,
                                                //margin: EdgeInsets.only(left: 8),
                                                //padding: EdgeInsets.only(right  : 30),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  iconSize: 40,
                                                  iconEnabledColor:
                                                      Color(0xff4044fc),
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  underline: SizedBox(),
                                                  value:
                                                      valueChooseForLocationForWorkInfo,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                  items: locationList
                                                      .map((valueItem) {
                                                    return DropdownMenuItem(
                                                        value: valueItem,
                                                        child: Text(valueItem));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueChooseForLocationForWorkInfo =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  'Designation:',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.6,
                                                padding: EdgeInsets.zero,
                                                //margin: EdgeInsets.only(left: 8),
                                                //padding: EdgeInsets.only(right  : 30),
                                                child: TextFormField(
                                                  //scrollPadding: EdgeInsets.zero,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  onFieldSubmitted: (value) {
                                                    initialDesignation =
                                                        value; //snapshot.data = value
                                                  },
                                                  initialValue:
                                                      '$initialDesignation', //snapshot.data
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                  //controller: nameController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xff4044fc)),
                                                    ),
                                                    //helperText: 'Helper Text',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.7),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color(0xff4044fc)),
                                                onPressed: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  putWork();
                                                },
                                                child: Text(
                                                  'Save',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Container(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 8, left: 4, right: 4),
                              //color: Colors.pink,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                
                              ),
                              child: ExpansionTile(
                                textColor: Colors.black,
                                collapsedIconColor: Colors.black,
                                collapsedTextColor: Colors.grey,
                                iconColor: Colors.black,
                                initiallyExpanded: false,
                                //tilePadding: EdgeInsets.symmetric(horizontal: 8),
                                //collapsedBackgroundColor: Color(0xff007bff),
                                title: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Requirements',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                children: [
                                  Container(
                                    //height: height * 0.42,
                                    margin: EdgeInsets.only(
                                        bottom: 5, left: 5, right: 5),
                                    width: double.infinity,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.5, top: 10),
                                            child: Text(
                                              'Current Residence:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            //: 700,
                                            margin: EdgeInsets.only(
                                                right: width * 0.1),
                                            child: Row(
                                              children: [
                                                Radio(
                                                    value: "Self Owned",
                                                    groupValue: _value4,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _value4 =
                                                            value.toString();
                                                      });
                                                    }),
                                                Text(
                                                  'Self Owned',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                                Radio(
                                                    value: "Leased",
                                                    groupValue: _value4,
                                                    autofocus: true,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _value4 =
                                                            value.toString();
                                                      });
                                                    }),
                                                Text(
                                                  'Leased',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, right: width * 0.65),
                                            child: Text(
                                              'Family Type:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            //: 700,
                                            margin: EdgeInsets.only(
                                                right: width * 0.1),
                                            child: Row(
                                              children: [
                                                Radio(
                                                    value: "Joint Family",
                                                    groupValue: _value,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _value =
                                                            value.toString();
                                                      });
                                                    }),
                                                Text(
                                                  'Joint Family',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                                Radio(
                                                    value: "Nuclear Family",
                                                    groupValue: _value,
                                                    autofocus: true,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _value =
                                                            value.toString();
                                                      });
                                                    }),
                                                Text(
                                                  'Nuclear Family',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.43, top: 10),
                                            child: Text(
                                              'Configuration Required:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          FutureBuilder(
                                              future: con,
                                              builder: (context,
                                                  AsyncSnapshot snapshot) {
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.none:
                                                    return Text('none');
                                                  case ConnectionState.waiting:
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  case ConnectionState.active:
                                                    return Text('none');
                                                  case ConnectionState.done:
                                                    return Container(
                                                      padding: EdgeInsets.zero,
                                                      //padding: EdgeInsets.only(
                                                      //left: width * 0.1,
                                                      //right: width * 0.15,
                                                      //top: height * 0.02),
                                                      child: GridView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  //childAspectRatio: 0.1,
                                                                  mainAxisExtent:
                                                                      35,
                                                                  crossAxisCount:
                                                                      2,
                                                                  crossAxisSpacing:
                                                                      20),
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount: snapshot
                                                              .data.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Row(
                                                              children: [
                                                                Container(
                                                                  //margin: EdgeInsets.only(left: 24),
                                                                  child:
                                                                      Transform
                                                                          .scale(
                                                                    scale: 1,
                                                                    child:
                                                                        Checkbox(
                                                                      activeColor:
                                                                          Color(
                                                                              0xff4044fc),
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      value: selectedConfigs.contains(snapshot
                                                                              .data[index]
                                                                              .name)
                                                                          ? test
                                                                          : isChecked[index],
                                                                      onChanged:
                                                                          (val) {
                                                                        // selectedValue.add(snapshot
                                                                        //   .data[index]
                                                                        //  .name);
                                                                        setState(
                                                                            () {
                                                                          selectedConfigs.contains(snapshot.data[index].name)
                                                                              ? test = val
                                                                              : isChecked[index] = val;
                                                                          ;
                                                                        });

                                                                        if (val ==
                                                                            true) {
                                                                          selectedValue.add(snapshot
                                                                              .data[index]
                                                                              .name);
                                                                          print(
                                                                              '000000000000000 $selectedValue');
                                                                        }

                                                                        // selectedValue.add(isChecked[index] ==
                                                                        //         true
                                                                        //     ? snapshot.data[index].name
                                                                        //     : null);
                                                                        // print(
                                                                        //     '>>... 8888888888 $selectedValue');
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${snapshot.data[index].name}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                          fontSize:
                                                                              16),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    );
                                                }
                                              }),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  'Budget:',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.50,
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  iconSize: 40,
                                                  iconEnabledColor:
                                                      Color(0xff4044fc),
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  underline: SizedBox(),
                                                  value:
                                                      valueChooseForLocationForBudget,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                  items: budgetList
                                                      .map((valueItem) {
                                                    return DropdownMenuItem(
                                                        value: valueItem,
                                                        child: Text(valueItem));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueChooseForLocationForBudget =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.55, top: 10),
                                            child: Text(
                                              'Mode of Funding:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.1),
                                            child: Row(
                                              children: [
                                                //SizedBox(
                                                // width: width * 0.05),
                                                Transform.scale(
                                                  scale: 1.1,
                                                  child: Radio(
                                                      value: 'Maximum Self',
                                                      groupValue: _value2,
                                                      activeColor:
                                                          Color(0xff4044fc),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value2 =
                                                              value.toString();
                                                        });
                                                      }),
                                                ),
                                                Text(
                                                  'Maximum Self',
                                                  style: GoogleFonts.poppins(
                                                    textStyle:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.03),
                                                Transform.scale(
                                                  scale: 1,
                                                  child: Radio(
                                                      value: 'Maximum Loan',
                                                      groupValue: _value2,
                                                      activeColor:
                                                          Color(0xff4044fc),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value2 =
                                                              value.toString();
                                                        });
                                                      }),
                                                ),
                                                Text(
                                                  'Maximum Loan',
                                                  style: GoogleFonts.poppins(
                                                    textStyle:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.46, top: 10),
                                            child: Text(
                                              'Purpose of Purchase:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              //SizedBox(width: width * 0.05),
                                              Transform.scale(
                                                scale: 1,
                                                child: Radio(
                                                    value: "Self Use",
                                                    groupValue: _value3,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _value3 =
                                                            value.toString();
                                                      });
                                                    }),
                                              ),
                                              Text(
                                                'Self Use',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.16,
                                              ),
                                              Transform.scale(
                                                scale: 1,
                                                child: Radio(
                                                    value: "Second Home",
                                                    groupValue: _value3,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _value3 =
                                                            val.toString();
                                                      });
                                                    }),
                                              ),
                                              Text(
                                                'Second home',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 1,
                                                child: Radio(
                                                    value: 'Investment',
                                                    groupValue: _value3,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _value3 =
                                                            val.toString();
                                                      });
                                                    }),
                                              ),
                                              Text(
                                                'Investment',
                                                style: GoogleFonts.poppins(
                                                  textStyle:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.093),
                                              Transform.scale(
                                                scale: 1,
                                                child: Radio(
                                                    value: 'Organizational',
                                                    groupValue: _value3,
                                                    activeColor:
                                                        Color(0xff4044fc),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _value3 =
                                                            val.toString();
                                                        print(
                                                            ">>>>>>>>>> $_value");
                                                      });
                                                    }),
                                              ),
                                              Text(
                                                'Organizational',
                                                style: GoogleFonts.poppins(
                                                  textStyle:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.7),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff4044fc),
                                                ),
                                                onPressed: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  putreq();
                                                },
                                                child: Text(
                                                  'Save',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),

                      //NAME FROM JSON
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(),
                  child: Scaffold(
                    backgroundColor: Colors.grey.shade300,
                    bottomNavigationBar: Container(
                      height: height * 0.07,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff4044fc)),
                          child: Text(
                            'Log a Re-Visit',
                            style: GoogleFonts.poppins(fontSize: 20),
                          ),
                          onPressed: () {
                            showAlertDialog(context);
                          }),
                    ),
                    body: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.only(top: 8, left: 4, right: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: ExpansionTile(
                              onExpansionChanged: _onExpansionChanged,
                              collapsedTextColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              textColor: Colors.black,
                              iconColor: Colors.black,
                              title: i == 0
                                  ? Text(
                                      'First Visit ',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  : Text(
                                      '$i Re-Visit ',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, color: Colors.black),
                                    ),
                              trailing: Text(
                                'DATE',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.black),
                              ),
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: 8, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.04, top: 10),
                                              child: Text(
                                                'Status: ',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.76,
                                              height: 40,
                                              margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  top: BorderSide(
                                                      color: Colors.grey),
                                                  left: BorderSide(
                                                      color: Colors.grey),
                                                  right: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                iconSize: 40,
                                                iconEnabledColor: Colors.grey,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                underline: SizedBox(),
                                                hint: Text(
                                                  " Status",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                                value: valueChooseForStatus,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                                items: items.map((valueItem) {
                                                  return DropdownMenuItem(
                                                      value: valueItem,
                                                      child:
                                                          Text(' $valueItem'));
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                                                    valueChooseForStatus =
                                                        newValue;
                                                    //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.68, top: 10),
                                            child: Text(
                                              'Feedback: ',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: width * 0.055,
                                              right: 10,
                                              bottom: 8),
                                          child: TextFormField(
                                            style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: Colors.black),
                                            minLines: 4,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            //initialValue: 'Feedback',
                                            decoration: InputDecoration(
                                              hintText: 'Feedback',
                                              hintStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade500),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 11,
                                                  top: 11,
                                                  right: 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        }),
                    // body: Column(
                    //   children: [
                    //     Card(
                    //       color: Color(0xff88ddff),
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             margin: EdgeInsets.symmetric(
                    //                 horizontal: 20, vertical: 4),
                    //             child: Text(
                    //               'Customer History',
                    //               style: GoogleFonts.poppins(fontSize: 16),
                    //             ),
                    //           ),
                    //           SizedBox(width: width * 0.15),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(right: width * 0.55, top: 10),
                    //       child: Text(
                    //         'Customer Name: ',
                    //         style: GoogleFonts.poppins(fontSize: 16),
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(right: width * 0.6, top: 10),
                    //       child: Text(
                    //         'Check In Time: ',
                    //         style: GoogleFonts.poppins(fontSize: 16),
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(right: width * 0.75, top: 10),
                    //       child: Text(
                    //         'Status: ',
                    //         style: GoogleFonts.poppins(fontSize: 16),
                    //       ),
                    //     ),
                    //     Container(
                    //         margin:
                    //             EdgeInsets.only(right: width * 0.68, top: 10),
                    //         child: Text(
                    //           'Feedback: ',
                    //           style: GoogleFonts.poppins(fontSize: 16),
                    //         )),
                    //     Container(
                    //       margin: EdgeInsets.only(
                    //           top: 10, left: width * 0.055, right: 10),
                    //       child: TextFormField(
                    //         style: GoogleFonts.poppins(
                    //             fontSize: 18, color: Colors.black),
                    //         minLines: 4,
                    //         keyboardType: TextInputType.multiline,
                    //         maxLines: null,
                    //         initialValue: 'Feedback',
                    //         decoration: InputDecoration(
                    //           focusedBorder: OutlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black),
                    //           ),
                    //           border: OutlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black),
                    //           ),
                    //           contentPadding: EdgeInsets.only(
                    //               left: 15, bottom: 11, top: 11, right: 15),
                    //           hintStyle: GoogleFonts.poppins(
                    //               fontSize: 18, color: Colors.black),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.grey.shade300,
                  bottomNavigationBar: Row(
                    children: [
                      Container(
                        height: height * 0.07,
                        child: FlatButton(
                            color: Colors.green,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.whatsapp,
                                    size: 20, color: Colors.white),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    '8433593638',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        height: height * 0.07,
                        child: FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            launch('tel://+918433593638');
                          },
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 20, color: Colors.white),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  '8433593638',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.07,
                        width: width * 0.337,
                        child: FlatButton(
                          color: Colors.red,
                          onPressed: () {},
                          child: Text(
                            'Log a Call',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index  ) {
                        return Container(
                          margin: EdgeInsets.only(top: 8, left: 4, right: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: ExpansionTile(
                            collapsedTextColor: Colors.black,
                            collapsedIconColor: Colors.black,
                            textColor: Colors.black,
                            iconColor: Colors.black,
                            title: Text(
                              'Follow Up - $index',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 8, left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: width * 0.56, top: 10),
                                      child: Text(
                                        'Call Description',
                                        style:
                                            GoogleFonts.poppins(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                        left: width * 0.05,
                                        right: width * 0.05,
                                      ),
                                      child: TextFormField(
                                        style: GoogleFonts.poppins(
                                            fontSize: 18, color: Colors.black),
                                        minLines: 4,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        //initialValue: 'Feedback',
                                        decoration: InputDecoration(
                                          hintText: 'Describe..',
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.grey.shade500),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: width * 0.86,
                                      // margin: EdgeInsets.only(left: 0, right: 0),
                                      padding: EdgeInsets.only(left: 5),
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        iconSize: 30,
                                        iconEnabledColor: Colors.grey,
                                        icon: Icon(Icons.arrow_drop_down),
                                        underline: SizedBox(),
                                        //hint : Text(' $valueChoose'),
                                        value: valueChooseForOutcome,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        items: outcomes.map((valueItem) {
                                          return DropdownMenuItem(
                                              value: valueItem,
                                              child: Text(valueItem));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                                            valueChooseForOutcome = newValue;
                                            //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, left: 23),
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.calendarAlt),
                                          Container(
                                            height: height * 0.07,
                                            width: width * 0.32,
                                            child: FlatButton(
                                              onPressed: () {
                                                pickDate(context);
                                              },
                                              child: date == DateTime(2021)
                                                  ? Text(
                                                      'Select a date',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    )
                                                  : Text(
                                                      '${date.day} - ${date.month} - ${date.year}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.07,
                                            width: width * 0.32,
                                            child: FlatButton(
                                              onPressed: () {
                                                pickTime(context);
                                              },
                                              child: time ==
                                                      TimeOfDay(
                                                          hour: 10, minute: 0)
                                                  ? Text(
                                                      'Select a time',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    )
                                                  : Text(
                                                      '${time.hour}:${time.minute}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                  // body:
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date == DateTime(2021) ? initialDate : date,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 10, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time == TimeOfDay(hour: 10, minute: 0) ? initialTime : time,
    );

    if (newTime == null) return;
    setState(() {
      time = newTime;
    });
  }
}
