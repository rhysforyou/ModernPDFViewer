//
//  ViewController.h
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

@import Cocoa;
@import Quartz;

extern const NSNotificationName PDFDocumentViewControllerPageChangedNotification;

@interface PDFDocumentViewController : NSViewController<PDFViewDelegate>

- (void)goToDestination:(PDFDestination * _Nonnull)destination;
- (void)goToSelection:(PDFSelection * _Nonnull)selection;

@property (readonly) PDFPage *currentPage;
@property (readonly) CGSize currentPageSize;

@end

