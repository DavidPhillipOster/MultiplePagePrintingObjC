//  PPEModelItem.m
// by David Phillip Oster 2021
// License: APACHE Version 2

#import "PPEModelItem.h"

static NSString *const kName = @"name";
static NSString *const kAddress = @"address";

@implementation PPEModelItem

- (instancetype)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.name = dict[kName];
    self.address = dict[kAddress];
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  dict[kName] = self.name;
  dict[kAddress] = self.address;
  return dict;
}

@end
