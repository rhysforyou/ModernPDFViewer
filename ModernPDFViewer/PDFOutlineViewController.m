//
//  PDFOutlineViewController.m
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import "PDFOutlineViewController.h"

const NSNotificationName PDFOutlineViewControllerSelectionDidChangeNotification = @"PDFOutlineViewControllerSelectionDidChangeNotification";

@interface PDFOutlineViewController ()

@property (strong) IBOutlet NSOutlineView *outlineView;
@property (readonly) PDFOutline *outline;

@end

@implementation PDFOutlineViewController

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    if ([representedObject isKindOfClass:[PDFOutline class]]) {
        [self.outlineView reloadData];
    }
}

- (PDFOutline *)outline {
    return (PDFOutline *)self.representedObject;
}

- (PDFDestination *)selectedDestination {
    PDFOutline *selectedOutline = (PDFOutline *)[self.outlineView itemAtRow:[self.outlineView selectedRow]];
    return selectedOutline.destination;
}

- (void)selectOutlineNodeForPage:(PDFPage *)page {
    NSUInteger pageIndex = [self.outline.document indexForPage:page];
    NSUInteger numberOfRows = [self.outlineView numberOfRows];
    NSInteger newlySelectedRowIndex = -1;

    for (NSUInteger row = 0; row < numberOfRows ; row++) {
        PDFOutline *outlineItem = (PDFOutline *)[self.outlineView itemAtRow:row];
        NSUInteger destinationIndex = [self.outline.document indexForPage:outlineItem.destination.page];

        if (destinationIndex == pageIndex) {
            newlySelectedRowIndex = row;
            break;
        } else if (destinationIndex > pageIndex) {
            newlySelectedRowIndex = row - 1;
            break;
        }
    }

    if (newlySelectedRowIndex >= 0) {
        NSIndexSet *selectedIndices = [NSIndexSet indexSetWithIndex:newlySelectedRowIndex];
        [self.outlineView selectRowIndexes:selectedIndices byExtendingSelection:NO];
        [self.outlineView scrollRowToVisible:newlySelectedRowIndex];
    }
}

#pragma mark - Outline View Data Source

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == NULL) {
        return [self.outline numberOfChildren];
    } else {
        return [(PDFOutline *)item numberOfChildren];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == NULL) {
        return [self.outline childAtIndex:index];
    } else {
        return [(PDFOutline *)item childAtIndex:index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (item == NULL) {
        return [self.outline numberOfChildren] > 0;
    } else {
        return [(PDFOutline *)item numberOfChildren] > 0;
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *cellView = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"OutlineItemCell" owner:self];
    cellView.textField.stringValue = [(PDFOutline *)item label];
    return cellView;
}

#pragma mark - Outline View Delegate

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:PDFOutlineViewControllerSelectionDidChangeNotification object:self];
}

@end
