//
//  GraphicsViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//
#import "GraphicsViewController.h"
#import"GraphView.h"
#import "FUISwitch.h"
#import "UIColor+FlatUI.h"
#import"UIFont+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FlatUIKit.h"
#import"GraphView.h"

@interface GraphicsViewController ()
{
    __weak IBOutlet GraphView *graph1;
    // __weak IBOutlet FUISwitch * toggleButton;
    FUISwitch * toggleButton;
    int graphWidth;
    
    
    
}
- (IBAction)switchGraph:(id)sender;
-(IBAction)goback:(id)sender;
@end

@implementation GraphicsViewController
@synthesize scroller, ident;

- (void)viewDidLoad
{
    [super viewDidLoad];
    graphWidth=1000;
    scroller.contentSize = CGSizeMake(kDefaultGraphWidth, kGraphHeight);
    toggleButton = [[FUISwitch alloc] initWithFrame:(CGRectMake(120, 500, 100, 27))];
    [self.view addSubview:toggleButton];
    toggleButton.on=YES;
    graph1.alpha=YES;
    graph1.ident = self.ident;
    //graph2.ident = self.ident;
    toggleButton.onColor = [UIColor sunflowerColor];
    toggleButton.offColor = [UIColor turquoiseColor];
    toggleButton.onBackgroundColor = [UIColor midnightBlueColor];
    toggleButton.offBackgroundColor = [UIColor midnightBlueColor];
    toggleButton.offLabel.font = [UIFont boldFlatFontOfSize:14];
    toggleButton.onLabel.font = [UIFont boldFlatFontOfSize:14];
    [toggleButton addTarget: self action: @selector(switchGraph:) forControlEvents:UIControlEventValueChanged];
    graph1.delegate = self;
    graph1.serviceType = @"1";
    //graph2.delegate = self;
    [self.scroller setContentSize:CGSizeMake(graph1.scrollerWidth, kGraphHeight)];
    [graph1 GetInfo];
    toggleButton.onLabel.text = @"Electricity";
    toggleButton.offLabel.text = @"Water";
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scroller setContentSize:CGSizeMake(graph1.scrollerWidth, kGraphHeight)];
    
}

-(void)receiveLength:(int)value
{
    [self.scroller setContentSize:CGSizeMake(value, kGraphHeight)];
    
    
}

- (IBAction)switchGraph:(id)sender {
    
    if(toggleButton.on) {
        
      //  graph1.alpha=1;
    //    graph2.alpha=0;
        graph1.serviceType = @"1";
        [self.scroller setContentSize:CGSizeMake(graph1.scrollerWidth, kGraphHeight)];
        [graph1 GetInfo];
    }
    
    else {
//        graph2.alpha=1;
  //      graph1.alpha=0;
        graph1.serviceType = @"2";
        [self.scroller setContentSize:CGSizeMake(graph1.scrollerWidth, kGraphHeight)];
        [graph1 GetInfo];
        
    }
}

-(IBAction)goback:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end