//
//  RegisterViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController (){
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *lastnameTextField;
    __weak IBOutlet UITextField *usernameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *verifyPassTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *fieldsContainer;
    __weak IBOutlet UIView *buttonContainers;
}

-(IBAction)goBack:(id)sender;
-(IBAction)submitData:(id)sender;

@end

@implementation RegisterViewController

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
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [scrollView addGestureRecognizer:tapGesture];
    [fieldsContainer.layer setCornerRadius:15];
    [buttonContainers.layer setCornerRadius:15];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];

    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + buttonContainers.frame.size.height)];
}

-(IBAction)goBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)submitData:(id)sender{
    if ([self verifyFields]) {
        [self sendRegisterInformation];
    }
}

-(BOOL)verifyFields{
    if (![passwordTextField.text isEqualToString:verifyPassTextField.text]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The Verifyed password and the real password doen't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        passwordTextField.text = @"";
        verifyPassTextField.text = @"";
        [passwordTextField becomeFirstResponder];
        return NO;
    }else if([passwordTextField.text isEqualToString:@""] ||
             [usernameTextField.text isEqualToString:@""] ||
             [nameTextField.text isEqualToString:@""] ||
             [lastnameTextField.text isEqualToString:@""] ||
             [emailTextField.text isEqualToString:@""] ||
             [verifyPassTextField.text isEqualToString:@""]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill all the information requested" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - Send Data to Server

-(void)sendRegisterInformation{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/registerUser.php?appKey=KEY&seudonimo=%@&pass=%@&nom=%@&apellido=%@&email=%@", usernameTextField.text, passwordTextField.text, nameTextField.text, lastnameTextField.text, emailTextField.text]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if ([answer isEqualToString:@"0"]) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }else if ([answer isEqualToString:@"1"]){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Succesfully Registered.\nThanks" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        }else if ([answer isEqualToString:@"2"]){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error connecting to server.\nPlease try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }else if ([answer isEqualToString:@"3"]){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Username already used." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }else if ([answer isEqualToString:@"4"]){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error connecting to server.\nPlease try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

#pragma mark - Delegates
#pragma mark UIAlertView

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Thanks!"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITextField

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    const int keyBoardPadding = 110;
    
    [scrollView setScrollEnabled:YES];
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + buttonContainers.frame.size.height + keyBoardPadding)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + buttonContainers.frame.size.height)];
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, - scrollView.contentInset.top) animated:YES];
}

#pragma TapGesture

-(void)tapGesture:(UITapGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [nameTextField resignFirstResponder];
        [lastnameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        [verifyPassTextField resignFirstResponder];
        [emailTextField resignFirstResponder];
        [usernameTextField resignFirstResponder];
    }
}

@end
