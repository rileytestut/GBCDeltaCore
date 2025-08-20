//
//  GBCPalette.h
//  GBCDeltaCore
//
//  Created by Caroline Moore on 8/20/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBCPalette : NSObject

@property (nonatomic) NSInteger color0;
@property (nonatomic) NSInteger color1;
@property (nonatomic) NSInteger color2;
@property (nonatomic) NSInteger color3;

- (instancetype)initWithColor0:(NSInteger)color0 color1:(NSInteger)color1 color2:(NSInteger)color2 color3:(NSInteger)color3;

@end

NS_ASSUME_NONNULL_END
