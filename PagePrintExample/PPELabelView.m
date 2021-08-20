//  PPELabelView.m
// by David Phillip Oster 2021
// License: APACHE Version 2

#import "PPELabelView.h"
#import "PPEModelItem.h"

@interface PPELabelView ()
@property IBOutlet NSTextField *nameLabel;
@property IBOutlet NSTextField *addressLabel;
@end

@implementation PPELabelView

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  if (self.nameLabel.stringValue.length || self.addressLabel.stringValue.length) {
    NSFrameRect(self.bounds);
  }
}

- (void)setObjectValue:(id)objectValue {
  PPEModelItem *item = (PPEModelItem *)objectValue;
  self.nameLabel.stringValue = item.name ?: @"";
  self.addressLabel.stringValue = item.address ?: @"";
}

@end
