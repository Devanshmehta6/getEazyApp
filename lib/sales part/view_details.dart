import 'dart:convert';

import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/customers.dart';
import 'package:eazy_app/sales%20part/log_call.dart';
import 'package:eazy_app/sales%20part/log_revisit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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

class History {
  late String status;
  late String feedback;
  late dynamic date;

  History(this.status, this.feedback, this.date);
}

class FollowUp {
  late String to;
  late String out_come;
  late String date;
  late String time;
  late String call_desc;

  FollowUp(this.to, this.out_come, this.date, this.time, this.call_desc);
}

class _DetailspageState extends State<Detailspage> {
  String cust_name = '';
  late TextEditingController emailController;
  late TextEditingController nameController;

  String initialFirstName = '';
  String initialLastName = '';

  String initialOccupation = '';
  String initialOrganization = '';

  String initialConfigReq = '';

  String? valueChoose;
  String? valueChooseOccupation;
  String? valueChooseForLocationForBasicInfo;
  String? valueChooseForLocationForWorkInfo;
  String? valueChooseForBudget;
  String? valueChooseForOutcome;

  List<History> history = [];

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

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController residence = TextEditingController();
  TextEditingController organization = TextEditingController();
  TextEditingController designation = TextEditingController();
  int cust_id = 0;
  String image = '';

  final items = ['Hot', 'Warm', 'Cold', 'Lost'];

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
    '2CR - above',
  ];
  final family = ['Joint Family', 'Nuclear Family'];
  String _value = '';
  String _value3 = '';
  List selectedConfigs = [];
  String _value2 = "";
  String _value4 = '';
  dynamic date = DateTime(2021);

  TimeOfDay time = TimeOfDay(hour: 10, minute: 0);
  late final project_id;
  final outcomes = [
    'Busy',
    'Connected',
    'No answer',
    'Wrong number',
    'Sent a text',
    'Sent a voice message'
  ];
  Map<String, bool> configurations = {};
  List<Config> displayConfig = [];
  List<bool?> checkedValue = [];
  List<FollowUp> follow_ups_list = [];
  late Future con;
  List selectedValue = [];
  List<bool?> isChecked = [];
  bool? test = true;

  late Future cust;
  getName() async {
    setState(() {});
    final snp = '$initialFirstName $initialLastName';
    //final name = '${snp.substring(0, 12)}' + '...';
    return snp;
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
          'https://geteazyapp.com/api-checkout/$project_url/$cust_url/personal_info_api');
      print('000000000000000000000 $url');
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
        'project': project_id.toString(),
        'first_name': fname.text,
        'last_name': lname.text,
        'email': email.text,
        'mobile': phone.text,
        'whatsapp': whatsapp.text,
        'residence_location': valueChooseForLocationForBasicInfo,
        'residence_address': residence.text
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
          'https://geteazyapp.com/api-checkout/$project_url/workinfo_api');
      print('>>>>>>> url <>>>>>>>> $url');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.post(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'customer': cust_id.toString(),
        'project': project_id.toString(),
        'occupation': valueChooseOccupation,
        'organization': organization.text,
        'designtion': designation.text,
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
          'https://geteazyapp.com/api/checkout/$project_url/$cust_url/requirement_info_api');
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
        'customer': cust_id.toString(),
        'budget': valueChooseForBudget,
        'funding_mode': _value2,
        'purpose_of_purchase': _value3,
        'current_residence': _value4,
        'residence_configuration': selectedConfigs.join(' ,')
      });
      print('>>>>>>>> 0000000000 response >>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  putres() async {
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
          'https://geteazyapp.com/api-checkout/$project_url/$cust_url/personal_info_api');
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
        // 'customer': cust_id.toString(),
        'project': project_id.toString(),
        'mobile': phone.text,
        'family_type': _value,
        'current_residence': _value4,
      });
      print('>>>>>>>> RESS response >>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  getCustomers() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in visit page : $isLoggedIn');
    final cust_url = pref.getString('cust_url');

    if (isLoggedIn == true) {
      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersprofile_api/$cust_url');

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
      print('-----------------------${jsonData['customers']}');

      final work_info = jsonData['workinfo_ser'];
      final req = jsonData['requiremnt_ser'];
      final sales_manager_name = jsonData['sales_manager'][0];
      print('----------------- sales ------------ $sales_manager_name');
      pref.setString('sales_man_name', sales_manager_name);
      final cust_data = jsonData['customers_ser'];
      setState(() {
        image = cust_data['pic'];
        project_id = cust_data['project'];
        print('--------9999999999          ----$project_id');
        cust_id = jsonData['customers_ser']['id'];
        pref.setInt('cust_id', cust_id);
        //fname = new TextEditingController(text: 'Test');
        fname = TextEditingController(text: cust_data['first_name']);
        email = new TextEditingController(text: cust_data['email']);
        initialFirstName = '${cust_data['first_name']}';
        initialLastName = '${cust_data['last_name']}';
        lname = new TextEditingController(text: cust_data['last_name']);
        phone = new TextEditingController(text: cust_data['mobile']);
        whatsapp = cust_data['whatsapp'] == null
            ? TextEditingController(text: cust_data['mobile'])
            : TextEditingController(text: cust_data['whatsapp']);

        valueChooseForLocationForBasicInfo = cust_data['residence_location'];
        residence = cust_data['residence_address'] == null
            ? TextEditingController(text: '-')
            : TextEditingController(text: cust_data['residence_address']);
        initialOccupation = work_info['occupation'];
        organization = TextEditingController(text: work_info['organization']);
        valueChooseForLocationForWorkInfo = work_info['location'];
        designation = TextEditingController(text: work_info['designtion']);
        _value4 = cust_data['current_residence'];
        _value = cust_data['family_type'];
        initialConfigReq = req['residence_configuration'];
        valueChooseForBudget = req['budget'];
        _value2 = req['funding_mode'];
        _value3 = req['purpose_of_purchase'];

        selectedConfigs = initialConfigReq.split(',');

        selectedConfigs.forEach((key) {
          configurations[key] = true;
        });
      });
    } else {
      print('Logged out');
    }
  }

  getHistory() async {
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

      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.            ${jsonData['visits']}');
      final hist = jsonData['visits'];
      history.clear();
      for (var i in hist) {
        History h = History(i['status'], i['feedback'], i['date_time']);
        history.add(h);
        print('LISSSSSSSSTTTTTTTTTTTTTT --- $history');
      }
    } else {
      print('Logged out');
    }
    return history;
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
      print('-----------------CHECKKKKKKKKKKKKKKKKKKKK  ------ ${jsonData}');
      final config_rcvd = jsonData['configurations'];
      print('-----------------CHECKKKKKKKKKKKKKKKKKKKK  ------ $config_rcvd');
      configurations.clear();
      for (var i in config_rcvd) {
        Config c = Config(i['name'], i['rera']);
        configurations[i['name']] = false;
        // c.forEach(key , value){

        // }
        print('0000000000000 ${c.toString()}');
        displayConfig.add(c);
        print('>>>>>>>>  $configurations');
      }
    }
    print('>. before return >>>>>>> $configurations');
    isChecked = List<bool?>.filled(configurations.length, false);
    return displayConfig;
  }

  getFollowUps() async {
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
      final jsonData = jsonDecode(response.body);
      print(
          '============= ------- LOG ------- ============= ${jsonData['call_logs']}');
      final follow_from_json = jsonData['call_logs'];
      follow_ups_list.clear();
      for (var i in follow_from_json) {
        FollowUp fu = FollowUp(
            i['to'], i['out_come'], i['date'], i['time'], i['call_desc']);
        follow_ups_list.add(fu);
      }
    } else {
      print('Logged out');
    }
    return follow_ups_list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    cust = getCustomers();

    con = getData().whenComplete(() {});
  }
  //getCustomers();

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Customer Details Page',
      screenClassOverride: 'Customer Details Page',
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
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
                        color: Colors.grey.shade300,
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
                                      'Details: ${snapshot.data}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  );
                              }
                            })),
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
                              initiallyExpanded: true,
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
                                                controller: fname,
                                                autofocus: true,

                                                onEditingComplete: () {},
                                                //scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.name,

                                                // initialValue:
                                                // '$initialFirstName', //snapshot.data
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
                                                controller: lname,

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
                                                controller: email,
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
                                                controller: phone,
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
                                                controller:
                                                    whatsapp, //snapshot.data
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
                                                controller:
                                                    residence, //snapshot.data
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
                                                  controller:
                                                      organization, //snapshot.data
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
                                                  controller:
                                                      designation, //snapshot.data
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
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: double.infinity,
                        child: Container(
                          margin: EdgeInsets.only(top: 8, left: 4, right: 4),
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
                                margin: EdgeInsets.only(
                                    bottom: 5, left: 5, right: 5),
                                width: double.infinity,
                                child: Container(
                                  //margin : EdgeInsets.symmetric(horizontal: 4),
                                  //padding : EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Column(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.start,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              'Current Residence:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            //: 700,
                                            //margin: EdgeInsets.all(10),
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
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              'Family Type:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
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
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              'Configuration Required:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FutureBuilder(
                                          future: con,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            switch (snapshot.connectionState) {
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
                                                      padding: EdgeInsets.zero,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              //childAspectRatio: 0.1,
                                                              mainAxisExtent:
                                                                  35,
                                                              crossAxisCount: 2,
                                                              crossAxisSpacing:
                                                                  20),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          snapshot.data.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Row(
                                                          children: [
                                                            Container(
                                                              //margin: EdgeInsets.only(left: 24),
                                                              child: Transform
                                                                  .scale(
                                                                scale: 1,
                                                                child: Checkbox(
                                                                  activeColor:
                                                                      Color(
                                                                          0xff4044fc),
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  value: selectedConfigs.contains(snapshot
                                                                          .data[
                                                                              index]
                                                                          .name)
                                                                      ? test
                                                                      : isChecked[
                                                                          index],
                                                                  onChanged:
                                                                      (val) {
                                                                    configurations[snapshot
                                                                        .data[
                                                                            index]
                                                                        .name] = val!;
                                                                    selectedConfigs
                                                                        .clear();
                                                                    configurations
                                                                        .forEach((key,
                                                                            value) {
                                                                      if (value ==
                                                                          true) {
                                                                        selectedConfigs
                                                                            .add(key);
                                                                      }
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      selectedConfigs.contains(snapshot
                                                                              .data[
                                                                                  index]
                                                                              .name)
                                                                          ? test =
                                                                              val
                                                                          : isChecked[index] =
                                                                              val;
                                                                      ;
                                                                    });
                                                                    print(
                                                                        '111111111111111 $configurations');
                                                                    print(
                                                                        '111111111111111 $selectedConfigs');
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
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              'Budget:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 5, top: 10),
                                            width: width * 0.50,
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              iconSize: 40,
                                              iconEnabledColor:
                                                  Color(0xff4044fc),
                                              icon: Icon(Icons.arrow_drop_down),
                                              underline: SizedBox(),
                                              value: valueChooseForBudget,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              items:
                                                  budgetList.map((valueItem) {
                                                return DropdownMenuItem(
                                                    value: valueItem,
                                                    child: Text(valueItem));
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  valueChooseForBudget =
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
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              'Mode of Funding:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            //margin: EdgeInsets.all(10),
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
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              'Purpose of Purchase:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          //SizedBox(width: width * 0.05),
                                          Transform.scale(
                                            scale: 1,
                                            child: Radio(
                                                value: "Self Use",
                                                groupValue: _value3,
                                                activeColor: Color(0xff4044fc),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value3 = value.toString();
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
                                                activeColor: Color(0xff4044fc),
                                                onChanged: (val) {
                                                  setState(() {
                                                    _value3 = val.toString();
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
                                                activeColor: Color(0xff4044fc),
                                                onChanged: (val) {
                                                  setState(() {
                                                    _value3 = val.toString();
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
                                                activeColor: Color(0xff4044fc),
                                                onChanged: (val) {
                                                  setState(() {
                                                    _value3 = val.toString();
                                                    print(">>>>>>>>>> $_value");
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
                                        margin:
                                            EdgeInsets.only(left: width * 0.7),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xff4044fc),
                                            ),
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              putreq();
                                              putres();
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
                          onPressed: () async{
                            final pref = await SharedPreferences.getInstance();
                            pref.setString('from', 'New');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RevisitLog(),
                                ));
                          }),
                    ),
                    body: FutureBuilder(
                        future: getHistory(),
                        builder: (context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                              return Text('active');
                            case ConnectionState.none:
                              return Text('none');
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            case ConnectionState.done:
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    DateTime date = DateTime.parse(snapshot
                                        .data[i]
                                        .date); //snapshot.data[i].date;//as DateTime;

                                    var formatted =
                                        DateFormat('MMM d, ' 'yy').format(date);
                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: 8, left: 4, right: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: ExpansionTile(
                                        //onExpansionChanged: _onExpansionChanged,
                                        collapsedTextColor: Colors.black,
                                        collapsedIconColor: Colors.black,
                                        textColor: Colors.black,
                                        iconColor: Colors.black,
                                        title: i == 0
                                            ? Text(
                                                'First Visit ',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              )
                                            : Text(
                                                '$i Re-Visit ',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                        trailing: Text(
                                          formatted,
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 8, left: 5, right: 5),
                                              height: 140,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  color: Colors.white),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, top: 10),
                                                    child: Text(
                                                      'Status: ${snapshot.data[i].status}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, top: 10),
                                                    child: Text(
                                                      'Description: ${snapshot.data[i].feedback}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16),
                                                    ),
                                                  ),
                                                  i == snapshot.data.length - 1
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.78,
                                                                  top: 20),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final pref =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              pref.setString(
                                                                  'status',
                                                                  snapshot
                                                                      .data[i]
                                                                      .status);
                                                              pref.setString(
                                                                  'feedback',
                                                                  snapshot
                                                                      .data[i]
                                                                      .feedback);
                                                              pref.setString('from', 'Revisit');

                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          RevisitLog(),
                                                                ),
                                                              );
                                                            },
                                                            child: Text('Edit'),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              )),
                                        ],
                                      ),
                                    );
                                  });
                          }
                        }),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.grey.shade300,
                  bottomNavigationBar: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: height * 0.07,
                            child: FlatButton(
                              color: Colors.green,
                              onPressed: () {
                                launch('https://wa.me/91${whatsapp.text}');
                              },
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.whatsapp,
                                      size: 20, color: Colors.white),
                                  Text(
                                    'WhatsApp',
                                    style: GoogleFonts.poppins(
                                        fontSize: 17, color: Colors.white),
                                  )
                                ],
                              ),
                            )),
                      ),
                      Expanded(
                        child: Container(
                          height: height * 0.07,
                          child: FlatButton(
                            color: Colors.blue,
                            onPressed: () {
                              launch('tel://+918433593638');
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 18),
                                Icon(Icons.phone,
                                    size: 25, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Call',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: height * 0.07,
                          width: width * 0.337,
                          child: FlatButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallLog(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.plus,
                                  size: 21,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Follow Up',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: FutureBuilder(
                      future: getFollowUps(),
                      builder: (context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text('none');
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return Text('active');
                          case ConnectionState.done:
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  DateTime date = DateTime.parse(snapshot
                                      .data[index]
                                      .date); //snapshot.data[i].date;//as DateTime;

                                  var formatted =
                                      DateFormat('MMM d, ' 'yy').format(date);
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 8, left: 4, right: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: ExpansionTile(
                                      trailing: Text(
                                        '${snapshot.data[index].time}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      collapsedTextColor: Colors.black,
                                      collapsedIconColor: Colors.black,
                                      textColor: Colors.black,
                                      iconColor: Colors.black,
                                      title: Text(
                                        'Follow Up - $formatted',
                                        style:
                                            GoogleFonts.poppins(fontSize: 16),
                                      ),
                                      children: [
                                        Container(
                                          height: height * 0.2,
                                          margin: EdgeInsets.only(
                                              bottom: 8, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.black),
                                              color: Colors.white),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Outcome:',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      '${snapshot.data[index].out_come}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Text(
                                                  '${snapshot.data[index].call_desc}',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                        }
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
      final format = DateFormat.yMMMMd('en_US').format(newDate);
      //format.format(newDate);
      date = format;
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
