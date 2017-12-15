//
//  CombatTrackerViewController.h
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "GameCharacter.h"

@interface CombatTrackerViewController : UIViewController <UITableViewDelegate>
{
    IBOutlet UITableView * poolTableView;
    NSMutableArray *characterList;
    int indexEdited;
    int promptType;
    int currentInitiativeIndexRow;
}
@property (nonatomic, retain) UITableView * poolTableView;
@property (nonatomic, retain) NSMutableArray * characterList;
-(void)saveCharacter:(GameCharacter *)gChar;
@end
