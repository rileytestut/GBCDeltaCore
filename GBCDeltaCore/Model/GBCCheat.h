//
//  GBCCheat.h
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/26/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBCTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface GBCCheat : NSObject

@property (copy, nonatomic, readonly) NSString *code;
@property (copy, nonatomic, readonly) CheatType type;

- (nullable instancetype)initWithCode:(NSString *)code type:(CheatType)type;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
