//
//  PDFSearchViewController.m
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import "PDFSearchViewController.h"

const NSNotificationName PDFSearchViewControllerDidSelectResult = @"PDFSearchViewControllerDidSelectResult";

@interface PDFSearchViewController ()

@property (strong) IBOutlet NSProgressIndicator *searchProgressView;
@property (strong) IBOutlet NSTextField *searchResultsCountLabel;
@property (strong) IBOutlet NSTableView *searchResultsTableView;
@property (strong) PDFDocument *pdfDocument;
@property (strong, nonatomic) NSMutableArray<PDFSelection*> *searchResults;
@property (strong, nonatomic) NSNumberFormatter *searchResultsCountFormatter;

@end

@implementation PDFSearchViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _searchResults = [[NSMutableArray alloc] init];
        _searchResultsCountFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    if (self.pdfDocument != NULL) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PDFDocumentDidBeginFindNotification object:self.pdfDocument];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PDFDocumentDidEndPageFindNotification object:self.pdfDocument];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PDFDocumentDidFindMatchNotification object:self.pdfDocument];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:PDFDocumentDidEndFindNotification object:self.pdfDocument];
    }

    if ([self.representedObject isKindOfClass:[PDFDocument class]]) {
        self.pdfDocument = (PDFDocument *)representedObject;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(findBegan:)
                                                     name:PDFDocumentDidBeginFindNotification
                                                   object:self.pdfDocument];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(findProgressed:)
                                                     name:PDFDocumentDidEndPageFindNotification
                                                   object:self.pdfDocument];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(findMatched:)
                                                     name:PDFDocumentDidFindMatchNotification
                                                   object:self.pdfDocument];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(findEnded:)
                                                     name:PDFDocumentDidEndFindNotification
                                                   object:self.pdfDocument];
    }
}

- (void)performSearchWithString:(NSString *)searchString {
    if (self.pdfDocument.isFinding) {
        [self.pdfDocument cancelFindString];
    }

    [self.pdfDocument beginFindString:searchString withOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
}

- (PDFSelection *)selectedResult {
    NSInteger selectedRow = [self.searchResultsTableView selectedRow];
    if (selectedRow < 0) {
        return NULL;
    }
    return self.searchResults[selectedRow];
}

#pragma mark - PDF Document Search Notifications

- (void)findBegan:(NSNotification *)notification {
    [self.searchResults removeAllObjects];
    [self.searchResultsTableView reloadData];

    self.searchResultsCountLabel.hidden = YES;
    self.searchProgressView.doubleValue = 0;
    self.searchProgressView.hidden = NO;
    [self.searchProgressView startAnimation:self];
}

- (void)findProgressed:(NSNotification *)notification {
    double pageIndex = [notification.userInfo[@"PDFDocumentPageIndex"] doubleValue];
    self.searchProgressView.doubleValue = pageIndex / self.pdfDocument.pageCount;
}

- (void)findMatched:(NSNotification *)notification {
    PDFSelection *foundSelection = (PDFSelection *)notification.userInfo[@"PDFDocumentFoundSelection"];
    [self.searchResults addObject:foundSelection];
    [self.searchResultsTableView reloadData];
}

- (void)findEnded:(NSNotification *)notification {
    [self.searchProgressView stopAnimation:self];
    self.searchProgressView.hidden = YES;
    self.searchResultsCountLabel.stringValue = [NSString stringWithFormat:@"%@ Results", [self.searchResultsCountFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:self.searchResults.count]]];
    self.searchResultsCountLabel.hidden = NO;

}

#pragma mark - Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.searchResults count];
}

#pragma mark - Table View Delegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableColumn.identifier isEqualToString:@"PageColumn"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"PageCell" owner:self];
        cellView.textField.stringValue = self.searchResults[row].pages[0].label;
        return cellView;
    } else if ([tableColumn.identifier isEqualToString:@"SectionColumn"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SectionCell" owner:self];
        cellView.textField.stringValue = [self.pdfDocument outlineItemForSelection:self.searchResults[row]].label;
        return cellView;
    } else {
        return nil;
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:PDFSearchViewControllerDidSelectResult object:self];
}

@end
