//
//  CombatTrackerViewController.m
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import "CombatTrackerViewController.h"
#import "CharacterPoolViewController.h"
#import "GameCharacter.h"

@interface CombatTrackerViewController ()

@end

@implementation CombatTrackerViewController

@synthesize poolTableView, characterList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Combat Tracker"];
    
    UIBarButtonItem *addChar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCharacter:)];
    
    //UIBarButtonItem *advanceTurn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(advanceTurn:)];
    UIBarButtonItem *advanceTurn = [[UIBarButtonItem alloc] initWithTitle:@"Next Turn" style:UIBarButtonItemStyleDone target:self action:@selector(advanceTurn:)];

    currentInitiativeIndexRow = 0;
    
    NSArray *actionButtonItems = @[addChar, advanceTurn];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    characterList = [[NSMutableArray alloc]init];
    //[self loadDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NavigateFromCombatToPool"])
    {
        CharacterPoolViewController *destination = (CharacterPoolViewController*) segue.destinationViewController;
        destination.origin = @"COMBAT";
        destination.parentView = self;
    }
}

-(IBAction)addCharacter:(id)sender
{
    //NSLog(@"addCharacter");
    [self performSegueWithIdentifier:@"NavigateFromCombatToPool" sender:self];
}

-(IBAction)advanceTurn:(id)sender
{
    //NSLog(@"addCharacter");
    currentInitiativeIndexRow++;
    if (currentInitiativeIndexRow >= [characterList count])
        currentInitiativeIndexRow = 0;
    
    [poolTableView reloadData];
}

-(void)saveCharacter:(GameCharacter *)gChar
{
    gChar.currentHitPoints = gChar.maxHitPoints;
    [characterList addObject:gChar];
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
    //UIFont *extrafont = [UIFont systemFontOfSize:15];
    UIColor *generalColor;
    if ([[[characterList objectAtIndex:indexPath.row] player] isEqualToString:@"DM"])
        generalColor = [UIColor redColor];
    else
        generalColor = [UIColor blueColor];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 20)];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = titlefont;
    name.text = [[characterList objectAtIndex:indexPath.row] name];
    [name sizeToFit];
    [cell addSubview:name];
    
    UILabel *player = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.size.width + 10 + 30, 3, 200, 20)];
    player.textAlignment = NSTextAlignmentLeft;
    player.font = labelfont;
    player.text = [[characterList objectAtIndex:indexPath.row] player];
    //player.textColor = [UIColor redColor];
    player.textColor = generalColor;
    [cell addSubview:player];
    
    UILabel *armorLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 200, 20)];
    armorLabel.textAlignment = NSTextAlignmentLeft;
    armorLabel.font = labelfont;
    armorLabel.text = @"AC:";
    [armorLabel sizeToFit];
    [cell addSubview:armorLabel];
    
    UILabel *armor = [[UILabel alloc]initWithFrame:CGRectMake(armorLabel.frame.size.width + 5 + 30, 30, 200, 20)];
    armor.textAlignment = NSTextAlignmentLeft;
    armor.font = labelfont;
    armor.text = [[characterList objectAtIndex:indexPath.row] armor];
    [armor sizeToFit];
    //armor.textColor = [UIColor redColor];
    armor.textColor = generalColor;
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
    //speed.textColor = [UIColor redColor];
    speed.textColor = generalColor;
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
    //initiative.textColor = [UIColor redColor];
    initiative.textColor = generalColor;
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
    maxHP.textColor = generalColor;
    [cell addSubview:maxHP];
    
    UILabel *currentHPLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxHP.frame.origin.x + maxHP.frame.size.width + 5, 30, 200, 20)];
    currentHPLabel.textAlignment = NSTextAlignmentLeft;
    currentHPLabel.font = labelfont;
    currentHPLabel.text = [[@"[" stringByAppendingString:[[characterList objectAtIndex:indexPath.row] currentHitPoints]] stringByAppendingString:@"]"];
    [currentHPLabel sizeToFit];
    //currentHPLabel.textColor = [UIColor redColor];
    currentHPLabel.textColor = generalColor;
    [cell addSubview:currentHPLabel];

    if ([[[characterList objectAtIndex:indexPath.row] isSpellCaster] isEqualToString:@"YES"])
    {
        UILabel *spellsLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentHPLabel.frame.origin.x + currentHPLabel.frame.size.width + 10, 30, 200, 20)];
        spellsLabel.textAlignment = NSTextAlignmentLeft;
        spellsLabel.font = labelfont;
        spellsLabel.text = @"SPELL SLOTS:";
        [spellsLabel sizeToFit];
        [cell addSubview:spellsLabel];
                            
        UILabel *spells = [[UILabel alloc]initWithFrame:CGRectMake(spellsLabel.frame.origin.x + spellsLabel.frame.size.width + 5, 30, 200, 20)];
        spells.textAlignment = NSTextAlignmentLeft;
        spells.font = labelfont;
        NSString * spellsString = @"";
        for (int i = 0; i < [[[characterList objectAtIndex:indexPath.row] spellSlots] count]; i++)
        {
            spellsString = [spellsString stringByAppendingString:[[[characterList objectAtIndex:indexPath.row] availableSpellSlots] objectAtIndex:i]];
            if (i < [[[characterList objectAtIndex:indexPath.row] spellSlots] count] - 1)
                spellsString = [spellsString stringByAppendingString:@"/"];
        }
        spells.text = spellsString;
        [spells sizeToFit];
        spells.textColor = generalColor;
        [cell addSubview:spells];
    }
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 1024, 20)];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.font = labelfont;
    descLabel.numberOfLines = 1;
    descLabel.text = @"DESCRIPTION:";
    [descLabel sizeToFit];
    [cell addSubview:descLabel];
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(descLabel.frame.size.width + 5 + 30, 60, 1024, 20)];
    desc.textAlignment = NSTextAlignmentLeft;
    desc.font = labelfont;
    desc.numberOfLines = 1;
    desc.text = [[characterList objectAtIndex:indexPath.row] description];
    [desc sizeToFit];
    //desc.textColor = [UIColor redColor];
    desc.textColor = generalColor;
    [cell addSubview:desc];
    
    for (int i = 1; i <= [[[characterList objectAtIndex:indexPath.row] maxHitPoints] integerValue]; i++)
    {
        int counter = i;
        int y = 90;
        int line = 0;
        if (i > 50)
        {
            y = 102;
            line = 1;
        }
        if (i > 100)
        {
            y = 114;
            line = 2;
            //NSLog(@"line 2");
        }
       
        UIImageView * hpUnit;
        
        if (line == 0)
            hpUnit = [[UIImageView alloc]initWithFrame:CGRectMake(0 + (i * 12) + (i * 4) + 30, y, 12, 8)];
        else if (line == 1)
        {
            counter = i - 50;
            hpUnit = [[UIImageView alloc]initWithFrame:CGRectMake(0 + (counter * 12) + (counter * 4) + 30, y, 12, 8)];
        }
        else
        {
            counter = i - 100;
            hpUnit = [[UIImageView alloc]initWithFrame:CGRectMake(0 + (counter* 12) + (counter * 4) + 30, y, 12, 8)];
        }
        
        if (i > [[[characterList objectAtIndex:indexPath.row] currentHitPoints] integerValue])
            hpUnit.backgroundColor = [UIColor lightGrayColor];
        else
            hpUnit.backgroundColor = generalColor;
        
        [cell addSubview:hpUnit];
    }
    
    
    if (currentInitiativeIndexRow == indexPath.row)
    {
        UIImageView * leftPanel = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 130)];
        //leftPanel.backgroundColor = [UIColor redColor];
        leftPanel.backgroundColor = generalColor;
        [cell addSubview:leftPanel];
    }
    
    UIImageView * subPanel = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, 1024, 5)];
    //leftPanel.backgroundColor = [UIColor redColor];
    subPanel.backgroundColor = [UIColor blackColor];
    [cell addSubview:subPanel];

    UIButton *damageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [damageButton addTarget:self
               action:@selector(addDamagePrompt:)
     forControlEvents:UIControlEventTouchUpInside];
    damageButton.tag = indexPath.row;
    [damageButton setTitle:@"ADD DAMAGE" forState:UIControlStateNormal];
    damageButton.frame = CGRectMake(900, 3, 120, 30);
    //damageButton.backgroundColor = [UIColor redColor];
    damageButton.titleLabel.font = labelfont;
    damageButton.tintColor = generalColor;
    [cell addSubview:damageButton];
    
    //if ([[[characterList objectAtIndex:indexPath.row] spellSlots] count] > 0)
    if ([[[characterList objectAtIndex:indexPath.row] isSpellCaster] isEqualToString:@"YES"])
    {
        UIButton *spellButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [spellButton addTarget:self
                         action:@selector(castSpellPrompt:)
               forControlEvents:UIControlEventTouchUpInside];
        spellButton.tag = indexPath.row;
        [spellButton setTitle:@"CAST SPELL" forState:UIControlStateNormal];
        spellButton.frame = CGRectMake(770, 3, 120, 30);
        spellButton.titleLabel.font = labelfont;
        spellButton.tintColor = generalColor;
        [cell addSubview:spellButton];
    }
    
    UIButton *cureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cureButton addTarget:self
                     action:@selector(addCurePrompt:)
           forControlEvents:UIControlEventTouchUpInside];
    cureButton.tag = indexPath.row;
    [cureButton setTitle:@"ADD CURE" forState:UIControlStateNormal];
    cureButton.frame = CGRectMake(900, 42, 120, 30);
    //cureButton.backgroundColor = [UIColor redColor];
    cureButton.titleLabel.font = labelfont;
    cureButton.tintColor = generalColor;
    [cell addSubview:cureButton];
    
    UIButton *initiativeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [initiativeButton addTarget:self
                     action:@selector(setInitiativePrompt:)
           forControlEvents:UIControlEventTouchUpInside];
    initiativeButton.tag = indexPath.row;
    [initiativeButton setTitle:@"SET INITIATIVE" forState:UIControlStateNormal];
    initiativeButton.frame = CGRectMake(900, 82, 120, 30);
    //initiativeButton.backgroundColor = [UIColor redColor];
    initiativeButton.titleLabel.font = labelfont;
    initiativeButton.tintColor = generalColor;
    [cell addSubview:initiativeButton];
    
    //cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void)addDamagePrompt:(id)sender
{
    promptType = 0; //damage
    UIButton * indexPressed = (UIButton *)sender;
    indexEdited = (int)indexPressed.tag;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ADD DAMAGE" message:@"Enter damage for this character:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)addCurePrompt:(id)sender
{
    promptType = 1; //cure
    UIButton * indexPressed = (UIButton *)sender;
    indexEdited = (int)indexPressed.tag;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ADD CURE" message:@"Enter cure for this character:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)setInitiativePrompt:(id)sender
{
    promptType = 2; //set initiative
    UIButton * indexPressed = (UIButton *)sender;
    indexEdited = (int)indexPressed.tag;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"SET INITIATIVE" message:@"Enter initiative for this character:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)castSpellPrompt:(id)sender
{
    promptType = 3; //spell
    UIButton * indexPressed = (UIButton *)sender;
    indexEdited = (int)indexPressed.tag;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"CAST SPELL" message:@"Cast spell of which level?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (promptType == 0) //damage
    {
        int currentHP = [[[characterList objectAtIndex:indexEdited] currentHitPoints] integerValue];
        currentHP = currentHP - [[[alertView textFieldAtIndex:0]text] integerValue];
        if (currentHP < 0)
            currentHP = 0;
        NSString *newCurrentHP = [NSString stringWithFormat:@"%d", currentHP];
        [[characterList objectAtIndex:indexEdited] setCurrentHitPoints:newCurrentHP];
    }
    else if (promptType == 1) //cure
    {
        int currentHP = [[[characterList objectAtIndex:indexEdited] currentHitPoints] integerValue];
        currentHP = currentHP + [[[alertView textFieldAtIndex:0]text] integerValue];
        if (currentHP > [[[characterList objectAtIndex:indexEdited] maxHitPoints] integerValue])
            currentHP = [[[characterList objectAtIndex:indexEdited] maxHitPoints] integerValue];
        NSString *newCurrentHP = [NSString stringWithFormat:@"%d", currentHP];
        [[characterList objectAtIndex:indexEdited] setCurrentHitPoints:newCurrentHP];
    }
    else if (promptType == 2) // set Initiative
    {
        [[characterList objectAtIndex:indexEdited] setInitiativeBonus:[[[alertView textFieldAtIndex:0]text] integerValue]];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"initiativeBonus" ascending:FALSE];
        [characterList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    if (promptType == 3) //spell
    {
        if ([[[alertView textFieldAtIndex:0]text] integerValue] == 0)
            return;
        
        int spellLevel = (int)[[[alertView textFieldAtIndex:0]text] integerValue];
        int indexedLevel = spellLevel - 1;
        if ([[[characterList objectAtIndex:indexEdited] spellSlots] count] >= spellLevel)
        {
            if ([[[[characterList objectAtIndex:indexEdited] availableSpellSlots] objectAtIndex: indexedLevel] integerValue] > 0)
            {
                int currentSpellCountForThatLevel = (int)[[[[characterList objectAtIndex:indexEdited] availableSpellSlots] objectAtIndex: indexedLevel] integerValue] - 1;
                NSString * aObject = [NSString stringWithFormat:@"%d", currentSpellCountForThatLevel];
                NSMutableArray *newArray = [[NSMutableArray alloc] init];
                for (int j = 0; j < [[[characterList objectAtIndex:indexEdited] availableSpellSlots] count]; j++)
                {
                    if (j == indexedLevel)
                        [newArray addObject:aObject];
                    else
                        [newArray addObject:[[[characterList objectAtIndex:indexEdited] availableSpellSlots] objectAtIndex: j]];
                }
                //[[[characterList objectAtIndex:indexEdited] availableSpellSlots] replaceObjectAtIndex:indexedLevel withObject:aObject];
                [[characterList objectAtIndex:indexEdited] setAvailableSpellSlots:newArray];
            }
        }
    }
    [poolTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    indexEdited = indexPath.row;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: [@"Initiative - " stringByAppendingString:[[characterList objectAtIndex:indexPath.row] name]] message:@"Enter initiative for this character:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
     */
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [characterList count];
}

@end
