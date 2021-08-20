//  PPEModel.h
// by David Phillip Oster 2021
// License: APACHE Version 2

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class PPEModelItem;

@interface PPEModel : NSObject
@property (nonatomic, nullable) NSPrintInfo *printInfo;
@property (nonatomic) NSArray<PPEModelItem *> *items;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
