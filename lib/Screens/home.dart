import 'package:bims/Screens/certs.dart';
import 'package:bims/Screens/profile.dart';
import 'package:bims/cloud/firestore_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BIMSHome extends StatelessWidget {
  const BIMSHome({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listData = [];

    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/bims-logo-white-black.png'),
            ),
          ),
          flexibleSpace: SizedBox(
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledForegroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white,
                  ),
                  child: const Text('Home'),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CertificateScreen(),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text('Certificates'),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ProfileScreen(),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent, // text color
                  ),
                  child: const Text('Profile'),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
              child: Stack(
            children: [
              Image.asset(
                'assets/community.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Center(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 300,
                height: MediaQuery.of(context).size.height - 200,
                child: FutureBuilder(
                  future: FirestoreService().read(collection: 'users'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;
                        for (var document in querySnapshot.docs) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          listData.add({
                            'age': data['age'],
                            'gender': data['gender'],
                            'voter': data['voter'],
                            'pwd': data['pwd']
                          });
                        }
                        print('data $listData');
                        int group1Count = listData
                            .where((item) =>
                                item['age'] != null &&
                                int.tryParse(item['age']) != null &&
                                int.parse(item['age']) <= 17)
                            .length;
                        int group2Count = listData
                            .where((item) =>
                                item['age'] != null &&
                                int.tryParse(item['age']) != null &&
                                int.parse(item['age']) >= 18 &&
                                int.parse(item['age']) <= 30)
                            .length;
                        int group3Count = listData
                            .where((item) =>
                                item['age'] != null &&
                                int.tryParse(item['age']) != null &&
                                int.parse(item['age']) >= 31 &&
                                int.parse(item['age']) <= 50)
                            .length;
                        int group4Count = listData
                            .where((item) =>
                                item['age'] != null &&
                                int.tryParse(item['age']) != null &&
                                int.parse(item['age']) > 50)
                            .length;

                        List<Map<String, dynamic>> ageData = [
                          {'group': '0-17', 'count': group1Count},
                          {'group': '18-30', 'count': group2Count},
                          {'group': '31-50', 'count': group3Count},
                          {'group': '50+', 'count': group4Count},
                        ];

                        List<charts.Series<Map<String, dynamic>, String>>
                            ageSeries = [
                          charts.Series(
                            id: "Age",
                            data: ageData,
                            domainFn: (Map<String, dynamic> item, _) =>
                                item['group'],
                            measureFn: (Map<String, dynamic> item, _) =>
                                item['count'],
                            labelAccessorFn: (Map<String, dynamic> item, _) =>
                                '${item['count']}',
                          )
                        ];

                        int maleCount = listData
                            .where((item) => item['gender'] == 'male')
                            .length;
                        int femaleCount = listData
                            .where((item) => item['gender'] == 'female')
                            .length;
                        int lgbtqCount = listData
                            .where((item) => item['gender'] == 'lgbtq')
                            .length;
                        List<Map<String, dynamic>> genderData = [
                          {'gender': 'male', 'count': maleCount},
                          {'gender': 'female', 'count': femaleCount},
                          {'gender': 'lgbtq', 'count': lgbtqCount},
                        ];

                        List<charts.Series<Map<String, dynamic>, String>>
                            genderSeries = [
                          charts.Series(
                            id: "Gender",
                            data: genderData,
                            domainFn: (Map<String, dynamic> item, _) =>
                                item['gender'],
                            measureFn: (Map<String, dynamic> item, _) =>
                                item['count'],
                            labelAccessorFn: (Map<String, dynamic> item, _) =>
                                '${item['count']}',
                          )
                        ];

                        int voterCount =
                            listData.where((item) => item['voter']).length;
                        int nonVoterCount =
                            listData.where((item) => !item['voter']).length;
                        List<Map<String, dynamic>> voterData = [
                          {'voter': true, 'count': voterCount},
                          {'voter': false, 'count': nonVoterCount},
                        ];

                        List<charts.Series<Map<String, dynamic>, String>>
                            voterSeries = [
                          charts.Series(
                            id: "Voter",
                            data: voterData,
                            domainFn: (Map<String, dynamic> item, _) =>
                                item['voter'] ? 'Voter' : 'Non-Voter',
                            measureFn: (Map<String, dynamic> item, _) =>
                                item['count'],
                            labelAccessorFn: (Map<String, dynamic> item, _) =>
                                '${item['voter'] ? 'Voter' : 'Non-Voter'}: ${item['count']}',
                          )
                        ];

                        int pwdCount =
                            listData.where((item) => item['pwd']).length;
                        int nonPwdCount =
                            listData.where((item) => !item['pwd']).length;
                        List<Map<String, dynamic>> pwdData = [
                          {'pwd': true, 'count': pwdCount},
                          {'pwd': false, 'count': nonPwdCount},
                        ];

                        List<charts.Series<Map<String, dynamic>, String>>
                            pwdSeries = [
                          charts.Series(
                            id: "PWD",
                            data: pwdData,
                            domainFn: (Map<String, dynamic> item, _) =>
                                item['pwd'] ? 'PWD' : 'Non-PWD',
                            measureFn: (Map<String, dynamic> item, _) =>
                                item['count'],
                            labelAccessorFn: (Map<String, dynamic> item, _) =>
                                '${item['pwd'] ? 'PWD' : 'Non-PWD'}: ${item['count']}',
                          )
                        ];
                        return ListView(
                          children: [
                            SizedBox(
                              height: 400,
                              child: charts.BarChart(
                                ageSeries,
                                animate: true,
                                vertical: false,
                              ),
                            ),
                            const Center(child: Text('Age Groups')),
                            const Divider(),
                            SizedBox(
                              height: 400,
                              child: charts.BarChart(
                                genderSeries,
                                animate: true,
                                vertical: false,
                              ),
                            ),
                            const Center(child: Text('Gender')),
                            const Divider(),
                            SizedBox(
                              height: 400,
                              child: charts.BarChart(
                                voterSeries,
                                animate: true,
                                vertical: false,
                              ),
                            ),
                            const Center(child: Text('Voter/Non-Voter')),
                            const Divider(),
                            SizedBox(
                              height: 400,
                              child: charts.BarChart(
                                pwdSeries,
                                animate: true,
                                vertical: false,
                              ),
                            ),
                            const Center(child: Text('PWD/Non-PWD')),
                          ],
                        );
                      } else {
                        return const Center(child: Text('Empty'));
                      }
                    }
                  },
                ),
              )),
            ],
          )),
        ));
  }
}
