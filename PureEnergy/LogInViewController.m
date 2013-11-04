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
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UILabel *passwordLabel;
    __weak IBOutlet UIButton *forgotPasswordButton;
    __weak IBOutlet UIButton *loginButton;
    __weak IBOutlet UIButton *registerButton;
}
- (IBAction)registerNewUser:(id)sender;
- (IBAction)recoverPassword:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    [self.view addGestureRecognizer:tapGesture];
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
    [self tryLogIn];
}

-(void)tryLogIn{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/APesate/login.php?nom=%@&pass=%@", usernameTextField.text, passwordTextField.text]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if ([answer isEqualToString:@"0"]) {
            
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[jsonDictionary objectForKey:@"seudonimo"] forKey:@"username"];
            [userDefault setObject:[jsonDictionary objectForKey:@"password"] forKey:@"password"];
            [userDefault setObject:[jsonDictionary objectForKey:@"nombre"] forKey:@"realName"];
            [userDefault setObject:[jsonDictionary objectForKey:@"apellido"] forKey:@"realLastname"];
            
            [self performSegueWithIdentifier:@"toMeters" sender:self];
        }else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The username and/or password is invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    static int scroll = 85;
    
    [UIView animateWithDuration:0.5f animations:^{
        [usernameLabel setFrame:CGRectMake(usernameLabel.frame.origin.x,
                                           usernameLabel.frame.origin.y - scroll,
                                           usernameLabel.frame.size.width,
                                           usernameLabel.frame.size.height)];
        
        [usernameTextField setFrame:CGRectMake(usernameTextField.frame.origin.x,
                                               usernameTextField.frame.origin.y - scroll,
                                               usernameTextField.frame.size.width,
                                               usernameTextField.frame.size.height)];
        
        [passwordTextField setFrame:CGRectMake(passwordTextField.frame.origin.x,
                                               passwordTextField.frame.origin.y - scroll,
                                               passwordTextField.frame.size.width,
                                               passwordTextField.frame.size.height)];
        
        [passwordLabel setFrame:CGRectMake(passwordLabel.frame.origin.x,
                                           passwordLabel.frame.origin.y - scroll,
                                           passwordLabel.frame.size.width,
                                           passwordLabel.frame.size.height)];
        
        [registerButton setFrame:CGRectMake(registerButton.frame.origin.x,
                                            registerButton.frame.origin.y - scroll,
                                            registerButton.frame.size.width,
                                            registerButton.frame.size.height)];
        
        [forgotPasswordButton setFrame:CGRectMake(forgotPasswordButton.frame.origin.x,
                                                  forgotPasswordButton.frame.origin.y - scroll,
                                                  forgotPasswordButton.frame.size.width,
                                                  forgotPasswordButton.frame.size.height)];
        
        [loginButton setFrame:CGRectMake(loginButton.frame.origin.x,
                                         loginButton.frame.origin.y - scroll,
                                         loginButton.frame.size.width,
                                         loginButton.frame.size.height)];
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    static int scroll = 85;
    
    [UIView animateWithDuration:0.5f animations:^{
        [usernameLabel setFrame:CGRectMake(usernameLabel.frame.origin.x,
                                           usernameLabel.frame.origin.y + scroll,
                                           usernameLabel.frame.size.width,
                                           usernameLabel.frame.size.height)];
        
        [usernameTextField setFrame:CGRectMake(usernameTextField.frame.origin.x,
                                               usernameTextField.frame.origin.y + scroll,
                                               usernameTextField.frame.size.width,
                                               usernameTextField.frame.size.height)];
        
        [passwordTextField setFrame:CGRectMake(passwordTextField.frame.origin.x,
                                               passwordTextField.frame.origin.y + scroll,
                                               passwordTextField.frame.size.width,
                                               passwordTextField.frame.size.height)];
        
        [passwordLabel setFrame:CGRectMake(passwordLabel.frame.origin.x,
                                           passwordLabel.frame.origin.y + scroll,
                                           passwordLabel.frame.size.width,
                                           passwordLabel.frame.size.height)];
        
        [registerButton setFrame:CGRectMake(registerButton.frame.origin.x,
                                            registerButton.frame.origin.y + scroll,
                                            registerButton.frame.size.width,
                                            registerButton.frame.size.height)];
        
        [forgotPasswordButton setFrame:CGRectMake(forgotPasswordButton.frame.origin.x,
                                                  forgotPasswordButton.frame.origin.y + scroll,
                                                  forgotPasswordButton.frame.size.width,
                                                  forgotPasswordButton.frame.size.height)];
        
        [loginButton setFrame:CGRectMake(loginButton.frame.origin.x,
                                         loginButton.frame.origin.y +scroll,
                                         loginButton.frame.size.width,
                                         loginButton.frame.size.height)];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType == UIReturnKeyNext){
        [passwordTextField becomeFirstResponder];
        return YES;
    }else{
        [self tryLogIn];
        return YES;
    }
}

- (void)tapGesture:(UITapGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [usernameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
    }
}
@end
