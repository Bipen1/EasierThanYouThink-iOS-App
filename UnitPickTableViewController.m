//
//  UnitPickTableViewController.m
//  PracticeLoadURL
//
//  Created by An Qi on 5/30/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import "UnitPickTableViewController.h"
#import "HomeworkTableViewController.h"
#pragma mark NSURLConnection Delegate Methods
@interface UnitPickTableViewController ()

@end

@implementation UnitPickTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // Parse the stuff in instance variable now
    fullString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    // Puts the homework names and IDs into arrays
    NSArray *HomeworkArray = [fullString componentsSeparatedByString:@"~~~~~"];
    int count = [HomeworkArray count]/2;
    
    _Homework = [[NSMutableArray alloc] initWithCapacity:count];
    _HomeworkIDs = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 2; i <= [HomeworkArray count]; i+=2) {
        [_Homework addObject:HomeworkArray[i-1]];
        [_HomeworkIDs addObject:HomeworkArray[i-2]];
    }
    
    
    // Prepare, so send the string with question info
    [self performSegueWithIdentifier:@"PickHomeWork" sender:self.view];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    // Create an alert to show the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Cannot connect to server. Please check your internect connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];   // Show the alert to the user
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString const *separate = @"~~~~~";
    
    // Will figure out which Unit was selected (same way as before), and sends it in url
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    _UnitID = _UnitIDs[[_UnitInfo indexOfObject:cellText]];
    
    NSString *stringToBeSent= [[NSString alloc] initWithFormat:@"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@%@%@",_Name,separate,_Pass,separate,@"gethomeworks",separate,_CourseID,separate,_UnitID];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickHomeWork"]) {
        // All the info we need to pass on to the next segue
        HomeworkTableViewController *HWTVC = [segue destinationViewController];
        HWTVC.Homework = _Homework;
        HWTVC.HomeworkIDs = _HomeworkIDs;
        HWTVC.UnitID = _UnitID;
        HWTVC.CourseID = _CourseID;
        HWTVC.Name = _Name;
        HWTVC.Pass = _Pass;
        HWTVC.StudentNum = _StudentNum;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Again, only need one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of sections based on number of Units available
    return [_UnitInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UnitCell";
    // Fills the cells with the Unit names from the array
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_UnitInfo objectAtIndex:indexPath.row];
    
    return cell;
}



@end
