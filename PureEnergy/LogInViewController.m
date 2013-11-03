//
//  ViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController (){
    
    __weak IBOutlet UIImageView *bannerImageView;
    __weak IBOutlet UITextField *usernameTextField;
    __weak IBOutlet UITextField *passwordTextField;
}
- (IBAction)registerNewUser:(id)sender;
- (IBAction)recoverPassword:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerNewUser:(id)sender {
}

- (IBAction)recoverPassword:(id)sender {
}

- (IBAction)login:(id)sender {
}
@end
