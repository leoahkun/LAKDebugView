//
//  LAKLogView.m
//  LAKDebugView
//
//  Created by Leonard Ah Kun on 2013/04/14.
//  Copyright (c) 2013 Leonard Ah Kun. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "LAKLogView.h"

#define kMoveBarHeight 20
#define kEdge 5

@interface LAKLogView ()
@property(nonatomic, strong) NSMutableArray *logArray;
@end

@implementation LAKLogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kEdge, kMoveBarHeight, self.frame.size.width-2*kEdge, self.frame.size.height-(2*kMoveBarHeight))];
		self.tableView.dataSource = self;
		self.tableView.delegate = self;
		self.tableView.backgroundColor = [UIColor blackColor];
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:self.tableView];
		self.logArray = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kEdge, kMoveBarHeight, self.frame.size.width-2*kEdge, self.frame.size.height-(2*kMoveBarHeight))];
		self.tableView.dataSource = self;
		self.tableView.delegate = self;
		self.tableView.backgroundColor = [UIColor blackColor];
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:self.tableView];
		self.logArray = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor darkGrayColor];
	}
	return self;
}

-(void) addLog:(NSString*) log {
	[self.logArray addObject:log];
	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.logArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.logArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *text = [self.logArray objectAtIndex:indexPath.row];
	CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:CGSizeMake(self.frame.size.width-(2*(kEdge+10)), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
	//	CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] forWidth:self.frame.size.width-(2*(EDGE+10)) lineBreakMode:UILineBreakModeWordWrap]; //+10 for cell buffer
	return textSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.textColor = [UIColor whiteColor];
		//cell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    }
	
    // Configure the cell...
	//cell.textLabel.frame = CGRectMake(10, 0, cell.frame.size.width-20, cell.frame.size.height);
	cell.textLabel.text = [self.logArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
