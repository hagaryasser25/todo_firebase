import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_firebase/models/images_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_player/video_player.dart';

class ImagesVideos extends StatefulWidget {
  static const routeName = '/ImagesVideos';
  const ImagesVideos({Key? key}) : super(key: key);

  @override
  State<ImagesVideos> createState() => _ImagesVideosState();
}

class _ImagesVideosState extends State<ImagesVideos> {
  late DatabaseReference base, base1;
  late FirebaseDatabase database, database1;
  late FirebaseApp app, app1;
  List<Images> imageList = [];
  List<String> keyslist = [];
  final storageRef = FirebaseStorage.instance.ref();
  String? url;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchPhotos();
    getImage();
  }

  void getImage() async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    url = await storage
        .ref('WhatsApp Video 2023-01-10 at 4.40.19 PM.mp4')
        .getDownloadURL();
    print(url);
  }

  void fetchPhotos() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("photos");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Images p = Images.fromJson(event.snapshot.value);
      imageList.add(p);

      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      (Image.network(
                        imageList[index].imageUrl.toString(),
                      )),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
