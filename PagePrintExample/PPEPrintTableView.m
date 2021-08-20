//  PPEPrintTableView.m
// by David Phillip Oster 2021
// License: APACHE Version 2
#import "PPEPrintTableView.h"

@implementation PPEPrintTableView

- (BOOL)knowsPageRange:(NSRangePointer)range {
  if (0 < self.itemsPerPage) {
    NSInteger numPages = ceil(self.itemCount/(CGFloat)self.itemsPerPage);
    *range = NSMakeRange(1, numPages);
    return YES;
  }
  return NO;
}

- (NSRect)rectForPage:(NSInteger)page {
  CGFloat height = self.rowHeight*self.rowsPerPage;
  return NSMakeRect(0, height*(page-1), self.frame.size.width, height);
}

@end
