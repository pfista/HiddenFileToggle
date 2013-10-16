//
//  AppDelegate.m
//  HiddenToggle
//
//  Created by Michael Pfister on 10/14/13.
//  Copyright (c) 2013 Michael Pfister. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

bool hidden;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self launch];
}

@synthesize statusBar = _statusBar;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBar.highlightMode = NO;
    [self.statusBar setAction:@selector(click:)];
}

-(void)click:(id)sender{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    
    if (hidden) {
        [task setArguments:@[ @"-c", @"/usr/bin/defaults write com.apple.finder AppleShowAllFiles NO" ]];
        hidden = NO;
        self.statusBar.image = [NSImage imageNamed:@"hidden"];
    }
    else {
        [task setArguments:@[ @"-c", @"/usr/bin/defaults write com.apple.finder AppleShowAllFiles YES" ]];
        hidden = YES;
        self.statusBar.image = [NSImage imageNamed:@"shown"];
    }
    [task launch];
    [task waitUntilExit];
    
    NSTask *restartFinder = [[NSTask alloc] init];
    [restartFinder setLaunchPath:@"/bin/bash"];
    [restartFinder setArguments:@[ @"-c", @"/usr/bin/killall -HUP Finder"]];
    [restartFinder launch];
    [restartFinder waitUntilExit];

}

- (void)launch {
    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:@[ @"-c", @"/usr/bin/defaults read com.apple.finder AppleShowAllFiles"]];
    
    NSPipe * out = [NSPipe pipe];
    [task setStandardOutput:out];
    
    [task launch];
    [task waitUntilExit];
    
    NSFileHandle * read = [out fileHandleForReading];
    NSData * dataRead = [read readDataToEndOfFile];
    NSString * stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];
    NSLog(@"output: %@", stringRead);
    
    if ([stringRead isEqualToString:@"NO"]){
        hidden = YES;
        self.statusBar.image = [NSImage imageNamed:@"shown"];
    }
    else {
        hidden = NO;
        self.statusBar.image = [NSImage imageNamed:@"hidden"];
    }
    
}

@end
