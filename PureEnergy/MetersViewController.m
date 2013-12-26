//
//  MetersViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "MetersViewController.h"

@interface MetersViewController (){
    __weak IBOutlet Meter* electricMeter;
    __weak IBOutlet Meter* waterMeter;
}

@end

@implementation MetersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toGraph"]) {
        GraphicsViewController* graphViewController = segue.destinationViewController;
        graphViewController.ident = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    }
}

@end
