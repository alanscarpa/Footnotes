//
//  HomeTableViewController.m
//  Footnotes
//
//  Created by Alan Scarpa on 7/2/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "HomeTableViewController.h"
#import "DataStore.h"
#import "Article.h"
#import "ArticleViewController.h"

@interface HomeTableViewController ()


@property (nonatomic, strong) NSArray *listOfArticles;
@property (nonatomic, strong) DataStore *dataStore;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dataStore = [DataStore sharedDataStore];
    
    
    NSFetchRequest *requestArticles = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    
    NSSortDescriptor *sortArticlesByDate = [NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO];
    requestArticles.sortDescriptors = @[sortArticlesByDate];
    
    // NSLog(@"%@", [self.dataStore.managedObjectContext executeFetchRequest:requestArticles error:nil]);
    
    self.listOfArticles = [self.dataStore.managedObjectContext executeFetchRequest:requestArticles error:nil];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.dataStore.managedObjectContext deleteObject:self.listOfArticles[indexPath.row]];
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[self.listOfArticles mutableCopy]];
        [tempArray removeObjectAtIndex:indexPath.row];
        self.listOfArticles = tempArray;
        [self.dataStore save];
        
        [UIView animateWithDuration:1.0 animations:^{
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];

        
        
        
    }
    
}

#pragma mark - Table view data source


- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.dataStore.managedObjectContext deleteObject:self.listOfArticles[indexPath.row]];
//    [self.dataStore save];
//    [self.tableView reloadData];

}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//        [self.dataStore.managedObjectContext deleteObject:self.listOfArticles[indexPath.row]];
//        [self.dataStore save];
//        [self.tableView reloadData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.listOfArticles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleTitleCell" forIndexPath:indexPath];
    
    if (self.listOfArticles.count > 0){
        Article *article = self.listOfArticles[indexPath.row];
        cell.textLabel.text = article.title;
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    ArticleViewController *destinationVC = segue.destinationViewController;
    destinationVC.article = self.listOfArticles[indexPath.row];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




@end
