//  PPEModel.m
// by David Phillip Oster 2021
// License: APACHE Version 2

#import "PPEModel.h"
#import "PPEModelItem.h"

static NSString *const kPrint = @"print";
static NSString *const kItems = @"items";

@implementation PPEModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.items = @[];
  }
  return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    NSData *printInfoData = dict[kPrint];
    id pi;
    if (nil != printInfoData &&
        nil != (pi = [NSKeyedUnarchiver unarchiveObjectWithData:printInfoData]) &&
        [pi isKindOfClass:[NSPrintInfo class]]) {
      _printInfo = (NSPrintInfo *)pi;
    }
    NSMutableArray<PPEModelItem *> *items = [NSMutableArray array];
    NSArray<NSDictionary *> *dictItems = dict[kItems];
    for (NSDictionary *itemDict in dictItems) {
      PPEModelItem *item = [[PPEModelItem alloc] initWithDictionary:itemDict];
      if (item) {
        [items addObject:item];
      }
    }
    self.items = items;
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  if (self.printInfo) {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.printInfo];
    if (data) {
      result[kPrint] = data;
    }
    NSMutableArray<NSDictionary *> *items = [NSMutableArray array];
    for (PPEModelItem *item in self.items) {
      NSDictionary *itemDict = item.dictionary;
      if (itemDict) {
        [items addObject:itemDict];
      }
    }
    result[kItems] = items;
  }
  return result;
}


@end
