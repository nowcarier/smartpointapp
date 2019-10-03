import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpoint/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'details.dart';
import 'util/data.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
      await http.get('https://smart-point.000webhostapp.com/get.php');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String id;
  final String name;
  final String email;
  final String points;

  Post({this.id, this.name, this.email, this.points});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      points: json['points'],
    );
  }
}

// void main() => runApp(new Home());
void main() => runApp(Home(post: fetchPost()));

class Home extends StatefulWidget {
  final Future<Post> post;
  const Home({Key key, this.post}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String barcode = "";
  String text = "a";
  int points = 0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: GestureDetector(
        child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20.0, // has the effect of softening the shadow
                    spreadRadius: 5.0, // has the effect of extending the shadow
                    offset: Offset(
                      10.0, // horizontal, move right 10
                      10.0, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.purple,
                gradient: new LinearGradient(
                  colors: [Color(0xFFF3F3F3), Color(0xFFF3F3F3)],
                ),
              ),
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                        child: Image.asset(
                          'assets/logo2.png',
                          // width: 300,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          textColor: Colors.black,
                          color: Colors.grey[300],
                          elevation: 4,
                          child: Text(
                            "QR Code",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: scan,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 65, 0, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: Colors.brown.shade800,
                          backgroundImage: NetworkImage(
                              'https://scontent.fbkk10-1.fna.fbcdn.net/v/t1.0-9/60771551_2835734086652423_3721769198423113728_n.jpg?_nc_cat=105&_nc_oc=AQnGSsmq-h8HfBdiq26W34I4-UWJE67PfXM4kki64eJT01oFCcmTF0mbMfT8T3c9WsI&_nc_ht=scontent.fbkk10-1.fna&oh=269d7e04eef192cae0392fe1adc73a72&oe=5DFCD0D6'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<Post>(
                          future: fetchPost(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "${snapshot.data.name}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "kanit",
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                        FutureBuilder<Post>(
                          future: fetchPost(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "${snapshot.data.points}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.green,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          alignment: Alignment(0, 0),
                          child: Text(
                            "Point",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Historybutton(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "  ร้านค้าที่ร่วมรายการ",
              style: TextStyle(
                fontFamily: 'Kanit',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: myshop,
            ),
          ]),
        ),
      ),
    ));
  }

  createRecord() async {
    const url = "https://smart-point.000webhostapp.com/adddata.php";
    int c = 0;
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
      c = 1;
      if (c == 1) {
        closeWebView();
        print("No");
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      String code = "https://www.smartpoint.com";
      if (barcode == code) {
        if (text == 'a') {
          points += 1;
          createRecord();
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.success,
            title: "สำเร็จ",
            // desc: "แต้มของคุณคือ$pointsแต้ม",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                color: Color.fromRGBO(0, 179, 134, 1.0),
                radius: BorderRadius.circular(8.0),
              ),
            ],
          ).show();
        }
      } else {
        Alert(
          context: context,
          style: alertStyle,
          type: AlertType.warning,
          title: "QRCodeไม่ถูกต้อง",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(0, 179, 134, 1.0),
              radius: BorderRadius.circular(8.0),
            ),
          ],
        ).show();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // The user did not grant the camera permission.
      } else {
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      // Unknown error.
    }
  }
}

Widget myshop = Container(
    // margin: EdgeInsets.symmetric(vertical: 20.0),
    height: 275,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: furnitures.length,
      itemBuilder: (BuildContext context, int index) {
        Map furniture = furnitures[index];
        return Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            child: Container(
              height: 275,
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.purple,
                      gradient: new LinearGradient(
                        colors: [Color(0xFF96B2CC), Color(0xFF6EAEF0)],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "${furniture["img"]}",
                        height: 240,
                        width: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    furniture['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(),
                ),
              );
            },
          ),
        );
      },
    ));

Widget bank = Container(
    margin: EdgeInsets.symmetric(vertical: 20.0),
    height: 200.0,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: 160.0,
          color: Colors.red,
        ),
        Container(
          width: 160.0,
          color: Colors.blue,
        ),
        Container(
          width: 160.0,
          color: Colors.green,
        ),
        Container(
          width: 160.0,
          color: Colors.yellow,
        ),
        Container(
          width: 160.0,
          color: Colors.orange,
        ),
      ],
    ));

class Historybutton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Align(
        child: RaisedButton(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          textColor: Colors.white,
          color: Colors.black,
          elevation: 6.0,
          child: Text(
            "ประวัติย้อนหลัง",
            style: TextStyle(
              fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile("Profile"),
              ),
            );
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset('assets/logo2.png'),
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/Profile.jpg'),
            radius: 50,
          ),
        ],
      ),
    ));
  }
}
