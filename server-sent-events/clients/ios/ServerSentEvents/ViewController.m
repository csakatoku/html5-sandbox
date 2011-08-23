//
//  ViewController.m
//  ServerSentEvents
//
//  Created by Sakatoku Chihiro on 11/08/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "EventData.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _data = [NSMutableArray array];

    _content = [[NSMutableString alloc] init];

    NSURL* url = [NSURL URLWithString:@"http://localhost:8000/eventsource"];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response mimetype = %@", [response MIMEType]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceCharacterSet];

    NSString* content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [_content appendString:content];

    NSMutableArray* events = [NSMutableArray array];
    NSArray* lines = [_content componentsSeparatedByString:@"\n"];

    int breakLineCount = 0;
    __autoreleasing NSString* currentEventId = nil;
    __autoreleasing NSString* currentEventName = nil;
    __autoreleasing NSMutableString* currentData = [[NSMutableString alloc] init];

    for (NSString* line in lines) {
        if ([line length] == 0) {
            breakLineCount += 1;

            if (breakLineCount > 1) {
                __autoreleasing EventData* event = [[EventData alloc] init];
                event.eventId = currentEventId;
                event.eventName = currentEventName;
                event.data = currentData;
                [events addObject:event];

                breakLineCount = 0;
                currentEventId = nil;
                currentData = nil;

                continue;
            }
        }

        if ([line hasPrefix:@"id"]) {
            currentEventId = [[line substringFromIndex:[@"id:" length]] stringByTrimmingCharactersInSet:whitespace];
        } else if ([line hasPrefix:@"event"]) {
            currentEventName = [[line substringFromIndex:[@"event:" length]] stringByTrimmingCharactersInSet:whitespace];
        } else if ([line hasPrefix:@"data"]) {
            NSString* data = [[line substringFromIndex:[@"data:" length]] stringByTrimmingCharactersInSet:whitespace];
            [currentData appendString:data];
        } else if ([line hasPrefix:@"retry"]) {
            // TODO
        }
    }

    for (EventData* event in events) {
        [_data insertObject:event atIndex:0];

        [_tableView beginUpdates];
        NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [_tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
        [_tableView endUpdates];
    }

    _content = [[NSMutableString alloc] init];
}

#pragma mark - UITableDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"identifier";
    
    __autoreleasing UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    EventData* event = [_data objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"id:%@ name:%@", event.eventId, event.eventName];
    cell.detailTextLabel.text = event.data;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
