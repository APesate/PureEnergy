//
//  UserInfoViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/11/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController (){
    
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *lastnameLabel;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UILabel *emailLabel;
    __weak IBOutlet UIView *buttonsContainer;
    __weak IBOutlet UIView *nameContainer;
    __weak IBOutlet UIView *lastnameContainer;
    __weak IBOutlet UIView *usernameConatiner;
    __weak IBOutlet UIView *emailContainer;
}

-(IBAction)goBack:(id)sender;

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"realName"];
    lastnameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"realLastname"];
    usernameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    emailLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    
    [nameContainer.layer setCornerRadius:10];
    [lastnameContainer.layer setCornerRadius:10];
    [usernameConatiner.layer setCornerRadius:10];
    [emailContainer.layer setCornerRadius:10];
    [buttonsContainer.layer setCornerRadius:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
