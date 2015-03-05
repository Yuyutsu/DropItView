//
//  ViewController.m
//  dropit
//
//  Created by amol on 06/03/15.
//  Copyright (c) 2015 amolchavan. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehavior *dropitBehavior;
@end

@implementation ViewController

static const CGSize DROP_SIZE = { 40, 40 };

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_gameView];
        self.animator.delegate = self;
    }
    return _animator;
}

- (DropitBehavior *)dropitBehavior{
    if (!_dropitBehavior) {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self drop];
    
}

- (void)drop{
    
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView  *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    [self.dropitBehavior addItem:dropView];
 }

- (UIColor *)randomColor{
    switch (arc4random()%5) {
        case 0: return [UIColor blueColor];
        case 1: return [UIColor yellowColor];
        case 2: return [UIColor redColor];
        case 3: return [UIColor greenColor];
        case 4: return [UIColor purpleColor];
        default:
            break;
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    [self removeCompletedRows];
}

- (BOOL)removeCompletedRows{
    
    NSMutableArray *dropToRemove = [NSMutableArray new];
    for (CGFloat y = self.gameView.bounds.size.height-DROP_SIZE.height/2; y>0; y-=DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [NSMutableArray new];
        for (CGFloat x = DROP_SIZE.width/2; x<= self.gameView.bounds.size.width-DROP_SIZE.width/2; x+=DROP_SIZE.width) {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) {
            break;
        }
        if (rowIsComplete) {
            [dropToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    if ([dropToRemove count]) {
        for (UIView *drop in dropToRemove) {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropToRemove];
    }
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropToRemove{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *drops in dropToRemove) {
            int x = (arc4random()%(int)self.gameView.bounds.size.width*5) - (int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drops.center = CGPointMake(x, -y);
            
        }
    } completion:^(BOOL finished) {
        [dropToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

@end
