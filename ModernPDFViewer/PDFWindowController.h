//
//  PDFWindowController.h
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PDFDocumentViewController.h"
#import "PDFOutlineViewController.h"
#import "PDFSearchViewController.h"

@interface PDFWindowController : NSWindowController<NSSearchFieldDelegate>

@property (strong) NSSplitViewController *splitViewController;
@property (strong) PDFDocumentViewController *documentViewController;
@property (strong) PDFOutlineViewController *outlineViewController;
@property (strong) PDFSearchViewController *searchViewController;

- (IBAction)toggleSidebar:(id *)sender;
- (void)adjustSizeToFitContent;

@end
