//
//  CreateCharacterViewController.m
//  DMCompanion
//
//  Created by Christian Coimbra on 21/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import "CreateCharacterViewController.h"

@interface CreateCharacterViewController ()

@end

@implementation CreateCharacterViewController

@synthesize nameText,playerText,armorText,speedText,initiativeText,descriptionText,totalHPText, level1Slots, level2Slots, level3Slots, level4Slots, level5Slots, level6Slots, level7Slots, level8Slots, level9Slots;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveCharacter:(id)sender
{
    NSString *docsDir;
    NSArray *dirPaths;
    
     NSString * fullSlots = @"";
    
    if ([level1Slots.text isEqualToString:@""] && [level2Slots.text isEqualToString:@""] && [level3Slots.text isEqualToString:@""] && [level4Slots.text isEqualToString:@""] && [level5Slots.text isEqualToString:@""] && [level6Slots.text isEqualToString:@""] && [level7Slots.text isEqualToString:@""] && [level8Slots.text isEqualToString:@""] && [level9Slots.text isEqualToString:@""])
    {
        //not spell caster
    }
    else
    {
        if([level1Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level1Slots.text] stringByAppendingString:@"/"];
        
        if([level2Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level2Slots.text] stringByAppendingString:@"/"];
        
        if([level3Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level3Slots.text] stringByAppendingString:@"/"];
        
        if([level4Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level4Slots.text] stringByAppendingString:@"/"];
        
        if([level5Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level5Slots.text] stringByAppendingString:@"/"];

        if([level6Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level6Slots.text] stringByAppendingString:@"/"];

        if([level7Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level7Slots.text] stringByAppendingString:@"/"];

        if([level8Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0/"];
        else
            fullSlots = [[fullSlots stringByAppendingString:level8Slots.text] stringByAppendingString:@"/"];
        
        if([level9Slots.text isEqualToString:@""])
            fullSlots = [fullSlots stringByAppendingString:@"0"];
        else
            fullSlots = [fullSlots stringByAppendingString:level9Slots.text];

    }
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"characters"]];
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_charactersDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CharacterPool (NAME, PLAYER, MAXHP, ARMOR, SPEED, INITIATIVE_BONUS, DESCRIPTION, SPELL_SLOTS) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\")",
                               nameText.text, playerText.text, totalHPText.text, armorText.text, speedText.text, [initiativeText.text integerValue], descriptionText.text, fullSlots];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_charactersDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"saved");
        }
        else
        {
            NSLog(@"failed to save");            
        }
        sqlite3_finalize(statement);
        sqlite3_close(_charactersDB);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
