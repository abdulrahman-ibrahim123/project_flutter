import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'history_manager.dart';
import 'profile_screen.dart';
import 'l10n/app_localizations.dart';


class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.email});
  final String email;
  //const UploadScreen({super.key, required email});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  String name = "";
  String age = "";
  String gender = "";
  String maritalStatus = "";
  String email = "";

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.uploadXray,
            //"Upload X-Ray",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // ياحمار ده بيغير لون السهم
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 40),

            // Container(
            //   height: 200,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.white24),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: const Center(
            //     child: Text(
            //       "Drag & Drop X-Ray Image",
            //       style: TextStyle(color: Colors.white70),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title:  Text(
                              AppLocalizations.of(context)!.gallery,
                                //"Choose from Gallery"
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title:  Text(
                              AppLocalizations.of(context)!.camera,
                                //"Use Camera"
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff1E293B),
                ),
                child: selectedImage == null
                    ?  Center(
                  child: Text(
                    AppLocalizations.of(context)!.tapToUpload,
                    //"Tap to upload X-Ray Image",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 40
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                ),
                onPressed: () async {

                  print("open profilr form upload");

                  final data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(email: widget.email),
                    ),
                  );

                  print("RECEIVED DATA: $data"); // 👈 مهم

                  if (data != null) {
                    print(data);
                    setState(() {
                      name = data["name"];
                      age = data["age"];
                      gender = data["gender"];
                      maritalStatus = data["maritalStatus"];
                      //email = data["email"];
                    });
                  }
                },
                child:  Text(
                  AppLocalizations.of(context)!.editProfile,
                    //"Edit Profile"
                ),
              ),
            ),

            if (name.isNotEmpty)
              Text(
                "Name: $name",
                style: const TextStyle(color: Colors.white),
              ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                ),

                //هنا الزار
                onPressed: () {
                  /// لو مفيش صورة
                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.uploadImageFirst,
                          //"Please upload image first"
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                // selectedImage == null
                //     ? null
                //     : () {

                  if (name.isEmpty || age.isEmpty || gender.isEmpty || maritalStatus.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.enterProfileFirst,
                            //"Please enter profile data first"
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  HistoryManager.history.add(
                      "Analyzed Image - ${DateTime.now()}"
                  );

                  print(name);
                  print(age);
                  print(gender);
                  print(maritalStatus);
                  print(email);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        name: name,
                        age: age,
                        gender: gender,
                        maritalStatus: maritalStatus,
                        email: widget.email,
                        diagnosis: "Pneumonia Detected",
                        confidence: 92.5,


                      ),
                    ),
                  );
                },

                child:  Text(
                  AppLocalizations.of(context)!.analyzeNow,
                  //"Analyze Now",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}