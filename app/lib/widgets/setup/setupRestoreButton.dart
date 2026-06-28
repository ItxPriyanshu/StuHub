import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/circularloadingProvider.dart';
import 'package:stuhub/repositories/restoreRepository.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/screens/NavigationScreen/mainNavigationScreen.dart';

class RestoreBackupButton extends ConsumerWidget {
  const RestoreBackupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.cloud_download,color: Colors.grey,),
      label: const Text("Restore Previous Data",style: TextStyle(color: Colors.grey),),

      onPressed: () async {
        final loading = ref.read(circularloadingProvider.notifier);

        loading.state = true;

        try {
          await Restorerepository().restoreAll();

          // Mark setup as completed
    await Setuprepository().markSessionComplete();
    await Setuprepository().markSubjectsComplete();
    await Setuprepository().markTimeTableComplete();


          ApprefreshServiceProvider.refreshAll(ref);

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const Mainnavigationscreen(),
            ),
            (_) => false,
          );
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        } finally {
          loading.state = false;
        }
      },
    );
  }
}