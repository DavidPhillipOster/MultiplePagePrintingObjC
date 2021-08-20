//  PPEPrintBoss.h
// by David Phillip Oster 2021
// License: APACHE Version 2

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class PPEDataSource;

// Given a datasource and a printInfo, return an appropriate PPEPrintTableView
@interface PPEPrintBoss : NSObject
@property PPEDataSource *dataSource;
@property NSPrintInfo *printInfo;
@property(nonatomic) NSView *printableView;
@end

NS_ASSUME_NONNULL_END
