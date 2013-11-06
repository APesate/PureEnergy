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
    [electricMeter.layer setCornerRadius:30];
    [waterMeter.layer setCornerRadius:30];
    
    UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    
    [rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [leftSwipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:rightSwipeGesture];
    [self.view addGestureRecognizer:leftSwipeGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeGesture:(UISwipeGestureRecognizer*)sender{
    if ([sender direction] == UISwipeGestureRecognizerDirectionRight) {
        [self performSegueWithIdentifier:@"toRanking" sender:self];
    }else if([sender direction] == UISwipeGestureRecognizerDirectionLeft){
        [self performSegueWithIdentifier:@"toGraphics" sender:self];
    }
}

@end
