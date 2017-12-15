//
//  ViewController.m
//  DMCompanion
//
//  Created by Christian Coimbra on 20/09/14.
//  Copyright (c) 2014 Spacecat Studio. All rights reserved.
//

#import "ViewController.h"
#import "CharacterPoolViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showCharacterPool:(id)sender
{
    //CharacterPoolViewController * pool = [[CharacterPoolViewController alloc] init];
    [self performSegueWithIdentifier:@"NavigateToCharacterPool" sender:self];
}


-(IBAction)showCombatTracker:(id)sender
{
    //CharacterPoolViewController * pool = [[CharacterPoolViewController alloc] init];
    [self performSegueWithIdentifier:@"NavigateToCombatTracker" sender:self];
}

@end
