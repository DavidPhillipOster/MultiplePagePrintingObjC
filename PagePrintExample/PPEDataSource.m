//  PPEDataSource.m
// by David Phillip Oster 2021
// License: APACHE Version 2

#import "PPEDataSource.h"
#import "PPELabelView.h"
#import "PPEModel.h"
#import "PPEModelItem.h"

@implementation PPEDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  NSInteger n =  [self.model.items count];
  n = ceil(n/(double)MAX(1, tableView.numberOfColumns));
  return n;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
  PPELabelView *cellView = [tableView makeViewWithIdentifier:@"Label" owner:self];
  NSUInteger index = row*tableView.numberOfColumns + tableColumn.identifier.integerValue;
  NSInteger count =  [self.model.items count];
  PPEModelItem *item = nil;
  if (index < count) {
    item = self.model.items[index];
  }
  cellView.objectValue = item;
  return cellView;
}

@end
