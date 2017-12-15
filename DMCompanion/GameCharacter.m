//
//  GameCharacter.m
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize name, player, armor, movement, description, maxHitPoints, currentHitPoints, spellSlots, availableSpellSlots, isSpellCaster;

-(void)setCharId:(int)tid;
{
    characterId = tid;
    spellSlots = [[NSMutableArray alloc]init];
    availableSpellSlots = [[NSMutableArray alloc]init];
}

-(int)getCharId
{
    return characterId;
}

-(void)setInitiativeBonus:(int)initBonus
{
    initiativeBonus = initBonus;
}

-(int)getInitiativeBonus
{
    return initiativeBonus;
}

-(void)setInitiativeRoll:(int)init
{
    initiativeRoll = init;
}

-(int)getInitiativeRoll
{
    return initiativeRoll;
}

@end
