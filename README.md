# MultiplePagePrintingObjC
Multiple Page Printing, macOS Objective-C

![](images/Example.jpg)

## What this is

Ignore the scrollview for a moment and think of the content view as one giant rectangle. If you knew the page number,
can you generate a sub-rectangle that's just the content of that page? If you knew the content rectangle of a printable page, could you return the count of pages that would be needed to show all of your content view? NSView has an overridable method for each question, and this repository is a runnable example of an app that prints a thousand business cards or mailing labels, multiple labels per page, and never breaking a label across a page. This repository also handles the **Scale:** text box on the Page Setup dialog, shrinking or zooming the labels in the print.

All of the source code is in Objective-C. See [MultiplePagePrintingSwift](https://github.com/DavidPhillipOster/MultiplePagePrintingSwift) for the same example, worked in Swift.

I could have used an NSCollectionView or an NSGridView for my main content view, but I've chosen to use a view-based NSTableView because it was simple and easy to set up.

The meat of this example, the implementation of the two methods needed to multi-page print are in **PPEPrintTableView.m** `- (BOOL)knowsPageRange:(NSRangePointer)range` and `- (NSRect)rectForPage:(NSInteger)page` but they work only after their `@property`s have been set up in the preparation code in **PPEPrintBoss.m** - an object that produces and owns the printable view. **PPEDocument.m** owns the `printBoss`, creating it at the start of the print, and destroying it when the print is done.

The `printBoss` looks at the `NSPrintInfo`, getting the dimensions of the printable contentRect from the paper. It also uses the `printInfo.scalingFactor` to adjust the ratio between the PrintTableView's `frame` and `bounds` - this implements the Page Setup's **Scale:** text box.

Since the interactive `NSTableView` in an `NSScrollView` and the `PrintTableView` are showing the same data, it was convenient to use a single object that wraps the model and implements the `NSTableViewDataSource` protocol: **PPEDataSource.m**

`dataSource` tells the tableView how many labels there are, and when asked for a label, it hands the tableView a filled out view from **PPELabelView.m**.

The Document owns a `dataSource`, and passes it the model in `- (void)windowControllerDidLoadNib:(NSWindowController *)controller` (in Cocoa a document initializes and reads from the document-file before the U.I exists.)

For file i/o, I've chosen to give the model two methods: `- (NSDictionary *)dictionary` and `- (instancetype)initWithDictionary:(NSDictionary *)dict` so I can ask a **PPEModel** to give me a dictionary representation of itself and given such a representation, construct a new model. I choose the specific dictionary so it can be written to disk with `[NSPropertyListSerialization dataWithPropertyList:…]` and read from it by `[NSPropertyListSerialization propertyListWithData:…]` This gives me a document file format that I can inspect, and repair, in any text editor.

The Document, because it inherits from `NSDocument`, is already listening for window resize notifications, so when the user resizes the window it adjusts the number of columns in the tableView to use the available space.

The Cocoa print system does support a limited auto-pagination function, but all it seems to do is move a single line of text so that the characters aren't sliced through the middle, with the tops at the end of one page and the bottoms at the start of the next. That won't keep our labelViews from getting sliced.

## To Build:

* Open the Xcode project and in the Info panel of the PagePrintExample target change the `com.example` prefix of the bundle Identifier from `com.turbozen.PagePrintExample`  to a domain you control.

* In the **Signing & Capabilities** panel, choose a team to build and sign with.

* **Build** from the **Product** menu

## Summary

 `- (BOOL)knowsPageRange:(NSRangePointer)range`  - return number of printed pages in your content view
 
  `- (NSRect)rectForPage:(NSInteger)page`  - for a given page by number, from 0 to N, return rectangle of the printable items on that page.


## Previous Work 

as of this writing: 

[MultiplePagePrintingSwift](https://github.com/DavidPhillipOster/MultiplePagePrintingSwift)  is my same example, but worked in Swift.

[Paginating an NSTableView](https://lists.apple.com/archives/cocoa-dev/2002/Nov/msg01710.html) handles cell based tableViews, but doesn't work for view-based ones.

[How to Print on macOS With An NSTableView and Customize the Result](https://christiantietze.de/posts/2021/06/printing-nstableview-with-label/) uses an NSStackView and seems to work, but it's just Cocoa's auto-pagination, it only apparently works because the cells are just a single one-line of text. Extending it to mailing labels makes it fail.


## License

Apache License Version 2

