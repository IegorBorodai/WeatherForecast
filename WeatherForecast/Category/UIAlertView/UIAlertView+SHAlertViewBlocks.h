//
//  UIAlertView+SHAlertViewBlocks.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#pragma mark -
#pragma mark Block Defs
typedef void (^SHAlertViewBlock)(NSInteger theButtonIndex);
typedef void (^SHAlertViewShowBlock)(UIAlertView * theAlertView);
typedef void (^SHAlertViewDismissBlock)(UIAlertView * theAlertView, NSInteger theButtonIndex);

typedef BOOL (^SHAlertViewFirstButtonEnabledBlock)(UIAlertView * theAlertView);

@interface UIAlertView (SHAlertViewBlocks)


#pragma mark - Init
+(instancetype)completionAlertViewWithTitle:(NSString *)theTitle withMessage:(NSString *)theMessage;

+(instancetype)completionAlertViewWithTitle:(NSString *)theTitle
                                 andMessage:(NSString *)theMessage
                               buttonTitles:(NSArray *)theButtonTitles
                                cancelTitle:(NSString *)theCancelTitle
                                  withBlock:(SHAlertViewBlock)theBlock;



#pragma mark - Adding
-(NSInteger)completionAddButtonWithTitle:(NSString *)theTitle
                               withBlock:(SHAlertViewBlock)theBlock;


///Will add a new cancel button and make previous cancel buttons to a normal button
-(NSInteger)completionAddButtonCancelWithTitle:(NSString *)theTitle
                                     withBlock:(SHAlertViewBlock)theBlock;


#pragma mark - Properties


#pragma mark - Setters
-(void)completionSetButtonBlockForIndex:(NSInteger)theButtonIndex
                              withBlock:(SHAlertViewBlock)theBlock;

-(void)completionSetButtonCancelBlock:(SHAlertViewBlock)theBlock;

-(void)completionSetWillShowBlock:(SHAlertViewShowBlock)theBlock;
-(void)completionSetDidShowBlock:(SHAlertViewShowBlock)theBlock;

-(void)completionSetWillDismissBlock:(SHAlertViewDismissBlock)theBlock;
-(void)completionSetDidDismissBlock:(SHAlertViewDismissBlock)theBlock;

-(void)completionSetFirstButtonEnabledBlock:(SHAlertViewFirstButtonEnabledBlock)theBlock;


#pragma mark - Getters
-(SHAlertViewBlock)completionBlockForButtonIndex:(NSInteger)theButtonIndex;


@property(nonatomic,readonly) SHAlertViewBlock completionBlockForCancelButton;


@property(nonatomic,readonly) SHAlertViewShowBlock    completionBlockWillShow;
@property(nonatomic,readonly) SHAlertViewShowBlock    completionBlockDidShow;

@property(nonatomic,readonly) SHAlertViewDismissBlock completionBlockWillDismiss;
@property(nonatomic,readonly) SHAlertViewDismissBlock completionBlockDidDismiss;

@property(nonatomic,readonly) SHAlertViewFirstButtonEnabledBlock completionBlockForFirstButtonEnabled;

@end
