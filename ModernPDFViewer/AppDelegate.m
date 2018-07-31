//
//  AppDelegate.m
//  ModernPDFViewer
//
//  Created by Rhys Powell on 30/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    // Helpfully this is only called when the app doesn't have any previously
    // open documents at launch, so it provides a nice place to show the Open
    // File dialog.
    [NSDocumentController.sharedDocumentController openDocument:nil];

    return false;
}

@end
