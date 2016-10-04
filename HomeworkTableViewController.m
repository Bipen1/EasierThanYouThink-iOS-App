//
//  HomeworkTableViewController.m
//  PracticeLoadURL
//
//  Created by An Qi on 6/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import "HomeworkTableViewController.h"
#import "QuestionDisplay.h"

@interface HomeworkTableViewController ()

@end

@implementation HomeworkTableViewController

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
    
    // separate the number of questions and target time
    NSArray *HomeWorkLengthTime = [fullString componentsSeparatedByString:@"~~~~~"];
    
    _NumOfQuests = [HomeWorkLengthTime[0] integerValue];
    _TargetTime = HomeWorkLengthTime[1];
    
    // Prepare, so send the string with question info
    [self performSegueWithIdentifier:@"QuestionPage" sender:self.view];
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
    // Figures out which homework ID to use in the URL (same way as before)
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    _HomeworkID = _HomeworkIDs[[_Homework indexOfObject:cellText]];

    NSString *stringToBeSent= [[NSString alloc] initWithFormat:@"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@",_Name,separate,_Pass,separate,@"gethomeworksnumberofquestions",separate,_HomeworkID];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QuestionPage"]) {
        // All the info that needs to be passed on
        QuestionDisplay *QDVC = [segue destinationViewController];
        QDVC.HomeworkID = _HomeworkID;
        QDVC.Name = _Name;
        QDVC.Pass = _Pass;
        QDVC.NumOfQuests = _NumOfQuests;
        QDVC.TargetTime = _TargetTime;
        QDVC.StudentNum = _StudentNum;
        QDVC.CourseID = _CourseID;
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
    // have number of cells based on number of homework available
    return [_Homework count];
}

// configure the table cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cells and give the labels with homework neames
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkCell" forIndexPath:indexPath];
    cell.textLabel.text = [_Homework objectAtIndex:indexPath.row];
    
    return cell;
}

@end
