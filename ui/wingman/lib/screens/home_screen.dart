import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wingman/screens/response_screen.dart';
import 'package:wingman/shared/constants.dart';

import '../shared/ad_helper.dart';

RewardedAd? _rewardedAd;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _loadRewardedAd();
    super.initState();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
							// after ad is played, dispose ad and load a new one. 
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
	}


  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      _adOrPremiumDialog();


      return File(image.path); 
    } on PlatformException catch(e) {
      // TODO tell user to enable photo permissions
      print("Failed to pick image $e"); 
      return null;
    }
       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // title
            Text("Wingman"),
      
            // prompt + gridview 
            Text("I want my response to be..."),
            
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: Constants.responseOptions.length,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(Constants.responseOptions[index]),
                  ],
                );
              },
            ),
      
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity, // Makes the FAB wide
          child: FloatingActionButton.extended(
            onPressed: () async {
              // pick file 
              File? image = await pickImage();
              if (image == null) return; 

              // prompt user for the ad here

            },
            icon: Icon(Icons.add),
            label: Text('Upload Screenshot'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
  
  Future<void> _adOrPremiumDialog() {
    return showDialog<void>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text("Choose option"),
					content: const SingleChildScrollView(
						child: ListBody(
							children: <Widget>[
								Text('Response will be given after choosing an option'),
							],
						),
					),
					actions: <Widget>[
						Center(
							child: ElevatedButton(
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.black, 
									foregroundColor: Colors.white,
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(5.0),
									),	
									
								),
								onPressed: () {
									_rewardedAd?.show(
										onUserEarnedReward: (_, reward) {
											Navigator.push(
												context,
												MaterialPageRoute(builder: (context) => ResponseScreen()),
												// (Route<dynamic> route) => false
											);
										},
									);
								},
								child: const Text('Watch an ad'),
							),
						),
						Center(
							child: ElevatedButton(
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.black, 
									foregroundColor: Colors.white, 
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(5.0),
									),
								),
								onPressed: () {
									// TODO: premium page 
									
								},
								child: const Text('Go premium'),
							),
						),
					],
				);
			},
		);
  }
}