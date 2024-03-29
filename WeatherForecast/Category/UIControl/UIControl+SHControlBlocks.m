//
//  UIControl+SHControlEventBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "UIControl+SHControlBlocks.h"



@interface SHControlBlocksManager : NSObject
@property(nonatomic,strong) NSMapTable     * mapBlocks;
+(instancetype)sharedManager;
-(void)SH_memoryDebugger;
@end
@implementation SHControlBlocksManager

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
  static SHControlBlocksManager *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[SHControlBlocksManager alloc] init];
    
  });
  
  return _sharedInstance;
  
}

#pragma mark - Debugger
-(void)SH_memoryDebugger {
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    NSLog(@"MAP %@",self.mapBlocks);
    [self SH_memoryDebugger];
  });
}
@end

@interface SHControl : NSObject
-(instancetype)initWithControlBlockForControlEvents:(UIControlEvents)controlEvents
                            withEventBlock:(SHControlEventBlock)theBlock;

@property(nonatomic,assign) UIControlEvents     controlEvents;
@property(nonatomic,strong) NSHashTable       * tableBlocks;
@end

@implementation SHControl

-(instancetype)initWithControlBlockForControlEvents:(UIControlEvents)controlEvents
                           withEventBlock:(SHControlEventBlock)theBlock {
  self = [super init];
	if (self) {
    self.tableBlocks   = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    [self.tableBlocks addObject:theBlock];
    self.controlEvents = controlEvents;
	}
	return self;
}



-(void)performAction:(id)sender {
  NSSet * immutableTableBlocks = self.tableBlocks.setRepresentation;
	for (SHControlEventBlock block in immutableTableBlocks) {
    block(sender);
  }
}

@end

@interface UIControl ()
@property(nonatomic,readonly) NSHashTable * tableControls;
@end

@interface UIControl (Private)
-(SHControl *)shControlForControlEvents:(UIControlEvents)theControlEvents;
@end



@implementation UIControl (SHControlBlocks)

#pragma mark - Add block
-(void)completionAddControlEvents:(UIControlEvents)controlEvents
                 withBlock:(SHControlEventBlock)theBlock {


  NSAssert(theBlock, @"theBlock is required");
  SHControlEventBlock block = [theBlock copy];
  SHControl * control = [self shControlForControlEvents:controlEvents];
  if(control) {
    [control.tableBlocks addObject:block];
  }
  else {
    control = [[SHControl alloc]
               initWithControlBlockForControlEvents:controlEvents
               withEventBlock:block];
  }
  [self addTarget:control action:@selector(performAction:) forControlEvents:controlEvents];
  [self.tableControls addObject:control];

}

-(void)completionAddControlEventTouchUpInsideWithBlock:(SHControlEventBlock)theBlock {
  NSAssert(theBlock, @"theBlock is required");
  [self completionAddControlEvents:UIControlEventTouchUpInside withBlock:theBlock];
}



#pragma mark - Remove block
-(void)completionRemoveControlEventTouchUpInside {
  [self completionRemoveBlocksForControlEvents:UIControlEventTouchUpInside];
}

-(void)completionRemoveBlocksForControlEvents:(UIControlEvents)controlEvents {
  SHControl * control = [self shControlForControlEvents:controlEvents];
  if(control) {
    [self removeTarget:control action:NULL forControlEvents:controlEvents];
    [self.tableControls removeObject:control];
  }
}



-(void)completionRemoveControlEventsForBlock:(SHControlEventBlock)theBlock {
  NSSet * immutableTableControls = self.tableControls.setRepresentation;
  for (SHControl * control in immutableTableControls){
    if([control.tableBlocks containsObject:theBlock])
      [control.tableBlocks removeObject:theBlock];
    if(control.tableBlocks.count == 0)
      [self completionRemoveBlocksForControlEvents:control.controlEvents];
  }
}

-(void)completionRemoveAllControlEventsBlocks {
  self.tableControls = nil;
}


#pragma mark - Helpers
-(NSSet *)completionBlocksForControlEvents:(UIControlEvents)theControlEvents {
  SHControl * control = [self shControlForControlEvents:theControlEvents];
  NSSet * setOfBlocks = control.tableBlocks.setRepresentation;
  if(setOfBlocks == nil) setOfBlocks = [NSSet set];
  return setOfBlocks;
}

-(NSSet *)completionControlEventsForBlock:(SHControlEventBlock)theBlock {
  NSAssert(theBlock, @"theBlock is required");
  NSMutableSet * setOfControlEvents = [NSMutableSet set];
  for (SHControl * control in self.tableControls) {
    if([control.tableBlocks containsObject:theBlock])
      [setOfControlEvents addObject:@(control.controlEvents)];
  }
  return setOfControlEvents.copy;
}



#pragma mark -
#pragma mark Properties



#pragma mark - Getters
-(NSDictionary *)completionControlBlocks {
  NSMutableDictionary * controlBlocks = @{}.mutableCopy;
  for (SHControl * control in self.tableControls) {
    controlBlocks[@(control.controlEvents)] = control.tableBlocks.setRepresentation;
  }
  return controlBlocks.copy;
}

-(BOOL)SH_isTouchUpInsideEnabled {
  SHControl * control = [self shControlForControlEvents:UIControlEventTouchUpInside];
  return control.tableBlocks.count > 0;
}


#pragma mark - Privates

-(SHControl *)shControlForControlEvents:(UIControlEvents)theControlEvents {
  SHControl * shControl = nil;
  for (SHControl * control in self.tableControls)
    if (control.controlEvents == theControlEvents ) {
      shControl = control;
      continue;
    }
  
  return shControl;
}

-(NSHashTable *)tableControls {
  NSHashTable * tableControls =  [[SHControlBlocksManager sharedManager].mapBlocks objectForKey:self];
  if (tableControls == nil){
    tableControls = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    self.tableControls = tableControls;
  }

  return tableControls;
}

-(void)setTableControls:(NSHashTable *)tableControls {
  if(tableControls)
    [[SHControlBlocksManager sharedManager].mapBlocks setObject:tableControls forKey:self];
  else {
    for (SHControl * control in self.tableControls)
      [self removeTarget:control action:NULL forControlEvents:control.controlEvents];
    [[SHControlBlocksManager sharedManager].mapBlocks removeObjectForKey:self];
  }

}


@end

