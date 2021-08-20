//  PPEPrintTableView.h
// by David Phillip Oster 2021
// License: APACHE Version 2
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// An NSTableView fo fixed height rows that doesn't break a row across pages when printing.
/// data source should set these before printing starts: rowsPerPage, itemsPerPage, itemCount
@interface PPEPrintTableView : NSTableView
@property NSUInteger rowsPerPage;
@property NSUInteger itemsPerPage;
@property NSUInteger itemCount;
@end

NS_ASSUME_NONNULL_END
