//
//  GBCCheat.m
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/26/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "GBCCheat.h"

@import DeltaCore;

@implementation GBCCheat

- (instancetype)initWithCode:(NSString *)code type:(CheatType)type
{
    if (([type isEqualToString:CheatTypeGameGenie] && code.length != 11) || ([type isEqualToString:CheatTypeGameShark] && code.length != 8))
    {
        return nil;
    }
    
    NSMutableCharacterSet *legalCharactersSet = [NSMutableCharacterSet hexadecimalCharacterSet];
    if ([type isEqualToString:CheatTypeGameGenie])
    {
        [legalCharactersSet addCharactersInString:@"-"];
    }
    
    if ([code rangeOfCharacterFromSet:[legalCharactersSet invertedSet]].location != NSNotFound)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _code = [code copy];
        _type = [type copy];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[GBCCheat class]])
    {
        return NO;
    }
    
    GBCCheat *cheat = (GBCCheat *)object;
    return [self.code isEqualToString:cheat.code] && [self.type isEqualToString:cheat.type];
}

- (NSUInteger)hash
{
    return [self.code hash] ^ [self.type hash];
}

@end
