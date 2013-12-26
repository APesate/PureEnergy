//
//  RankingViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "RankingViewController.h"

@interface RankingViewController (){
    NSMutableArray* searchArray;
    NSMutableArray* friendsArray;
    __weak IBOutlet UITableView* rankingTableView;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UISearchDisplayController* searchDisplay;
    __weak IBOutlet UISwitch *orderBySwitch;
    __weak IBOutlet UIView *switchContainer;
    
    int friendSelected;
}

-(IBAction)goBack:(id)sender;
-(IBAction)sortby:(id)sender;

@end

@implementation RankingViewController

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
    searchArray = [NSMutableArray arrayWithCapacity:10];
    friendsArray = [NSMutableArray arrayWithCapacity:10];

    [super viewDidLoad];
    [orderBySwitch setOnImage:[UIImage imageNamed:@"lightColor.png"]];
    [orderBySwitch setOffImage:[UIImage imageNamed:@"dropColor.png"]];
    [switchContainer.layer setCornerRadius:10];
    [[searchDisplay searchResultsTableView] setTag:1];
    [self loadFriends];
    [rankingTableView.layer setCornerRadius:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

-(IBAction)goBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sortby:(id)sender{
    //ON  = Sort by Electricity
    //OFF = Sort by Water
    if ([sender isOn]) {
        [self sortArrayByConsumeType:1];
    }else{
        [self sortArrayByConsumeType:2];
    }
}

-(void)sortArrayByConsumeType:(int)consumeType{
    [friendsArray enumerateObjectsUsingBlock:^(Persona* obj1, NSUInteger idx1, BOOL *stop) {
        [friendsArray enumerateObjectsUsingBlock:^(Persona* obj2, NSUInteger idx2, BOOL *stop) {
            if ([obj1.consumesArray objectAtIndex:(consumeType-1)] < [obj2.consumesArray objectAtIndex:(consumeType-1)] && (idx1 != idx2)) {
                [friendsArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
            }
        }];
    }];
    
    [rankingTableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GraphicsViewController* graphViewController = segue.destinationViewController;
    graphViewController.ident = ((Persona*)[friendsArray objectAtIndex:friendSelected]).ident;
    
}

#pragma mark - TableView
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == searchDisplay.searchResultsTableView) {
        Persona* aux = [searchArray objectAtIndex:indexPath.row];
        
        [self addNewFriend:aux.ident];
    }else{
        friendSelected = indexPath.row;
        [self performSegueWithIdentifier:@"toGraph" sender:self];
    }
}

#pragma mark UITableViewDataSource

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Return the numbers of rows in each Section of the Table View
    if (tableView == searchDisplay.searchResultsTableView) {
        return [searchArray count];
    }else{
        return [friendsArray count];
    }
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    //Return the number of Sections in the Table View
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
    }
    
    if (tableView == searchDisplay.searchResultsTableView) {
        Persona* aux = [searchArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", aux.name, aux.lastname];
    }else{
        Persona* aux = [friendsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", aux.name, aux.lastname];
    }

    return cell;
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [searchArray removeAllObjects];
    [self dataRequest];
}

#pragma mark - WebService Connections

-(void)dataRequest{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/searchUser.php?appKey=KEY&username=%@", searchBar.text]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (![answer isEqualToString:@"0"]) {
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            Persona* persona = [[Persona alloc] init];
            
            persona.name = [jsonDictionary objectForKey:@"nombre"];
            persona.lastname = [jsonDictionary objectForKey:@"apellido"];
            persona.ident = [jsonDictionary objectForKey:@"id"];
            
            [searchArray addObject:persona];
            [searchDisplay.searchResultsTableView reloadData];
        }
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
    }];
}

-(void)loadFriends{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/loadFriends.php?appKey=KEY&userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (![answer isEqualToString:@"0"]) {
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSArray* jsonArray = [jsonDictionary objectForKey:@"friends"];
            
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
                Persona* persona = [[Persona alloc] init];
                
                persona.name = [obj objectForKey:@"nombre"];
                persona.lastname = [obj objectForKey:@"apellido"];
                persona.ident = [obj objectForKey:@"id"];
                
                [[obj objectForKey:@"consumo"] enumerateObjectsUsingBlock:^(NSString* consume, NSUInteger idx, BOOL *stop) {
                    [persona.consumesArray addObject:consume];
                }];
                
                [friendsArray addObject:persona];
            }];
            
            [self sortArrayByConsumeType:1];
            [rankingTableView reloadData];
        }
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
    }];
}

-(void)addNewFriend:(NSString*)friendID{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/addNewFriend.php?appKey=KEY&friendID=%@&userID=%@", friendID, [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

        if ([answer isEqualToString:@"1"]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"This user has already been added as a friend"
                                                           delegate:self
                                                  cancelButtonTitle:@"Oh Right!"
                                                  otherButtonTitles: nil];
            [alert show];
        }else if([answer isEqualToString:@"2"]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"..."
                                                            message:@"You can't be your own friend! -.-"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK >.<"
                                                  otherButtonTitles: nil];
            [alert show];
        }else if([answer isEqualToString:@"3"]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Great!"
                                                            message:@"You have a new friend!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Awesome!"
                                                  otherButtonTitles: nil];
            [alert show];
        }else if([answer isEqualToString:@"0"]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"Couldn't connecto to the server.\nPlease try again later."
                                                           delegate:self
                                                  cancelButtonTitle:@"Alright!"
                                                  otherButtonTitles: nil];
            [alert show];
        }
            [searchDisplay setActive:NO];
            [self loadFriends];
            [rankingTableView reloadData];
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
    }];
}

#pragma  mark - Gesture Recognizer

-(void)hideKeyboard:(UITapGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [searchBar resignFirstResponder];
    }
}

@end
