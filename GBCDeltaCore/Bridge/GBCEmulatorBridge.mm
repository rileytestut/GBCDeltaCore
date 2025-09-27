//
//  GBCEmulatorBridge.m
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "GBCEmulatorBridge.h"

// Cheats
#import "GBCCheat.h"

// Inputs
#include "GBCInputGetter.h"

// DeltaCore
#import <GBCDeltaCore/GBCDeltaCore.h>
#import <DeltaCore/DeltaCore.h>
#import <DeltaCore/DeltaCore-Swift.h>

// HACKY. Need to access private members to ensure save data loads properly.
// This redefines the private members as public so we can use them.
#define private public

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"

// Gambatte
#include "gambatte.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
#include "cpu.h"
#pragma clang diagnostic pop

#pragma clang diagnostic pop

// Undefine private.
#undef private

NSInteger defaultPaletteColor0 = 0xFFFFFF;
NSInteger defaultPaletteColor1 = 0xAAAAAA;
NSInteger defaultPaletteColor2 = 0x555555;
NSInteger defaultPaletteColor3 = 0x000000;

@interface GBCEmulatorBridge () <DLTAEmulatorBridging>

@property (nonatomic, copy, nullable, readwrite) NSURL *gameURL;
@property (nonatomic, copy, nonnull, readonly) NSURL *gameSaveDirectory;

@property (nonatomic, assign, readonly) std::shared_ptr<gambatte::GB> gambatte;
@property (nonatomic, assign, readonly) std::shared_ptr<GBCInputGetter> inputGetter;

@property (nonatomic, readonly) NSMutableSet<GBCCheat *> *cheats;

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
        
        _cheats = [NSMutableSet set];
    }
    
    return self;
}

#pragma mark - Emulation State -

- (void)startWithGameURL:(NSURL *)gameURL
{
    self.gameURL = gameURL;
    
    if (self.backgroundPalette)
    {
        _gambatte->setDmgPaletteColor(0, 0, self.backgroundPalette.color0);
        _gambatte->setDmgPaletteColor(0, 1, self.backgroundPalette.color1);
        _gambatte->setDmgPaletteColor(0, 2, self.backgroundPalette.color2);
        _gambatte->setDmgPaletteColor(0, 3, self.backgroundPalette.color3);
    }
    else
    {
        _gambatte->setDmgPaletteColor(0, 0, defaultPaletteColor0);
        _gambatte->setDmgPaletteColor(0, 1, defaultPaletteColor1);
        _gambatte->setDmgPaletteColor(0, 2, defaultPaletteColor2);
        _gambatte->setDmgPaletteColor(0, 3, defaultPaletteColor3);
    }
        
    if (self.spritePalette)
    {
        _gambatte->setDmgPaletteColor(1, 0, self.spritePalette.color0);
        _gambatte->setDmgPaletteColor(1, 1, self.spritePalette.color1);
        _gambatte->setDmgPaletteColor(1, 2, self.spritePalette.color2);
        _gambatte->setDmgPaletteColor(1, 3, self.spritePalette.color3);
    }
    else
    {
        _gambatte->setDmgPaletteColor(1, 0, defaultPaletteColor0);
        _gambatte->setDmgPaletteColor(1, 1, defaultPaletteColor1);
        _gambatte->setDmgPaletteColor(1, 2, defaultPaletteColor2);
        _gambatte->setDmgPaletteColor(1, 3, defaultPaletteColor3);
    }
    
    if (self.foregroundPalette)
    {
        _gambatte->setDmgPaletteColor(2, 0, self.foregroundPalette.color0);
        _gambatte->setDmgPaletteColor(2, 1, self.foregroundPalette.color1);
        _gambatte->setDmgPaletteColor(2, 2, self.foregroundPalette.color2);
        _gambatte->setDmgPaletteColor(2, 3, self.foregroundPalette.color3);
    }
    else
    {
        _gambatte->setDmgPaletteColor(2, 0, defaultPaletteColor0);
        _gambatte->setDmgPaletteColor(2, 1, defaultPaletteColor1);
        _gambatte->setDmgPaletteColor(2, 2, defaultPaletteColor2);
        _gambatte->setDmgPaletteColor(2, 3, defaultPaletteColor3);
    }
    
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

- (void)runFrameAndProcessVideo:(BOOL)processVideo
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
    
    if (processVideo)
    {
        [self.videoRenderer processFrame];
    }
}

- (nullable NSData *)readMemoryAtAddress:(NSInteger)address size:(NSInteger)size
{
    // Hacky pointer manipulation to obtain the underlying CPU struct and its Cartridge.
    gambatte::CPU *cpu = (gambatte::CPU *)self.gambatte->p_;
    auto &cart = cpu->mem_.cart_;
    
    void *bytes = NULL;
    if (address < 0xC000)
    {
        // Based on Memory::nontrivial_read()
        
        if (address < 0x8000)
        {
            bytes = cart.romdata((unsigned int)address >> 14) + address;
        }
        else if (address < 0xA000)
        {
            bytes = cart.vrambankptr() + address;
        }
        else if (cart.rsrambankptr())
        {
            bytes = (void *)(cart.rsrambankptr() + address);
        }
        else
        {
            return NULL;
        }
    }
    else if (address >= 0xC000 && address <= 0xDFFF)
    {
        bytes = cart.wramdata(0) + (address - 0xC000);
    }
    else if (address >= 0xFF80 && address <= 0xFFFE)
    {
        bytes = cart.wramdata(1) + (address - 0xFF80);
    }
    else
    {
        // Beyond RAM bounds, return nil.
        return nil;
    }
    
    NSData *data = [NSData dataWithBytesNoCopy:bytes length:size freeWhenDone:NO];
    return data;
}

#pragma mark - Inputs -

- (void)activateInput:(NSInteger)input value:(double)value playerIndex:(NSInteger)playerIndex
{
    self.inputGetter->activateInput((unsigned)input);
}

- (void)deactivateInput:(NSInteger)input playerIndex:(NSInteger)playerIndex
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
    
    // Hacky pointer manipulation to obtain the underlying CPU struct, then explicitly call loadSavedata().
    gambatte::CPU *cpu = (gambatte::CPU *)self.gambatte->p_;
    (*cpu).loadSavedata();
}

#pragma mark - Cheats -

- (BOOL)addCheatCode:(NSString *)cheatCode type:(CheatType)type
{
    NSArray<NSString *> *codes = [cheatCode componentsSeparatedByString:@"\n"];
    for (NSString *code in codes)
    {
        GBCCheat *cheat = [[GBCCheat alloc] initWithCode:code type:type];
        if (cheat == nil)
        {
            return NO;
        }
        
        [self.cheats addObject:cheat];
    }
    
    return YES;
}

- (void)resetCheats
{
    [self.cheats removeAllObjects];
    
    self.gambatte->setGameGenie("");
    self.gambatte->setGameShark("");
}

- (void)updateCheats
{
    NSMutableString *gameGenieCodes = [NSMutableString string];
    NSMutableString *gameSharkCodes = [NSMutableString string];
    
    for (GBCCheat *cheat in self.cheats.copy)
    {
        NSMutableString *codes = nil;
        
        if ([cheat.type isEqualToString:CheatTypeGameGenie])
        {
            codes = gameGenieCodes;
        }
        else if ([cheat.type isEqualToString:CheatTypeGameShark])
        {
            codes = gameSharkCodes;
        }
        
        [codes appendString:cheat.code];
        [codes appendString:@";"];
    }
    
    self.gambatte->setGameGenie([gameGenieCodes UTF8String]);
    self.gambatte->setGameShark([gameSharkCodes UTF8String]);
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

#pragma mark - Getters/Setters -

- (NSTimeInterval)frameDuration
{
    return (1.0 / 60.0);
}

@end
