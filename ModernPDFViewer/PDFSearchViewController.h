//
//  PDFSearchViewController.h
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

@import Cocoa;
@import Quartz;

extern const NSNotificationName PDFSearchViewControllerDidSelectResult;

@interface PDFSearchViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

- (void)performSearchWithString:(NSString *)searchString;

@property (readonly) PDFSelection * _Nullable selectedResult;

@end
