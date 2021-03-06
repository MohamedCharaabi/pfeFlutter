// import 'package:admin/models/RecentFile.dart';
import 'package:bottom_navigation/screens/admin_app/models/RecentFile.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key key,
  }) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  TextStyle txtStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Files",
            style: txtStyle,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Text(
                    "File Name",
                    style: txtStyle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Date",
                    style: txtStyle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Size",
                    style: txtStyle,
                  ),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              fileInfo.icon,
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                fileInfo.title,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date, style: TextStyle(color: Colors.white))),
      DataCell(Text(fileInfo.size, style: TextStyle(color: Colors.white))),
    ],
  );
}
