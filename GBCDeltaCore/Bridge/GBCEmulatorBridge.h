//
//  GBCEmulatorBridge.h
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GBCDeltaCore/GBCPalette.h>

@protocol DLTAEmulatorBridging;

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything" // Silence "Cannot find protocol definition" warning due to forward declaration.
@interface GBCEmulatorBridge : NSObject <DLTAEmulatorBridging>
#pragma clang diagnostic pop

@property (class, nonatomic, readonly) GBCEmulatorBridge *sharedBridge;

@property (nonatomic, strong, nullable) GBCPalette *backgroundPalette;
@property (nonatomic, strong, nullable) GBCPalette *spritePalette;
@property (nonatomic, strong, nullable) GBCPalette *foregroundPalette;

@end

NS_ASSUME_NONNULL_END
