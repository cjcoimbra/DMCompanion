//
//  CharacterPoolViewController.m
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import "CharacterPoolViewController.h"
#import "CombatTrackerViewController.h"
#import "GameCharacter.h"

@interface CharacterPoolViewController ()

@end

@implementation CharacterPoolViewController

@synthesize poolTableView, characterList, origin, parentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Character Pool"];
    if ([origin isEqualToString:@"COMBAT"])
        NSLog(@"Character Pool was loaded from Combat Tracker");
    else
    {
        UIBarButtonItem *addChar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCharacter:)];
        NSArray *actionButtonItems = @[addChar];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    }
    isCreatingNewFromPool = NO;
    [self loadDatabase];
    
}

-(IBAction)addCharacter:(id)sender
{
    //NSLog(@"addCharacter");
    isCreatingNewFromPool = YES;
    [self performSegueWithIdentifier:@"NavigateFromPoolToCreate" sender:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (isCreatingNewFromPool)
    {
        isCreatingNewFromPool = NO;
        [self loadDatabase];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([origin isEqualToString:@"COMBAT"])
    {
        [parentView saveCharacter:[characterList objectAtIndex:selectedChar]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)addTestCharacter
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_charactersDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CharacterPool (NAME, PLAYER, MAXHP, ARMOR, SPEED, INITIATIVE_BONUS, DESCRIPTION) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\")",
                               @"ORC GUERREIRO", @"DM", @"25", @"14", @"6", 0, @"informações extra..."];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_charactersDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        }
        else
        {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(_charactersDB);
    }
}

-(void)loadDatabase
{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"characters"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_charactersDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CharacterPool (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PLAYER TEXT, MAXHP TEXT, ARMOR TEXT, SPEED TEXT, INITIATIVE_BONUS INTEGER, DESCRIPTION TEXT, SPELL_SLOTS TEXT)";
            
            if (sqlite3_exec(_charactersDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //show uialertview to inform error
            }
            sqlite3_close(_charactersDB);
        }
        else
        {
            //show uialertview to inform error
        }
    }
    
    //[self addTestCharacter];
    
    characterList = [[NSMutableArray alloc] init];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_charactersDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM CharacterPool"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_charactersDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                GameCharacter * fetchedCharacter = [[GameCharacter alloc]init];
                
                //Id
                [fetchedCharacter setCharId:sqlite3_column_int(statement, 0)];
                //Name
                fetchedCharacter.name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                //Player
                fetchedCharacter.player = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                //MAX HP
                fetchedCharacter.maxHitPoints = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                //Armor
                fetchedCharacter.armor = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                //Speed
                fetchedCharacter.movement = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                //Initiative Bonus
                [fetchedCharacter setInitiativeBonus:sqlite3_column_int(statement, 6)];
                //Description
                fetchedCharacter.description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                //Spell Slots
                NSString *fullStringSpellSlots = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                NSArray * spells = [[NSArray alloc]init];
                
                if ([fullStringSpellSlots isEqualToString:@""])
                    [fetchedCharacter setIsSpellCaster:@"NO"];
                else
                {
                    [fetchedCharacter setIsSpellCaster:@"YES"];
                    spells = [fullStringSpellSlots componentsSeparatedByString:@"/"];
                    for (int i = 0; i < spells.count; i++)
                    {
                        [[fetchedCharacter spellSlots] addObject: [spells objectAtIndex:i]];
                    }
                    fetchedCharacter.availableSpellSlots = fetchedCharacter.spellSlots;
                }
                [characterList addObject:fetchedCharacter];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_charactersDB);
    }
    [poolTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellId = @"TaskCell";
    
    UITableViewCell * cell = [poolTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    else
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    cell.tag = 9999;
    
    UIFont *titlefont = [UIFont boldSystemFontOfSize:20];
    UIFont *labelfont = [UIFont boldSystemFontOfSize:16];
    UIFont *extrafont = [UIFont systemFontOfSize:15];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = titlefont;
    name.text = [[characterList objectAtIndex:indexPath.row] name];
    [name sizeToFit];
    [cell addSubview:name];
    
    UILabel *player = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.size.width + 10, 3, 200, 20)];
    player.textAlignment = NSTextAlignmentLeft;
    player.font = labelfont;
    player.text = [[characterList objectAtIndex:indexPath.row] player];
    player.textColor = [UIColor redColor];
    [cell addSubview:player];
    
    UILabel *armorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 20)];
    armorLabel.textAlignment = NSTextAlignmentLeft;
    armorLabel.font = labelfont;
    armorLabel.text = @"AC:";
    [armorLabel sizeToFit];
    [cell addSubview:armorLabel];
    
    UILabel *armor = [[UILabel alloc]initWithFrame:CGRectMake(armorLabel.frame.size.width + 5, 30, 200, 20)];
    armor.textAlignment = NSTextAlignmentLeft;
    armor.font = labelfont;
    armor.text = [[characterList objectAtIndex:indexPath.row] armor];
    [armor sizeToFit];
    armor.textColor = [UIColor redColor];
    [cell addSubview:armor];
    
    UILabel *speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(armor.frame.origin.x + armor.frame.size.width + 10, 30, 200, 20)];
    speedLabel.textAlignment = NSTextAlignmentLeft;
    speedLabel.font = labelfont;
    speedLabel.text = @"SPEED:";
    [speedLabel sizeToFit];
    [cell addSubview:speedLabel];
    
    UILabel *speed = [[UILabel alloc]initWithFrame:CGRectMake(speedLabel.frame.origin.x + speedLabel.frame.size.width + 5, 30, 200, 20)];
    speed.textAlignment = NSTextAlignmentLeft;
    speed.font = labelfont;
    speed.text = [[characterList objectAtIndex:indexPath.row] movement];
    [speed sizeToFit];
    speed.textColor = [UIColor redColor];
    [cell addSubview:speed];

    
    UILabel *initiativeLabel = [[UILabel alloc]initWithFrame:CGRectMake(speed.frame.origin.x + speed.frame.size.width + 10, 30, 200, 20)];
    initiativeLabel.textAlignment = NSTextAlignmentLeft;
    initiativeLabel.font = labelfont;
    initiativeLabel.text = @"INITIATIVE:";
    [initiativeLabel sizeToFit];
    [cell addSubview:initiativeLabel];
    
    UILabel *initiative = [[UILabel alloc]initWithFrame:CGRectMake(initiativeLabel.frame.origin.x + initiativeLabel.frame.size.width + 5, 30, 200, 20)];
    initiative.textAlignment = NSTextAlignmentLeft;
    initiative.font = labelfont;
    initiative.text = [NSString stringWithFormat: @"%d",[[characterList objectAtIndex:indexPath.row] getInitiativeBonus]];
    [initiative sizeToFit];
    initiative.textColor = [UIColor redColor];
    [cell addSubview:initiative];
    
    UILabel *maxHPLabel = [[UILabel alloc]initWithFrame:CGRectMake(initiative.frame.origin.x + initiative.frame.size.width + 10, 30, 200, 20)];
    maxHPLabel.textAlignment = NSTextAlignmentLeft;
    maxHPLabel.font = labelfont;
    maxHPLabel.text = @"TOTAL HP:";
    [maxHPLabel sizeToFit];
    [cell addSubview:maxHPLabel];
    
    UILabel *maxHP = [[UILabel alloc]initWithFrame:CGRectMake(maxHPLabel.frame.origin.x + maxHPLabel.frame.size.width + 5, 30, 200, 20)];
    maxHP.textAlignment = NSTextAlignmentLeft;
    maxHP.font = labelfont;
    maxHP.text = [[characterList objectAtIndex:indexPath.row] maxHitPoints];
    [maxHP sizeToFit];
    maxHP.textColor = [UIColor redColor];
    [cell addSubview:maxHP];
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 1024, 30)];
    desc.textAlignment = NSTextAlignmentLeft;
    desc.font = extrafont;
    desc.numberOfLines = 3;
    desc.text = [@"DESCRIPTION: " stringByAppendingString:[[characterList objectAtIndex:indexPath.row] description]];
    [desc sizeToFit];
    [cell addSubview:desc];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([origin isEqualToString:@"COMBAT"])
    {
        selectedChar = indexPath.row;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [characterList count];
}

@end
