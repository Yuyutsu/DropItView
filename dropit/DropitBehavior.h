//
//  DropitBehavior.h
//  dropit
//
//  Created by amol on 06/03/15.
//  Copyright (c) 2015 amolchavan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;

@end
