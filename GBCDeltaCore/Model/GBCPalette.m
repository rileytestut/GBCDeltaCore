//
//  GBCPalette.m
//  GBCDeltaCore
//
//  Created by Caroline Moore on 8/20/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

#import "GBCPalette.h"

@implementation GBCPalette

- (instancetype)initWithColor0:(NSInteger)color0 color1:(NSInteger)color1 color2:(NSInteger)color2 color3:(NSInteger)color3
{
    self = [super init];
    if (self)
    {
        _color0 = color0;
        _color1 = color1;
        _color2 = color2;
        _color3 = color3;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[GBCPalette class]])
    {
        return NO;
    }
    
    GBCPalette *palette = (GBCPalette *)object;
    return (self.color0 == palette.color0 && self.color1 == palette.color1 && self.color2 == palette.color2 && self.color3 == palette.color3);
}

- (NSUInteger)hash
{
    return self.color0 ^ self.color1 ^ self.color2 ^ self.color3;
}

@end
