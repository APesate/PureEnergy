//
//  ViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController (){
    
    __weak IBOutlet UIView* fieldsContainer;
    __weak IBOutlet UIImageView *bannerImageView;
    __weak IBOutlet UITextField *usernameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UILabel *passwordLabel;
    __weak IBOutlet UIButton *forgotPasswordButton;
    __weak IBOutlet UIButton *loginButton;
    __weak IBOutlet UIButton *registerButton;
    
    BOOL isScrolled;
}
- (IBAction)registerNewUser:(id)sender;
- (IBAction)recoverPassword:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    isScrolled = NO;
    
    [super viewDidLoad];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    [fieldsContainer.layer setCornerRadius:30];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIView animateWithDuration:0.7f animations:^{
        [fieldsContainer setAlpha:1.0];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animateExitTo:(NSString*)segueIdentifier{
    __block const int downMove = 10;
    __block const int moveOffScreen = fieldsContainer.frame.origin.y + fieldsContainer.frame.size.height + 20;
    
    [UIView animateWithDuration:0.3f animations:^{
        [fieldsContainer setFrame:CGRectMake(fieldsContainer.frame.origin.x,
                                             fieldsContainer.frame.origin.y + downMove,
                                             fieldsContainer.frame.size.width,
                                             fieldsContainer.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4f animations:^{
            [fieldsContainer setFrame:CGRectMake(fieldsContainer.frame.origin.x,
                                                 fieldsContainer.frame.origin.y - moveOffScreen,
                                                 fieldsContainer.frame.size.width,
                                                 fieldsContainer.frame.size.height)];
            [fieldsContainer setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self performSegueWithIdentifier:segueIdentifier sender:self];
        }];
    }];
}

#pragma mark - IBActions

- (IBAction)registerNewUser:(id)sender {
    [self animateExitTo:@"toRegister"];
}

- (IBAction)recoverPassword:(id)sender {
}

- (IBAction)login:(id)sender {
    [self tryLogIn];
}

#pragma mark - WebServices connections

-(void)tryLogIn{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/login.php?appKey=KEY&seudonimo=%@&pass=%@", usernameTextField.text, passwordTextField.text]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (![answer isEqualToString:@"0"] && response != nil) {
            
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[jsonDictionary objectForKey:@"seudonimo"] forKey:@"username"];
            [userDefault setObject:[jsonDictionary objectForKey:@"password"] forKey:@"password"];
            [userDefault setObject:[jsonDictionary objectForKey:@"nombre"] forKey:@"realName"];
            [userDefault setObject:[jsonDictionary objectForKey:@"apellido"] forKey:@"realLastname"];
            
            [self animateExitTo:@"toMeters"];
        }else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The username and/or password is invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    static int scroll = 85;
    
    if (!isScrolled) {
        [UIView animateWithDuration:0.4f animations:^{
            [fieldsContainer setFrame:CGRectMake(fieldsContainer.frame.origin.x,
                                                 fieldsContainer.frame.origin.y - scroll,
                                                 fieldsContainer.frame.size.width,
                                                 fieldsContainer.frame.size.height)];
        }];
        isScrolled = YES;
    }
}

-(void)scrollDownContainer{
    
    static int scroll = 85;
    
    if (isScrolled) {
        [UIView animateWithDuration:0.4f animations:^{
            [fieldsContainer setFrame:CGRectMake(fieldsContainer.frame.origin.x,
                                                 fieldsContainer.frame.origin.y + scroll,
                                                 fieldsContainer.frame.size.width,
                                                 fieldsContainer.frame.size.height)];
        }];
        isScrolled = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType == UIReturnKeyNext){
        [passwordTextField becomeFirstResponder];
        return YES;
    }else{
        [self tryLogIn];
        [textField resignFirstResponder];
        [self scrollDownContainer];
        return YES;
    }
}

- (void)tapGesture:(UITapGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [usernameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        [self scrollDownContainer];
    }
}
@end
