//
//  CharacterPoolViewController.h
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CombatTrackerViewController.h"
#import <sqlite3.h>

@interface CharacterPoolViewController : UIViewController <UITableViewDelegate>
{
    IBOutlet UITableView * poolTableView;
    NSMutableArray *characterList;
    int selectedChar;
    BOOL isCreatingNewFromPool;
}

@property (nonatomic, retain) CombatTrackerViewController * parentView;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) UITableView * poolTableView;
@property (nonatomic, retain) NSMutableArray * characterList;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *charactersDB;
@end
