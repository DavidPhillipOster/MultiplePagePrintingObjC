//  PPEDocument.m
// by David Phillip Oster 2021
// License: APACHE Version 2

#define DUMMY_MODEL 1

#import "PPEDocument.h"
#import "PPEModel.h"
#import "PPEDataSource.h"
#import "PPEPrintBoss.h"
#if DUMMY_MODEL
#import "PPEModelItem.h"
#endif

@interface PPEDocument ()
@property IBOutlet PPEDataSource *dataSource;
@property IBOutlet NSTableView *tableView;
@property PPEModel *model;
@property PPEPrintBoss *printBoss;
@property BOOL inLiveResize;
@end

@implementation PPEDocument

- (instancetype)init {
    self = [super init];
    if (self) {
      _model = [[PPEModel alloc] init];
#if DUMMY_MODEL
      NSMutableArray<PPEModelItem *> *items = [NSMutableArray array];
      for (NSUInteger i = 0; i < 1000; ++i) {
        PPEModelItem *item = [[PPEModelItem alloc] init];
        item.name = [NSString stringWithFormat:@"name: %d", (int)i+1];
        item.address = [NSString stringWithFormat:@"address: %d", (int)i+1];
        [items addObject:item];
      }
      _model.items = items;
#endif
    }
    return self;
}

+ (BOOL)autosavesInPlace {
  return YES;
}

- (NSString *)windowNibName {
  return @"PPEDocument";
}

- (void)setPrintInfo:(NSPrintInfo *)printInfo {
  [super setPrintInfo:printInfo];
  self.model.printInfo = printInfo;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)controller {
  [super windowControllerDidLoadNib:controller];
  [self.dataSource setModel:self.model];
  NSNib *nib = [[NSNib alloc] initWithNibNamed:@"PPELabelView" bundle:nil];
  [self.tableView registerNib:nib forIdentifier:@"Label"];
  NSView *cellView = [self.tableView makeViewWithIdentifier:@"Label" owner:self];
  [self.tableView setRowHeight:cellView.bounds.size.height];
  NSTableColumn *column = self.tableView.tableColumns.firstObject;
  column.maxWidth = column.minWidth = column.width = cellView.bounds.size.width;
  [self setupColumns];
}

- (void)setupColumns {
  NSTableCellView *cellView = [self.tableView makeViewWithIdentifier:@"Label" owner:self];
  if (cellView) {
    CGRect tableFrame = self.tableView.superview.frame;
    CGRect frame = cellView.frame;
    NSInteger numColumns = MAX(1, (NSInteger)(tableFrame.size.width/frame.size.width));
    [self setNumberOfColumns:numColumns];
  }
}

- (void)setNumberOfColumns:(NSInteger)n {
  if (n < self.tableView.tableColumns.count) {
    while (n < self.tableView.tableColumns.count) {
      [self.tableView removeTableColumn:self.tableView.tableColumns.lastObject];
    }
    [self.tableView reloadData];
  } else if (self.tableView.tableColumns.count < n) {
    NSTableCellView *cellView = [self.tableView makeViewWithIdentifier:@"Label" owner:self];
    while (self.tableView.tableColumns.count < n) {
      NSString *s = [NSString stringWithFormat:@"%d", (int)self.tableView.tableColumns.count];
      NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:s];
      if (cellView) {
        column.width = column.maxWidth = column.minWidth = cellView.bounds.size.width;
      }
      [self.tableView addTableColumn:column];
    }
    [self.tableView reloadData];
  }
}


- (void)windowDidResize:(NSNotification *)notification {
  if ( ! self.inLiveResize) {
    [self setupColumns];
  }
}

- (void)windowWillStartLiveResize:(NSNotification *)notification {
  self.inLiveResize = YES;
}

- (void)windowDidEndLiveResize:(NSNotification *)notification {
  self.inLiveResize = NO;
  [self windowDidResize:notification];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
  NSDictionary *dict = [self.model dictionary];
  if (dict) {
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:outError];
    return data;
  }
  return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
  NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:outError];
  if (dict) {
    PPEModel *model = [[PPEModel alloc] initWithDictionary:dict];
    if (model) {
      self.model = model;
      if (self.model.printInfo) {
        self.printInfo = self.model.printInfo;
      }
    }
  }
  return YES;
}

- (void)document:(NSDocument *)document didPrint:(BOOL)didPrintSuccessfully contextInfo:(void *)contextInfo {
  self.printBoss = nil;
}

- (IBAction)printDocument:(nullable id)sender {
  [self printDocumentWithSettings:[NSDictionary dictionary] showPrintPanel:YES delegate:self didPrintSelector:@selector(document:didPrint:contextInfo:) contextInfo:NULL];
}

- (nullable NSPrintOperation *)printOperationWithSettings:(NSDictionary<NSPrintInfoAttributeKey, id> *)printSettings error:(NSError **)outError {
  self.printInfo.horizontallyCentered = NO;
  self.printInfo.verticallyCentered = NO;
  self.printBoss = [[PPEPrintBoss alloc] init];
  self.printBoss.dataSource = self.dataSource;
  self.printBoss.printInfo = self.printInfo;
  self.model.printInfo = self.printInfo;
  return [NSPrintOperation printOperationWithView:self.printBoss.printableView printInfo:self.printInfo];
}

@end
