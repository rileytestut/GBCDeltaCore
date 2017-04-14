//
//  GBCEmulatorBridge.h
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DeltaCore/DeltaCore.h>
#import <DeltaCore/DeltaCore-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBCEmulatorBridge : NSObject <DLTAEmulatorBridging>

@property (class, nonatomic, readonly) GBCEmulatorBridge *sharedBridge;

@end

NS_ASSUME_NONNULL_END
