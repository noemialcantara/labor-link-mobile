import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for notifications
    final Map<String, List<Map<String, String>>> notifications = {
      'New Activity': [
        {
          'title': 'Final Interview with XYZ Corporation',
          'time': '12 minutes ago',
        },
        {
          'title': 'Contact from PAGCOR in 24 hours',
          'time': '5 months ago',
        },
      ],
      'Applications': [
        {
          'title': 'Application submitted to XYZ Corporation',
          'time': '2 days ago',
        },
        {
          'title': 'PAGCOR is reviewing your application',
          'time': '5 months ago',
        },
      ],
      'Interviews': [
        {
          'title': 'Interview with XYZ Corporation',
          'time': '4 hours ago',
        },
      ],
    };

    return  ListView(
        children: notifications.entries.map((entry) {
          return ExpansionTile(
            initiallyExpanded: true,
            title: Text(entry.key, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            children: entry.value.map((notification) {
              return ListTile(
                title: Text(notification['title']!, style: GoogleFonts.poppins(color: Colors.black)),
                subtitle: Text(notification['time']!),
              );
            }).toList(),
          );
        }).toList(),
      );
  }
}
