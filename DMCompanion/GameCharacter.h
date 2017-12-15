//
//  GameCharacter.h
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCharacter : NSObject
{
    int characterId;
    NSString * name;
    NSString * player;
    NSString * maxHitPoints;
    NSString * currentHitPoints;
    NSString * armor;
    NSString * movement;
    int initiativeBonus;
    int initiativeRoll;
    NSString * description;
    NSMutableArray *spellSlots;
    NSMutableArray *availableSpellSlots;
    NSString * isSpellCaster;
}

@property (nonatomic, copy) NSString *description, *movement, *armor, *currentHitPoints, *maxHitPoints, *player, *name, *isSpellCaster;
@property (nonatomic, copy) NSMutableArray *spellSlots, *availableSpellSlots;

-(void)setCharId:(int)tid;
-(int)getCharId;
-(void)setInitiativeBonus:(int)initBonus;
-(int)getInitiativeBonus;
-(void)setInitiativeRoll:(int)init;
-(int)getInitiativeRoll;

@end
