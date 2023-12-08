import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wingman/screens/response_screen.dart';
import 'package:wingman/helpers/constants.dart';
import 'package:wingman/helpers/image_helper.dart';
import 'package:wingman/helpers/server_helper.dart';

import '../helpers/ad_helper.dart';

RewardedAd? _rewardedAd;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
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
  
  int _selectedContainerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50,),

            // title
            const Text("Wingman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
      
            // gap
            const SizedBox(height: 40,),

            // prompt + gridview 
            const Center(child: Text("Submit a screenshot of your dating app conversation and get a quality response!", style: TextStyle( fontSize: 16),textAlign: TextAlign.center, )),
            const SizedBox(height: 20,),

            // prompt + gridview 
            const Text("I want my response to be...", style: TextStyle( fontSize: 16), textAlign: TextAlign.left, ),
            const SizedBox(height: 20,),

            GridView.builder(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              primary: false,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedContainerIndex == index) {
                        _selectedContainerIndex = -1; // Reset if tapped again
                      } else {
                        _selectedContainerIndex = index;
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: _selectedContainerIndex == index ? Colors.blue[500] : Colors.blue[100],
                      border: _selectedContainerIndex == index
                          ? Border.all(color: Colors.black, width: 4.0)
                          : null,
                      borderRadius: BorderRadius.circular(10)

                    ),
                    child: Center(
                      child: Text(
                        Constants.responseOptions[index],
                        style: TextStyle(
                          color: _selectedContainerIndex == index ? Colors.white : Colors.black,
                          // fontSize: _selectedContainerIndex == index ? 16 : 14,
                          fontWeight: _selectedContainerIndex == index ? FontWeight.bold : FontWeight.normal,

                        ),
                      ),
                    ),
                  )
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity, // Makes the FAB wide
          child: FloatingActionButton.extended(
            onPressed: () async {
              // pick file 
              File? image = await pickImage();

              // if image was chosen, then ask user if he wants to watch ad / go premium 
              if (image == null) return;               
              _adOrPremiumDialog(image);
            },
            icon: const Icon(Icons.add),
            label: const Text('Upload Screenshot'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
  
  Future<void> _adOrPremiumDialog(File selectedPhoto) {
    return showDialog<void>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: const Text("Choose option"),
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
                  // after photo selection, pass photo and response style to the server
                  var futureResponse = ServerHelper.sendPhoto(
                    selectedPhoto, 
                  _selectedContainerIndex == -1 ? Constants.responseOptions.first : Constants.responseOptions[_selectedContainerIndex]
                  );

									_rewardedAd?.show(
										onUserEarnedReward: (_, reward) {
											Navigator.push(
												context,
												MaterialPageRoute(builder: (context) => ResponseScreen(futureResponse)),
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
                  // after photo selection, pass photo and response style to the server
                  var futureResponse = ServerHelper.sendPhoto(
                    selectedPhoto, 
                  _selectedContainerIndex == -1 ? Constants.responseOptions.first : Constants.responseOptions[_selectedContainerIndex]
                  );

									// TODO: premium page 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResponseScreen(futureResponse)),
                  );
									
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