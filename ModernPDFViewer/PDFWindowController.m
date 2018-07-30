//
//  PDFWindowController.m
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import "PDFWindowController.h"

const NSStoryboardSceneIdentifier OutlineSidebarIdentifier = @"Outline Sidebar";
const NSStoryboardSceneIdentifier SearchSidebarIdentifier = @"Search Sidebar";

const CGFloat SearchSidebarWidth = 240.0f;

@interface PDFWindowController ()

@property (strong) IBOutlet NSSearchField *searchField;

// Short circuit notification loops. There's probably a bette way to do this.
@property BOOL ignoreNextSelection;
@property BOOL ignoreNextPageChange;

@end

@implementation PDFWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.splitViewController = (NSSplitViewController *)self.contentViewController;
    self.outlineViewController = (PDFOutlineViewController *)self.splitViewController.splitViewItems[0].viewController;
    self.documentViewController = (PDFDocumentViewController *)self.splitViewController.splitViewItems[1].viewController;
    self.searchViewController = (PDFSearchViewController *)self.splitViewController.splitViewItems[2].viewController;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pdfOutlineSelectionDidChange:)
                                                 name:PDFOutlineViewControllerSelectionDidChangeNotification
                                               object:self.outlineViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pdfDocumentPageChanged:)
                                                 name:PDFDocumentViewControllerPageChangedNotification
                                               object:self.documentViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectedSearchResult:)
                                                 name:PDFSearchViewControllerDidSelectResult
                                               object:self.searchViewController];
}

- (void)adjustSizeToFitContent {
    CGSize contentSize = self.documentViewController.currentPageSize;

    if (!self.splitViewController.splitViewItems[0].isCollapsed) {
        contentSize.width += self.outlineViewController.view.bounds.size.width;
    }

    [self.window setContentSize:contentSize];
}

#pragma mark - Notifications

- (void)pdfOutlineSelectionDidChange:(NSNotification *)notification {
    if (self.ignoreNextSelection) {
        self.ignoreNextSelection = false;
        return;
    }
    self.ignoreNextPageChange = true;
    PDFOutlineViewController *outlineVC = (PDFOutlineViewController *)notification.object;
    [self.documentViewController goToDestination:outlineVC.selectedDestination];
}

- (void)pdfDocumentPageChanged:(NSNotification *)notification {
    if (self.ignoreNextPageChange) {
        self.ignoreNextPageChange = false;
        return;
    }
    self.ignoreNextSelection = true;
    PDFDocumentViewController *documentVC = (PDFDocumentViewController *)notification.object;
    [self.outlineViewController selectOutlineNodeForPage:documentVC.currentPage];
}

- (void)selectedSearchResult:(NSNotification *)notification {
    PDFSearchViewController *searchViewController = (PDFSearchViewController *)notification.object;
    PDFSelection *selectedResult = searchViewController.selectedResult;
    if (selectedResult != NULL) {
        [self.documentViewController goToSelection:selectedResult];
    }
}

#pragma mark - UI Actions

- (IBAction)toggleSidebar:(id *)sender {
    NSSplitViewItem *outlineItem = [self.splitViewController.splitViewItems firstObject];
    if (outlineItem.isCollapsed) {
        [outlineItem setCollapsed:false];
    } else {
        [outlineItem setCollapsed:true];
    }
}

#pragma mark - Search Field Delegate

- (void)searchFieldDidStartSearching:(NSSearchField *)sender {
    NSSplitViewItem *searchResultsItem = self.splitViewController.splitViewItems[2];
    if (searchResultsItem.isCollapsed) {
        [searchResultsItem setCollapsed:false];
        CGSize contentSize = self.window.contentView.frame.size;
        contentSize.width += SearchSidebarWidth;
        [self.window setContentSize:contentSize];

    }
    [self.searchViewController performSearchWithString:sender.stringValue];
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    NSSplitViewItem *searchResultsItem = self.splitViewController.splitViewItems[2];
    if (!searchResultsItem.isCollapsed) {
        [searchResultsItem setCollapsed:true];
        CGSize windowSize = self.window.contentView.frame.size;
        windowSize.width -= SearchSidebarWidth;
        [self.window setContentSize:windowSize];
    }
}

@end
