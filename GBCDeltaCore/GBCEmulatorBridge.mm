//
//  GBCEmulatorBridge.m
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "GBCEmulatorBridge.h"

// Gambatte
#include "gambatte.h"

@interface GBCEmulatorBridge ()

@property (nonatomic, copy, nullable, readwrite) NSURL *gameURL;

@property (nonatomic, assign, readonly) std::shared_ptr<gambatte::GB> gambatte;

@end

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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        std::shared_ptr<gambatte::GB> gambatte(new gambatte::GB());
        _gambatte = gambatte;
    }
    
    return self;
}

#pragma mark - Emulation State -

- (void)startWithGameURL:(NSURL *)gameURL
{
    self.gameURL = gameURL;
    
    gambatte::LoadRes result = self.gambatte->load(gameURL.fileSystemRepresentation, gambatte::GB::MULTICART_COMPAT);
    NSLog(@"Started Gambatte with result: %@", @(result));
}

- (void)stop
{
    self.gambatte->reset();
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
    size_t samplesCount = 2064;
    
    gambatte::uint_least32_t audioBuffer[samplesCount * 2];
    size_t samples = samplesCount;
    
    while (self.gambatte->runFor((gambatte::uint_least32_t *)self.videoRenderer.videoBuffer, 160, audioBuffer, samples) == -1)
    {
        samples = samplesCount;
    }
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
