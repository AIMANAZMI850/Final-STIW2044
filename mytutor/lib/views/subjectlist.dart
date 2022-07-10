import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytutor1/models/user.dart';
import 'package:mytutor1/views/cartscreen.dart';
import 'package:mytutor1/views/loginscreen.dart';
import 'package:mytutor1/views/registerscreen.dart';
import '../config.dart';
import '../models/subject.dart';

class SubjectList extends StatefulWidget {
  final User user;
  const SubjectList({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";

  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadSubjects(1, search);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subject Lists',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
              onPressed: () async {
                if (widget.user.email == "guest@gmail.com") {
                  _loadOptions();
                } else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => CartScreen(
                                user: widget.user,
                              )));
                  _loadSubjects(1, search);
                  _loadMyCart();
                }
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label: Text(
                widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: subjectList.isEmpty
          ? const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            )
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1),
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                            splashColor: Colors.red,
                            onTap: () => {_loadSubjectDetails(index)},
                            child: Card(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(children: [
                                  Flexible(
                                    flex: 5,
                                    child: CachedNetworkImage(
                                      imageUrl: Config.server +
                                          "/mytutor/assets/courses/" +
                                          subjectList[index]
                                              .subjectId
                                              .toString() +
                                          '.jpg',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                            border: const Border(
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.colorBurn),
                                            )),
                                      ),
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    subjectList[index].subjectName.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: IconButton(
                                          onPressed: () {
                                            _addtocartDialog(index);
                                          },
                                          icon:
                                              const Icon(Icons.shopping_cart))),
                                ])));
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadSubjects(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(Config.server + "/mytutor/Users/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
          titlecenter = subjectList.length.toString() + " Subjects Available";
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search Subject ",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Enter subjects name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Course Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: Config.server +
                      "/mytutor/assets/courses/" +
                      subjectList[index].subjectId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subjectList[index].subjectName.toString(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      "\nDescription: \n" +
                          subjectList[index].subjectDescription.toString(),
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      "\nPrice: RM " +
                          double.parse(
                                  subjectList[index].subjectPrice.toString())
                              .toStringAsFixed(2),
                      style: const TextStyle(fontSize: 12)),
                  Text("\nTutor ID: " + subjectList[index].tutorId.toString(),
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      "\nSessions: " +
                          subjectList[index].subjectSessions.toString(),
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      "\nRatings: " +
                          subjectList[index].subjectRating.toString(),
                      style: const TextStyle(fontSize: 12)),
                ]),
              ],
            )),
            actions: [
              SizedBox(
                width: screenWidth / 1,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Add to cart")),
              )
            ],
          );
        });
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Please Choose",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _onLogin, child: const Text("Login")),
                ElevatedButton(
                    onPressed: _onRegister, child: const Text("Register")),
              ],
            ),
          );
        });
  }

  _addtocartDialog(int index) {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _confirmationDialog(index);
    }
  }

  void _confirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Confirmation",
            style: TextStyle(),
          ),
          content: const Text("Are you confirm?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _addtoCart(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegisterScreen()));
  }

  void _loadMyCart() {
    if (widget.user.email != "guest@gmail.com") {
      http.post(
          Uri.parse(Config.server + "/mytutor/Users/php/load_cartqty.php"),
          body: {
            "user_email": widget.user.email.toString(),
          }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.user.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
    }
  }

  void _addtoCart(int index) {
    http.post(Uri.parse(Config.server + "/mytutor/Users/php/insert_cart.php"),
        body: {
          "user_email": widget.user.email.toString(),
          "subject_id": subjectList[index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 12.0);
      }
    });
  }
}
