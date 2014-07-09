//
//  UIControl+SHControlEventBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "UITextField+SHTextFieldBlocks.h"

#define SHStaticConstString(X) static NSString * const X = @#X

SHStaticConstString(completionBlockShouldBeginEditing);
SHStaticConstString(completionBlockDidBeginEditing);
SHStaticConstString(completionBlockShouldEndEditing);
SHStaticConstString(completionBlockDidEndEditing);
SHStaticConstString(completionBlockShouldChangeCharactersInRangeWithReplacementString);
SHStaticConstString(completionBlockShouldClear);
SHStaticConstString(completionBlockShouldReturn);


@interface SHTextFieldBlocksManager : NSObject
<UITextFieldDelegate>
@property(nonatomic,strong) NSMapTable     * mapBlocks;

+(void)setMapTable:(NSMapTable *)theMapTable forTextField:(UITextField *)theTextField;
+(NSMapTable *)mapTableForTextField:(UITextField *)theTextField;
+(instancetype)sharedManager;
-(void)SH_memoryDebugger;
-(NSMapTable *)mapTableForTextField:(UITextField *)theTextField;
@end
@implementation SHTextFieldBlocksManager

#pragma mark - Init & Dealloc
-(instancetype)init {
  self = [super init];
  if (self) {
    self.mapBlocks            = [NSMapTable weakToStrongObjectsMapTable];
//    [self SH_memoryDebugger];
  }
  
  return self;
}
+(instancetype)sharedManager {
  static SHTextFieldBlocksManager *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[SHTextFieldBlocksManager alloc] init];
    
  });
  
  return _sharedInstance;
  
}

#pragma mark - Debugger
-(void)SH_memoryDebugger {
  __weak typeof(self) weakSelf = self;
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    NSLog(@"MAP %@",weakSelf.mapBlocks);
    [weakSelf SH_memoryDebugger];
  });
}

#pragma mark - Setter
+(void)setMapTable:(NSMapTable *)theMapTable forTextField:(UITextField *)theTextField {
  [[[SHTextFieldBlocksManager sharedManager] mapBlocks] setObject:theMapTable
                                                           forKey:theTextField];
}

#pragma mark - Getter
+(NSMapTable *)mapTableForTextField:(UITextField *)theTextField {
  return [[[SHTextFieldBlocksManager sharedManager] mapBlocks] objectForKey:theTextField];
}

-(NSMapTable *)mapTableForTextField:(UITextField *)theTextField {
  return [[[SHTextFieldBlocksManager sharedManager] mapBlocks] objectForKey:theTextField];
}

#pragma mark - <UITextFieldDelegate>
// return NO to disallow editing.
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  BOOL textFieldShouldBeginEditing = YES;
  SHTextFieldPredicateBlock block = [[self mapTableForTextField:textField]
                                     objectForKey:completionBlockShouldBeginEditing];
  if(block) textFieldShouldBeginEditing = block(textField);
  return textFieldShouldBeginEditing;
}

// became first responder
-(void)textFieldDidBeginEditing:(UITextField *)textField {
  SHTextFieldBlock block = [[self mapTableForTextField:textField]
                            objectForKey:completionBlockDidBeginEditing];
  if(block) block(textField);
  
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  BOOL textFieldShouldEndEditing = YES;
  SHTextFieldPredicateBlock block = [[self mapTableForTextField:textField]
                                     objectForKey:completionBlockShouldEndEditing];
  if(block) textFieldShouldEndEditing = block(textField);
  return textFieldShouldEndEditing;

}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
-(void)textFieldDidEndEditing:(UITextField *)textField {
  SHTextFieldBlock block = [[self mapTableForTextField:textField]
                            objectForKey:completionBlockDidEndEditing];
  if(block) block(textField);

}

// return NO to not change text
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  BOOL shouldChangeCharactersInRange = YES;
  SHTextFieldRangeReplacementBlock block = [[self mapTableForTextField:textField]
                                     objectForKey:completionBlockShouldChangeCharactersInRangeWithReplacementString];
  if(block) shouldChangeCharactersInRange = block(textField,range,string);
  return shouldChangeCharactersInRange;

}


// called when clear button pressed. return NO to ignore (no notifications)
-(BOOL)textFieldShouldClear:(UITextField *)textField {
  BOOL textFieldShouldClear = YES;
  SHTextFieldPredicateBlock block = [[self mapTableForTextField:textField]
                                     objectForKey:completionBlockShouldClear];
  if(block) textFieldShouldClear = block(textField);
  return textFieldShouldClear;

}

// called when 'return' key pressed. return NO to ignore.
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  BOOL textFieldShouldReturn = YES;
  SHTextFieldPredicateBlock block = [[self mapTableForTextField:textField]
                                     objectForKey:completionBlockShouldReturn];
  if(block) textFieldShouldReturn = block(textField);
  return textFieldShouldReturn;

}

@end



@interface UITextField (Private)
@property(nonatomic,readonly) NSMapTable * mapBlocks;
-(void)setBlock:(id)theBlock forKey:(NSString *)theKey;
@end



@implementation UITextField (SHTextFieldBlocks)

#pragma mark - Setters

-(void)completionSetShouldBeginEditingBlock:(SHTextFieldPredicateBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockShouldBeginEditing];
}

-(void)completionSetDidBeginEditingBlock:(SHTextFieldBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockDidBeginEditing];

}

-(void)completionSetShouldEndEditingBlock:(SHTextFieldPredicateBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockShouldEndEditing];

}

-(void)completionSetDidEndEditingBlock:(SHTextFieldBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockDidEndEditing];
}

-(void)completionSetShouldChangeCharactersInRangeWithReplacementStringBlock:(SHTextFieldRangeReplacementBlock)theBlock {
  [self setBlock:theBlock
          forKey:completionBlockShouldChangeCharactersInRangeWithReplacementString];

}

-(void)completionSetShouldClearBlock:(SHTextFieldPredicateBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockShouldClear];

}

-(void)completionSetShouldReturnBlock:(SHTextFieldPredicateBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockShouldReturn];

}


#pragma mark - Getters

-(SHTextFieldPredicateBlock)completionBlockShouldBeginEditing {
  return [self.mapBlocks objectForKey:completionBlockShouldBeginEditing];
}

-(SHTextFieldBlock)completionBlockDidBeginEditing {
  return [self.mapBlocks objectForKey:completionBlockDidBeginEditing];
}

-(SHTextFieldPredicateBlock)completionBlockShouldEndEditing {
  return [self.mapBlocks objectForKey:completionBlockShouldEndEditing];
}

-(SHTextFieldBlock)completionBlockDidEndEditing {
  return [self.mapBlocks objectForKey:completionBlockDidEndEditing];
}

-(SHTextFieldRangeReplacementBlock)completionBlockShouldChangeCharactersInRangeWithReplacementString {
  return [self.mapBlocks objectForKey:completionBlockShouldChangeCharactersInRangeWithReplacementString];
}

-(SHTextFieldPredicateBlock)completionBlockShouldClear {
  return [self.mapBlocks objectForKey:completionBlockShouldClear];
}

-(SHTextFieldPredicateBlock)completionBlockShouldReturn {
  return [self.mapBlocks objectForKey:completionBlockShouldReturn];
}

#pragma mark - Private

#pragma mark - Properties
#pragma mark - setters
-(void)setBlock:(id)theBlock forKey:(NSString *)theKey {
  NSParameterAssert(theKey);
  if(theBlock) [self.mapBlocks setObject:theBlock forKey:theKey];
  else         [self.mapBlocks removeObjectForKey:theKey];
}

#pragma mark - Getter
-(NSMapTable *)mapBlocks {
  self.delegate = [SHTextFieldBlocksManager sharedManager];
  NSMapTable * mapTable = [SHTextFieldBlocksManager mapTableForTextField:self];
  if(mapTable == nil) mapTable = [NSMapTable strongToStrongObjectsMapTable];
  [SHTextFieldBlocksManager setMapTable:mapTable forTextField:self];
  return mapTable;
  
}

@end

