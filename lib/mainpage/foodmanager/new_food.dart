import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_test/colors.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_vision/google_vision.dart' as go;
import 'package:flutter/src/widgets/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Todo {
  //還有到期日
  //final String date;
  //final String url;//圖片
  final String title;
  final int number;

  const Todo(
    this.title,
    this.number,
  );
}

class NewFood extends StatefulWidget {
  const NewFood({Key? key}) : super(key: key);

  @override
  State<NewFood> createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  //圖片標籤
  XFile? imageFile;
  String temp = "";
  String _image = '';
  //控制數量
  final controller = TextEditingController();
  int count = 0;
  void incrementCounter() {
    setState(() {
      count++;
    });
  }
  void decrementCounter() {
    setState(() {
      count--;
    });
  }
  //date
  DateTime _dateTime =DateTime.now();

  @override
  void inidState() {
    super.initState();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    print('新增食材的dispose方法');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, //不讓畫面因為鍵盤超出頁面
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Im.Image.asset("assets/icons/back.png"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            '新增食材',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        //主要新增的地方
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _image == ''
                    ? Container(
                        width: 200,
                          height: 200,
                          color: Colors.grey[300]!,
                        )
                    : Im.Image.file(
                    File(_image),
                    height: 200,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      width: 200,
                      height: 200,
                      child: const Center(
                        child: Text('Error load image',
                            textAlign: TextAlign.center),
                    ),
                  ),
                ),
                //相簿或相機
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),

                //名字
                Container(
                  alignment: Alignment.center,
                  //外部間距
                  //margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  //外部間距
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  width: 300,
                  color: Colors.grey[100],
                  child: TextField(
                    controller: controller,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: "名稱：",
                      labelStyle: TextStyle(
                        color: kPrimaryColor.withOpacity(0.5),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan,
                          width: 2,
                        ),
                      ),
                      // surffix isn't working properly  with SVG
                      // thats why we use row
                      // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                    ),
                  ),
                ),

                //數量
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor.withOpacity(0.23),
                          textStyle: TextStyle(fontSize: 30.0),
                        ),
                        onPressed: () => {
                          decrementCounter(),
                        },
                        child: Text("-"),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          "$count",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor.withOpacity(0.23),
                          textStyle: TextStyle(fontSize: 30.0),
                        ),
                        onPressed: () => {
                          incrementCounter(),
                        },
                        child: Text("+"),
                      ),
                    ],
                  ),
                ),

                //時間
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Text(
                        _dateTime.year.toString()+"/"+_dateTime.month.toString()+"/"+_dateTime.day.toString()+"    ",
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                        ),
                        onPressed: () => {_showDatePiker()},
                        child: Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                          color: Colors.red,),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        textStyle: TextStyle(fontSize: 30.0),
                      ),
                      onPressed: () => {Navigator.pop(context)},
                      child: Text("取消"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        textStyle: TextStyle(fontSize: 30.0),
                      ),
                      onPressed: () => {
                        Navigator.of(context, rootNavigator: true).pop(
                          controller.text,
                        ),
                        controller.clear(),
                      },
                      child: Text("確認"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = pickedImage;
        setState(() {});
        getvisionai(pickedImage);

      }
    } catch (e) {
      imageFile = null;
      //imageLabel = "Error occurred while getting image Label";
      print(e);
      setState(() {});
    }
  }

  Future<String> getFileFromAsset(String assetFileName,
      {String? temporaryFileName}) async {
    final byteData = await rootBundle.load('$assetFileName');

    final buffer = byteData.buffer;

    final fileName = temporaryFileName ?? assetFileName;

    final filePath = await getTempFile(fileName);

    try {
      await File(filePath).delete();
    } catch (e) {
      // ignore
    }

    await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return filePath;
  }

  Future<String> getTempFile([String? fileName]) async {
    final tempDir = await getTemporaryDirectory();

    return '${tempDir.path}${Platform.pathSeparator}${fileName ?? const Uuid().v4()}';
  }

  void getvisionai(XFile image) async {
    final credentialsJsonAsString =
    await rootBundle.loadString('assets/speedy-cargo-395914-3b5978de2782.json');
    final googleVision =
    await go.GoogleVision.withJwt(credentialsJsonAsString);


    final painter =
    go.Painter.fromFilePath(image.path);
    // cropping an image can save time uploading the image to Google
    final cropped = painter.copyCrop(30, 30, 400, 400);

    final filePath =
    await getTempFile(image.name);

    final requests = go.AnnotationRequests(requests: [
      go.AnnotationRequest(image: go.Image(painter: cropped),  features: [
        go.Feature(maxResults: 10, type: 'FACE_DETECTION'),
        go.Feature(maxResults: 10, type: 'OBJECT_LOCALIZATION')
      ])
    ]);

    print('checking...');

    go.AnnotatedResponses annotatedResponses =
    await googleVision.annotate(requests: requests);

    print('done.\n');

    for (var annotatedResponse in annotatedResponses.responses) {
      for (var faceAnnotation in annotatedResponse.faceAnnotations) {
        go.GoogleVision.drawText(
            cropped,
            faceAnnotation.boundingPoly.vertices.first.x + 2,
            faceAnnotation.boundingPoly.vertices.first.y + 2,
            'Face - ${faceAnnotation.detectionConfidence}');

        go.GoogleVision.drawAnnotations(
            cropped, faceAnnotation.boundingPoly.vertices);
      }
    }

    for (var annotatedResponse in annotatedResponses.responses) {
      annotatedResponse.localizedObjectAnnotations
          .where((localizedObjectAnnotation) =>
      localizedObjectAnnotation.name != 'Person')
          .toList()
          .forEach((localizedObjectAnnotation) {
        go.GoogleVision.drawText(
            cropped,
            (localizedObjectAnnotation.boundingPoly.normalizedVertices.first.x )
                .toInt(),
            (localizedObjectAnnotation.boundingPoly.normalizedVertices.first.y )
                .toInt() ,
            ''
            //'${localizedObjectAnnotation.name} - ${localizedObjectAnnotation.score}'
        );

        go.GoogleVision.drawAnnotationsNormalized(
            cropped, localizedObjectAnnotation.boundingPoly.normalizedVertices);
        setState(() {
          if(localizedObjectAnnotation.name !=null){
          controller.text = localizedObjectAnnotation.name;}
          else{
            controller.text="超出範圍請重新辨識或手動輸入";
          }
        });
          });
    }

    await cropped.writeAsJpeg(filePath);
    setState(() {
      _image = filePath;
    });
  }

  void _showDatePiker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2026)
    ).then((value){
      setState(() {
        _dateTime= value!;
      });
    });
  }
}
