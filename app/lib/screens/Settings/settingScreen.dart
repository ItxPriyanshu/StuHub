import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/circularloadingProvider.dart';
import 'package:stuhub/providers/userProfileProvider.dart';
import 'package:stuhub/repositories/backupRepository.dart';
import 'package:stuhub/repositories/restoreRepository.dart';
import 'package:stuhub/screens/Settings/editSessionScreen.dart';
import 'package:stuhub/screens/Settings/editTimeTableScreen.dart';
import 'package:stuhub/screens/Settings/manageSubjectsScreen.dart';
import 'package:stuhub/screens/Settings/profileManagementScreen.dart';
import 'package:stuhub/screens/Settings/resetAttendanceDialog.dart';
import 'package:stuhub/screens/Settings/resetSessionDialog.dart';
import 'package:stuhub/widgets/settings/setting_tile.dart';

class Settingscreen extends ConsumerWidget {
  const Settingscreen({super.key});

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.robotoMono(
          color: Colors.white70,
          letterSpacing: 2,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final isLoading = ref.watch(circularloadingProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children:[ SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
        
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
        
              children: [
                Text(
                  "Settings",
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
                const SizedBox(height: 8),
        
                Text(
                  "Manage your account and academic data",
                  style: GoogleFonts.manrope(color: Colors.white60),
                ),
        
                const SizedBox(height: 30),
        
                // PROFILE
                profile.when(
                  data: (user) {
                    if (user == null) {
                      return const SizedBox();
                    }
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xff121212),
                            
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: InkWell(
                         onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileManagementScreen(),
                          ),
                        );
                      },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: user.profileImage != null
                                  ? FileImage(File(user.profileImage!))
                                  : null,
                              
                              child: user.profileImage == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                              
                            const SizedBox(width: 16),
                              
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username,
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                              
                                      fontWeight: FontWeight.bold,
                              
                                      fontSize: 18,
                                    ),
                                  ),
                              
                                  Text(
                                    user.email,
                                    style: GoogleFonts.manrope(
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (_, _) => const SizedBox(),
                  loading: () => const SizedBox(),
                ),
        
                const SizedBox(height: 30),
        
                sectionTitle("DATA MANAGEMENT"),
        
                SettingTile(
                  icon: Icons.cloud_upload_outlined,
                  iconColor: Colors.green,
                  title: "Backup Data",
                  subtitle: "Upload attendance, subjects, timetable and session",
                  onTap: () async{
                    final loading = ref.read(circularloadingProvider.notifier);
                    loading.state= true;
                    try {
                      await Backuprepository().backupAll();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("backup Completed")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
                    }finally{
                      loading.state = false;
                    }
                  },
                ),
        
                const SizedBox(height: 12),
        
                SettingTile(
                  icon: Icons.cloud_download_outlined,
                  iconColor: Colors.blueAccent,
                  title: "Restore Data",
                  subtitle: "Replace local data with cloud backup",
                  onTap: ()async{
                    final shouldRestore = await showDialog<bool>(context: context, builder: (_){
                      return AlertDialog(
                        title: const Text("Restore Backup?"),
                        content: const Text("This will replace all local data with cloud backup."),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.white),
                            onPressed: (){
                            Navigator.pop(context,false);
                          }, child: const Text("Cancel")),
        
        
                          ElevatedButton(
                            
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white
                            ),
                            onPressed: (){
                            Navigator.pop(context,true);
                          }, child: const Text("Restore",style: TextStyle(fontWeight: FontWeight.bold),)),
                        ],
                      );
                    });
                    if(shouldRestore != true){return;}
                    final loading = ref.read(circularloadingProvider.notifier);
                    loading.state = true;
                    try {
                      await Restorerepository().restoreAll();
                      ApprefreshServiceProvider.refreshAll(ref);
                      if(context.mounted){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Restore completed")));
                      }
                    } catch (e) {
                      if(context.mounted){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }finally{
                      loading.state = false;
                    }
                  },
                ),
        
                // const SizedBox(height: 12),
        
                // SettingTile(
                //   icon: Icons.history,
                //   iconColor: Colors.grey,
                //   title: "Last Backup",
                //   subtitle: "Never",
                //   showArrow: false,
                // ),
        
                const SizedBox(height: 30),
        
                sectionTitle("ACADEMIC SETTINGS"),
        
                SettingTile(
                  icon: Icons.menu_book_outlined,
                  iconColor: Colors.orange,
                  title: "Manage Subjects",
                  subtitle: "Add, edit or remove subjects",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const Managesubjectsscreen()));
                  },
                ),
        
                const SizedBox(height: 12),
        
                SettingTile(
                  icon: Icons.calendar_month,
                  iconColor: Colors.orange,
                  title: "Edit Timetable",
                  subtitle: "Modify weekly class schedule",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const Edittimetablescreen()));
        
                  },
                ),
        
                const SizedBox(height: 12),
        
                SettingTile(
                  icon: Icons.school_outlined,
                  iconColor: Colors.orange,
                  title: "Edit Session",
                  subtitle: "Change semester dates",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const EditSessionScreen()));
        
                  },
                ),
        
                const SizedBox(height: 30),
        
                sectionTitle("DANGER ZONE"),
        
                SettingTile(
                  icon: Icons.restart_alt,
                  iconColor: Colors.redAccent,
                  title: "Reset Attendance",
                  subtitle: "Delete attendance records only",
                  onTap: (){
                    showResetAttendanceDialog(context, ref);
                  }
                ),
        
                const SizedBox(height: 12),
        
                SettingTile(
                  icon: Icons.delete_forever,
                  iconColor: Colors.redAccent,
                  title: "Reset Entire Session",
                  subtitle: "Delete all academic data",
                  onTap: (){
                    showResetSessionDialog(context, ref);
                  },
                ),
        
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
        if(isLoading)
        Container(color: Colors.black54,
        child:  Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Text("Connecting to server...",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
               const SizedBox(height: 20,),
               SizedBox(
                height: 40,
                width: 40,
                child: Lottie.asset("assets/lotties/connectivity.json")),
            ],
          )
        ),)
        ],
      ),
    );
  }
}
