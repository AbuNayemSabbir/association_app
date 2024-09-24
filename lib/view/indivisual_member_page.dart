import 'package:association_app/utills/app_utills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'member_details_page.dart';

class IndividualMemberPage extends StatelessWidget {
  const IndividualMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppUtils.membersSectionTitle)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('members').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text(AppUtils.errorMessage);
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final member = snapshot.data!.docs[index];
              return ListTile(
                title: Text(member['name']),
                subtitle: Text(member['phone']),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MemberDetailPage( phoneNumber: member['phone']))),
              );
            },
          );
        },
      ),
    );
  }
}
