//
//  CreateCharacterViewController.h
//  DMCompanion
//
//  Created by Christian Coimbra on 21/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CreateCharacterViewController : UIViewController
{
    IBOutlet UITextField * nameText;
    IBOutlet UITextField * playerText;
    IBOutlet UITextField * armorText;
    IBOutlet UITextField * speedText;
    IBOutlet UITextField * initiativeText;
    IBOutlet UITextField * totalHPText;
    IBOutlet UITextField * descriptionText;
    IBOutlet UITextField * spellSlots;
    
    IBOutlet UITextField * level1Slots;
    IBOutlet UITextField * level2Slots;
    IBOutlet UITextField * level3Slots;
    IBOutlet UITextField * level4Slots;
    IBOutlet UITextField * level5Slots;
    IBOutlet UITextField * level6Slots;
    IBOutlet UITextField * level7Slots;
    IBOutlet UITextField * level8Slots;
    IBOutlet UITextField * level9Slots;
    
    IBOutlet UIButton *saveButton;
}

@property (nonatomic, retain) UITextField * nameText;
@property (nonatomic, retain) UITextField * playerText;
@property (nonatomic, retain) UITextField * armorText;
@property (nonatomic, retain) UITextField * speedText;
@property (nonatomic, retain) UITextField * initiativeText;
@property (nonatomic, retain) UITextField * totalHPText;
@property (nonatomic, retain) UITextField * descriptionText;
//@property (nonatomic, retain) UITextField * spellSlots;

@property (nonatomic, retain) UITextField * level1Slots;
@property (nonatomic, retain) UITextField * level2Slots;
@property (nonatomic, retain) UITextField * level3Slots;
@property (nonatomic, retain) UITextField * level4Slots;
@property (nonatomic, retain) UITextField * level5Slots;
@property (nonatomic, retain) UITextField * level6Slots;
@property (nonatomic, retain) UITextField * level7Slots;
@property (nonatomic, retain) UITextField * level8Slots;
@property (nonatomic, retain) UITextField * level9Slots;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *charactersDB;

-(IBAction)saveCharacter:(id)sender;
@end
