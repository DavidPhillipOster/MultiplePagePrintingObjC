//  PPEModelItem.h
// by David Phillip Oster 2021
// License: APACHE Version 2

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPEModelItem : NSObject
@property(nullable) NSString *name;
@property(nullable) NSString *address;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
