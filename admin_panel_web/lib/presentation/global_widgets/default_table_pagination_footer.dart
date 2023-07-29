import 'package:admin_panel_web/presentation/global_widgets/table_pagination_widget.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultTablePaginationFooter extends StatefulWidget {
  final PlutoGridStateManager stateManager;

  const DefaultTablePaginationFooter({super.key, required this.stateManager});

  @override
  State<DefaultTablePaginationFooter> createState() =>
      _DefaultTablePaginationFooterState();
}

class _DefaultTablePaginationFooterState
    extends State<DefaultTablePaginationFooter> {
  PlutoGridStateManager get stateManager => widget.stateManager;

  int pageNumber = 1;
  int pageSize = 50;

  @override
  void initState() {
    super.initState();
    stateManager.setPage(pageNumber);
    stateManager.setPageSize(pageSize);
    setState(() {});
    stateManager.addListener(() {
      setState(() {
        pageNumber = stateManager.page;
        pageSize = stateManager.pageSize;
      });
    });
  }

  void changePageSize(int size) {
    setState(() {
      pageSize = size;
    });
    stateManager.setPageSize(size);
    stateManager.setPage(1);
  }

  void changePageNumber(int number) {
    setState(() {
      pageNumber = number;
    });
    stateManager.setPage(number);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Page size changer
            DefaultDropdown(
              height: 60,
              width: MediaQuery.sizeOf(context).width * 0.15,
              label: "Page Size",
              valueId: stateManager.pageSize,
              onChanged: (value) {
                changePageSize(value.id);
              },
              items: [
                for (int pageSize in GlobalConstants.pageSizes)
                  DefaultMenuItem(
                    id: pageSize,
                    title: pageSize.toString(),
                  ),
              ],
            ),
            // Text(
            //   "Total: ${stateManager.totalPage * stateManager.pageSize} items",
            //   style: context.textTheme.titleMedium,
            // ),

            //Page number
            TablePaginationWidget(
                totalPages: stateManager.totalPage,
                onPageChanged: changePageNumber,
                currentPage: stateManager.page),
          ],
        ),
      ),
    );
  }
}
