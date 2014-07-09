//
//  UIViewController+SHSegueBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#pragma mark -
#pragma mark Block Defs

typedef void(^SHPrepareForSegue)(UIStoryboardSegue *theSegue);
typedef void(^SHPrepareForSegueDestinationViewController)(UIViewController * theDestinationViewController);
typedef void(^SHPrepareForSegueWithUserInfo)(NSMutableDictionary * theUserInfo);



@interface UIViewController (SHSegueBlocks)


//#pragma mark - Properties
//
//@property(nonatomic,strong) NSMutableDictionary * SH_userInfo;


#pragma mark - Segue Performers

-(void)completionPerformSegueWithIdentifier:(NSString *)theIdentifier
                    andPrepareForSegueBlock:(SHPrepareForSegue)theBlock;

-(void)completionPerformSegueWithIdentifier:(NSString *)theIdentifier
               andDestinationViewController:(SHPrepareForSegueDestinationViewController)theBlock;

-(void)completionPerformSegueWithIdentifier:(NSString *)theIdentifier
                               withUserInfo:(NSDictionary *)theUserInfo;


#pragma mark - Segue Observers
-(void)observeSegueWithIdentifier:(NSString *)theIdentifier
          andPrepareForSegueBlock:(SHPrepareForSegue)theBlock;

#pragma mark - Helpers
-(BOOL)completionHandlesBlockForSegue:(UIStoryboardSegue *)theSegue;



@end
