//  PPEDataSource.h
// by David Phillip Oster 2021
// License: APACHE Version 2

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class PPEModel;

/// A view model for a tableView.
@interface PPEDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>
@property PPEModel *model;
@end

NS_ASSUME_NONNULL_END
