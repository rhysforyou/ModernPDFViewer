//
//  PDFOutlineViewController.h
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

@import Cocoa;
@import Quartz;

extern NSNotificationName const PDFOutlineViewControllerSelectionDidChangeNotification;

@interface PDFOutlineViewController : NSViewController<NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (readonly) PDFDestination *selectedDestination;

- (void)selectOutlineNodeForPage:(PDFPage *)page;

@end
