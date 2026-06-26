import 'package:flutter/material.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/screens/NavigationScreen/mainNavigationScreen.dart';
import 'package:stuhub/screens/setup/sessionSetupScreen.dart';
import 'package:stuhub/screens/setup/subjectsSetupScreen.dart';
import 'package:stuhub/screens/setup/timaTableSetupScreen.dart';

class SetupGateScreen extends StatefulWidget {
  final bool showRestoreOption ;
  const SetupGateScreen({super.key,this.showRestoreOption = false});

  @override
  State<SetupGateScreen> createState() => _SetupGateScreenState();
}

class _SetupGateScreenState extends State<SetupGateScreen> {

  @override
  void initState() {
    super.initState();
    _checkSetup();
  }

//checkUp function
    Future<void> _checkSetup() async{
   final setup = await Setuprepository().getSetupStatus();

   final sessionDone = setup['session_completed']==1;
   final subjectsDone = setup['subjects_completed']==1;
   final timeTableDone = setup['timetable_completed']==1;

   if (!mounted) return;

   if(!sessionDone){
    //sessionSetupScreen
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
             SessionSetupScreen(showRestoreOption: widget.showRestoreOption,),
      ),
    );
    return;
   }
   if(!subjectsDone){
    //subjectSetupScreen
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
             SubjectSetupScreen(showRestoreOption: widget.showRestoreOption,),
      ),
    );
    return;
   }

   if(!timeTableDone){
    //timeTableSetupScreen
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
             TimatableSetupscreen(showRestoreOption: widget.showRestoreOption,),
      ),
    );
    return;
   }

   //Dashboard Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const Mainnavigationscreen(),
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}