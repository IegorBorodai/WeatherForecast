//
//  UIControl+SHControlEventBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#pragma mark - Block Defs
typedef void (^SHControlEventBlock)(UIControl * sender);

@interface UIControl (SHControlBlocks)


#pragma mark - Add block
-(void)completionAddControlEvents:(UIControlEvents)controlEvents
                 withBlock:(SHControlEventBlock)theBlock;

-(void)completionAddControlEventTouchUpInsideWithBlock:(SHControlEventBlock)theBlock;



#pragma mark - Remove block
-(void)completionRemoveControlEventTouchUpInside;
-(void)completionRemoveBlocksForControlEvents:(UIControlEvents)controlEvents;
-(void)completionRemoveControlEventsForBlock:(SHControlEventBlock)theBlock;
-(void)completionRemoveAllControlEventsBlocks;


#pragma mark - Helpers
-(NSSet *)completionBlocksForControlEvents:(UIControlEvents)theControlEvents;
-(NSSet *)completionControlEventsForBlock:(SHControlEventBlock)theBlock;



#pragma mark - Properties


#pragma mark - Getters
@property(nonatomic,readonly) BOOL SH_isTouchUpInsideEnabled;
@property(nonatomic,readonly) NSDictionary * completionControlBlocks;


@end
