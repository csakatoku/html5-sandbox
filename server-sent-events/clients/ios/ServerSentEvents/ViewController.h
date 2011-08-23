//
//  ViewController.h
//  ServerSentEvents
//
//  Created by Sakatoku Chihiro on 11/08/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate> {
    __strong IBOutlet UITableView* _tableView;
    __strong NSURLConnection* _connection;
    __strong NSMutableString* _content;
    
    __strong NSMutableArray* _data;
}

@end
