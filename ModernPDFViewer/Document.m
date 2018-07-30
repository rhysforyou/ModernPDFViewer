//
//  Document.m
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import "Document.h"
#import "PDFWindowController.h"

@interface Document ()

@property (strong, nonatomic) PDFDocument * _Nullable pdfDocument;
@property (strong, nonatomic) PDFOutline * _Nullable outline;

@property (weak) PDFWindowController *pdfWindowController;

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    self.pdfWindowController = (PDFWindowController *)[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"];

    self.pdfWindowController.documentViewController.representedObject = self.pdfDocument;
    self.pdfWindowController.outlineViewController.representedObject = self.outline;
    self.pdfWindowController.searchViewController.representedObject = self.pdfDocument;

    [self.pdfWindowController adjustSizeToFitContent];
    [self addWindowController: self.pdfWindowController];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [self.pdfDocument dataRepresentation];
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    self.pdfDocument = [[PDFDocument alloc] initWithData:data];

    if (self.pdfDocument == NULL) {
        return NO;
    }

    self.pdfDocument.delegate = self;
    self.outline = self.pdfDocument.outlineRoot;

    return YES;
}

@end
