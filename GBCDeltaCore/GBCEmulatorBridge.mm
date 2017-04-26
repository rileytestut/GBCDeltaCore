//
//  GBCEmulatorBridge.m
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "GBCEmulatorBridge.h"

// Inputs
#include "GBCInputGetter.h"

// Gambatte
#include "gambatte.h"

@interface GBCEmulatorBridge ()

@property (nonatomic, copy, nullable, readwrite) NSURL *gameURL;
@property (nonatomic, copy, nonnull, readonly) NSURL *gameSaveDirectory;

@property (nonatomic, assign, readonly) std::shared_ptr<gambatte::GB> gambatte;
@property (nonatomic, assign, readonly) std::shared_ptr<GBCInputGetter> inputGetter;

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
        _gameSaveDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        
        std::shared_ptr<GBCInputGetter> inputGetter(new GBCInputGetter());
        _inputGetter = inputGetter;
        
        std::shared_ptr<gambatte::GB> gambatte(new gambatte::GB());
        gambatte->setInputGetter(inputGetter.get());
        gambatte->setSaveDir(_gameSaveDirectory.fileSystemRepresentation);
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
    size_t samplesCount = 35112;
    
    // Each audio frame = 2 16-bit channel frames (32-bits total per audio frame).
    // Additionally, Gambatte may return up to 2064 audio samples more than requested, so we need to add 2064 to the requested audioBuffer size.
    gambatte::uint_least32_t audioBuffer[samplesCount + 2064];
    size_t samples = samplesCount;
    
    while (self.gambatte->runFor((gambatte::uint_least32_t *)self.videoRenderer.videoBuffer, 160, audioBuffer, samples) == -1)
    {
        [self.audioRenderer.audioBuffer writeBuffer:(uint8_t *)audioBuffer size:samples * 4];
        
        samples = samplesCount;
    }
    
    [self.audioRenderer.audioBuffer writeBuffer:(uint8_t *)audioBuffer size:samples * 4];
}

#pragma mark - Inputs -

- (void)activateInput:(NSInteger)input
{
    self.inputGetter->activateInput((unsigned)input);
}

- (void)deactivateInput:(NSInteger)input
{
    self.inputGetter->deactivateInput((unsigned)input);
}

- (void)resetInputs
{
    self.inputGetter->resetInputs();
}

#pragma mark - Save States -

- (void)saveSaveStateToURL:(NSURL *)URL
{
    self.gambatte->saveState(NULL, 0, URL.fileSystemRepresentation);
}

- (void)loadSaveStateFromURL:(NSURL *)URL
{
    self.gambatte->loadState(URL.fileSystemRepresentation);
}

#pragma mark - Game Saves -

- (void)saveGameSaveToURL:(NSURL *)URL
{
    // Cannot directly set the URL for saving game saves, so we save it to the temporary directory and then move it to the correct place.
    
    self.gambatte->saveSavedata();
    
    NSString *gameFilename = self.gameURL.lastPathComponent.stringByDeletingPathExtension;
    NSURL *temporarySaveURL = [self.gameSaveDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sav", gameFilename]];
    
    if ([self safelyCopyFileAtURL:temporarySaveURL toURL:URL])
    {
        NSURL *rtcURL = [[URL URLByDeletingPathExtension] URLByAppendingPathExtension:@"rtc"];
        NSURL *temporaryRTCURL = [self.gameSaveDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtc", gameFilename]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:temporaryRTCURL.path])
        {
            [self safelyCopyFileAtURL:temporaryRTCURL toURL:rtcURL];
        }
    }
}

- (void)loadGameSaveFromURL:(NSURL *)URL
{
    NSString *gameFilename = self.gameURL.lastPathComponent.stringByDeletingPathExtension;
    NSURL *temporarySaveURL = [self.gameSaveDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sav", gameFilename]];
    
    if ([self safelyCopyFileAtURL:URL toURL:temporarySaveURL])
    {
        NSURL *rtcURL = [[URL URLByDeletingPathExtension] URLByAppendingPathExtension:@"rtc"];
        NSURL *temporaryRTCURL = [self.gameSaveDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtc", gameFilename]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:rtcURL.path])
        {
            [self safelyCopyFileAtURL:rtcURL toURL:temporaryRTCURL];
        }
    }
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

#pragma mark - Private -

- (BOOL)safelyCopyFileAtURL:(NSURL *)URL toURL:(NSURL *)destinationURL
{
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationURL.path])
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:destinationURL.path error:&error])
        {
            NSLog(@"%@", error);
            return NO;
        }
    }
    
    // Copy saves to ensure data is never lost.
    if (![[NSFileManager defaultManager] copyItemAtURL:URL toURL:destinationURL error:&error])
    {
        NSLog(@"%@", error);
        return NO;
    }
    
    return YES;
}

@end
