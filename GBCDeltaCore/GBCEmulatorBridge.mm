//
//  GBCEmulatorBridge.m
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "GBCEmulatorBridge.h"

@implementation GBCEmulatorBridge
@synthesize audioRenderer = _audioRenderer;
@synthesize videoRenderer = _videoRenderer;
@synthesize saveUpdateHandler = _saveUpdateHandler;

+ (instancetype)sharedBridge
{
    static GBCEmulatorBridge *_emulatorBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emulatorBridge = [[self alloc] init];
    });
    
    return _emulatorBridge;
}

#pragma mark - Emulation State -

- (void)startWithGameURL:(NSURL *)gameURL
{
}

- (void)stop
{
}

- (void)pause
{
    
}

- (void)resume
{
    
}

#pragma mark - Game Loop -

- (void)runFrame
{
}

#pragma mark - Inputs -

- (void)activateInput:(NSInteger)input
{
    
}

- (void)deactivateInput:(NSInteger)input
{
    
}

- (void)resetInputs
{
    
}

#pragma mark - Save States -

- (void)saveSaveStateToURL:(NSURL *)url
{
    
}

- (void)loadSaveStateFromURL:(NSURL *)url
{
    
}

#pragma mark - Game Saves -

- (void)saveGameSaveToURL:(NSURL *)url
{
    
}

- (void)loadGameSaveFromURL:(NSURL *)url
{
    
}

#pragma mark - Cheats -

- (BOOL)addCheatCode:(NSString *)cheatCode type:(NSString *)type
{
    return YES;
}

- (void)resetCheats
{
    
}

- (void)updateCheats
{
    
}


@end
