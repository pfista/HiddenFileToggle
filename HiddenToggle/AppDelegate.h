//
//  AppDelegate.h
//  HiddenToggle
//
//  Created by Michael Pfister on 10/14/13.
//  Copyright (c) 2013 Michael Pfister. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenuItem *quit;

@property (strong, nonatomic) NSStatusItem *statusBar;

- (void)launch;

@end
