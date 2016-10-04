//
//  CoursePickTableViewController.m
//  PracticeLoadURL
//
//  Created by An Qi on 5/22/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import "CoursePickTableViewController.h"
#import "UnitPickTableViewController.h"
#pragma mark NSURLConnection Delegate Methods
@interface CoursePickTableViewController ()

@end

@implementation CoursePickTableViewController

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
    
    // This will store the list of unit IDs and Names into arrays
    NSArray *UnitArray = [fullString componentsSeparatedByString:@"~~~~~"];
    int count = [UnitArray count]/2;
    
    _Units = [[NSMutableArray alloc] initWithCapacity:count];
    _UnitsID = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 2; i <= [UnitArray count]; i+=2) {
        [_Units addObject:UnitArray[i-1]];
        [_UnitsID addObject:UnitArray[i-2]];
    }
    
    // Prepare to go to next segue, so send the string with question info
    [self performSegueWithIdentifier:@"PickUnit" sender:self.view];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    // Create an alert to show the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Cannot connect to server. Please check your internect connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];   // Show the alert to the user
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString const *separate = @"~~~~~";
    
    // Will figure out which course ID to used based on name of course selected
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    _CourseID = _CourseIDs[[_CourseInfo indexOfObject:cellText]];
    
    NSString *stringToBeSent= [[NSString alloc] initWithFormat:@"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@",_Name,separate,_Pass,separate,@"getunits",separate,_CourseID];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickUnit"]) {
        // All the info we need to pass on to the next segue
        UnitPickTableViewController *UPTVC = [segue destinationViewController];
        UPTVC.UnitInfo = _Units;
        UPTVC.UnitIDs = _UnitsID;
        UPTVC.CourseID = _CourseID;
        UPTVC.Name = _Name;
        UPTVC.Pass = _Pass;
        UPTVC.StudentNum = _StudentNum;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInitialData {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // We only need one section in this table view
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. Essentially, tells how many table cells to make
    return [_CourseInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourseCell";
    
    // This will put the course names into the cells
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_CourseInfo objectAtIndex:indexPath.row];
    
    return cell;
}

@end
