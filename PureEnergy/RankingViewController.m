//
//  RankingViewController.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "RankingViewController.h"

@interface RankingViewController (){
    __weak IBOutlet UITableView* rankingTableView;
}

-(IBAction)goBack:(id)sender;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

#pragma mark - TableView
#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

#pragma mark UITableViewDataSource

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Return the numbers of rows in each Section of the Table View
    return 0;
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
    
    
    return cell;
}

@end
