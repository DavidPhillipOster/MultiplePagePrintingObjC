//  PPEPrintBoss.m
// by David Phillip Oster 2021
// License: APACHE Version 2

#import "PPEPrintBoss.h"
#import "PPEDataSource.h"
#import "PPEModel.h"
#import "PPEPrintTableView.h"

@implementation PPEPrintBoss

- (NSView *)printableView {
  if (nil == _printableView) {
    NSAssert(self.printInfo, @"needs self.printInfo");
    NSAssert(self.dataSource, @"needs self.dataSource");

    NSPrintInfo *printInfo = self.printInfo;
    NSSize paperSize = printInfo.paperSize;
    NSSize pageContentSize = NSMakeSize(paperSize.width - printInfo.leftMargin - printInfo.rightMargin,
                                        paperSize.height - printInfo.topMargin - printInfo.bottomMargin);
    pageContentSize.width /= printInfo.scalingFactor;
    pageContentSize.height /= printInfo.scalingFactor;
    CGRect printPageFrame = CGRectMake(0, 0, pageContentSize.width, pageContentSize.height);

    PPEPrintTableView *tableView = [[PPEPrintTableView alloc] initWithFrame:printPageFrame];

    CGRect bounds = tableView.bounds;
    bounds.size.width /= printInfo.scalingFactor;
    bounds.size.height /= printInfo.scalingFactor;
    tableView.bounds = bounds;

    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"PPELabelView" bundle:nil];
    [tableView registerNib:nib forIdentifier:@"Label"];
    NSTableCellView *cellView = nil;
    NSArray *objs;
    if ([nib instantiateWithOwner:self topLevelObjects:&objs]) {
      for (id obj in objs) {
        if ([obj isKindOfClass:[NSTableCellView class]]) {
          cellView = obj;
          break;
        }
      }
    }
    NSAssert(cellView, @"needs label from nib");
    NSUInteger columnWidth = cellView.bounds.size.width;
    NSUInteger numColumns = MAX(1, floor(pageContentSize.width/columnWidth));
    for (NSUInteger i = 0; i < numColumns; ++i) {
      NSTableColumn *column = [[NSTableColumn alloc] init];
      column.identifier = [NSString stringWithFormat:@"%ld", (long)i];
      column.width = columnWidth;
      column.resizingMask = NSTableColumnNoResizing;
      [tableView addTableColumn:column];
    }
    tableView.intercellSpacing = CGSizeZero;
    tableView.rowHeight = cellView.bounds.size.height;
    tableView.rowsPerPage = MAX(1, floor(pageContentSize.height/tableView.rowHeight));
    tableView.itemCount = self.dataSource.model.items.count;
    tableView.itemsPerPage = tableView.rowsPerPage*numColumns;
    tableView.columnAutoresizingStyle = NSTableViewNoColumnAutoresizing;
    tableView.allowsColumnSelection = NO;
    tableView.allowsColumnResizing = NO;
    tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    tableView.allowsEmptySelection = YES;
    if (@available(macOS 11.0, *)) {
      // Avoid Big Sur's default horizontal padding
      tableView.style = NSTableViewStylePlain;
    }
    tableView.dataSource = self.dataSource;
    tableView.delegate = self.dataSource;
    [tableView reloadData];
    _printableView = tableView;
  }
  return _printableView;
}

@end
