//
//  ViewController.m
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import "PDFDocumentViewController.h"

const NSNotificationName PDFDocumentViewControllerPageChangedNotification = @"PDFDocumentViewControllerPageChangedNotification";

@interface PDFDocumentViewController ()

@property (strong) IBOutlet PDFView *pdfView;
@property (strong, nonatomic) PDFDocument *document;

@end

@implementation PDFDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChanged:) name:PDFViewPageChangedNotification object:self.pdfView];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    self.document = representedObject;

    if (self.isViewLoaded) {
        [self.pdfView setDocument:representedObject];
    }
}

- (void)goToDestination:(PDFDestination *)destination {
    [self.pdfView goToDestination:destination];
}

- (void)goToSelection:(PDFSelection *)selection {
    [self.pdfView goToSelection:selection];
}

- (PDFPage *)currentPage {
    return self.pdfView.currentPage;
}

- (CGSize)currentPageSize {
    if (self.pdfView.currentPage == NULL) {
        return [self.pdfView rowSizeForPage:[self.pdfView.document pageAtIndex:0]];
    } else {
        return [self.pdfView rowSizeForPage:self.pdfView.currentPage];
    }
}

- (void)pageChanged:(PDFView *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:PDFDocumentViewControllerPageChangedNotification object:self];
}

@end
