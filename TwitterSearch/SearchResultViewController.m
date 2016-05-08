//
//  SearchResultViewController.m
//  TwitterSearch
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "SearchResultViewController.h"
#import "TwitterAddData.h"
#import "AppDelegate.h"

@interface SearchResultViewController ()<UITabBarControllerDelegate, UITableViewDelegate>
{
    NSArray *arrRecords;
}

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchRecords];
    // Do any additional setup after loading the view.
}

- (void)fetchRecords {
    AppDelegate *app = [AppDelegate sharedInstance];
    arrRecords = [TwitterAddData fetchDataFromDB:app.managedObjectContext];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrRecords count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    TwitterModel *data = [arrRecords objectAtIndex:indexPath.row];
    cell.textLabel.text = data.title;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
