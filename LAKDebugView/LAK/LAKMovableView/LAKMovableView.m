//
//  LAKMovableView.m
//  LAKMovableViewProject
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

#import "LAKMovableView.h"
#import <QuartzCore/QuartzCore.h>
#import "LAKCGUtils.h"

@implementation LAKMovableView
@synthesize delegate = _delegate;
@synthesize pinchRecognizer = _pinchRecognizer;
@synthesize rotationRecognizer = _rotationRecognizer;
@synthesize panRecognizer = _panRecognizer;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize lastScale = _lastScale;
@synthesize lastRotation = _lastRotation;
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
		[_pinchRecognizer setDelegate:self];
		[self addGestureRecognizer:_pinchRecognizer];
		
		_rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
		[_rotationRecognizer setDelegate:self];
		[self addGestureRecognizer:_rotationRecognizer];
		
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
		[_panRecognizer setMinimumNumberOfTouches:1];
		[_panRecognizer setMaximumNumberOfTouches:1]; //TODO, use center of 2 touches as center
		[_panRecognizer setDelegate:self];
		[self addGestureRecognizer:_panRecognizer];
		
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[_tapRecognizer setNumberOfTapsRequired:1];
		[_tapRecognizer setDelegate:self];
		[self addGestureRecognizer:_tapRecognizer];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
		[_pinchRecognizer setDelegate:self];
		[self addGestureRecognizer:_pinchRecognizer];
		
		_rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
		[_rotationRecognizer setDelegate:self];
		[self addGestureRecognizer:_rotationRecognizer];
		
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
		[_panRecognizer setMinimumNumberOfTouches:1];
		[_panRecognizer setMaximumNumberOfTouches:1]; //TODO, use center of 2 touches as center
		[_panRecognizer setDelegate:self];
		[self addGestureRecognizer:_panRecognizer];
		
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[_tapRecognizer setNumberOfTapsRequired:1];
		[_tapRecognizer setDelegate:self];
		[self addGestureRecognizer:_tapRecognizer];		
    }
    return self;
}

-(void)pinch:(id)sender {
	if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		return;
	}
	
	LAKMovableView *movableView = (LAKMovableView*) [(UIPinchGestureRecognizer*)sender view];
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	CGPoint p1;
	CGPoint p2;
	if ([(UIPinchGestureRecognizer*)sender numberOfTouches] > 1) {
		p1 = [(UIPinchGestureRecognizer*)sender locationOfTouch:0 inView:movableView.superview];
		p2 = [(UIPinchGestureRecognizer*)sender locationOfTouch:1 inView:movableView.superview];
	} else {
		return;
	}
	
	CGFloat addX = p1.x;
	CGFloat addY = p1.y;
	
	if (p2.x < p1.x) {
		addX = p2.x;
	}
	
	if (p2.y < p1.y) {
		addY = p2.y;
	}
	
	CGPoint translatedPoint = CGPointMake(addX+fabs(p1.x-p2.x)/2, addY+fabs(p1.y-p2.y)/2);
	
	CGFloat newX = translatedPoint.x;
	CGFloat newY = translatedPoint.y;
	
	CGPoint velocity = CGPointMake(newX-self.lastPoint.x, newY-self.lastPoint.y);
	
	[self moveView:movableView withSender:sender withTranslated:(CGPoint) translatedPoint newX:(CGFloat) newX newY:(CGFloat) newY];
	if ([_delegate respondsToSelector:@selector(lakMovableView:movedToPoint:withVelocity:)]) {
		[_delegate lakMovableView:self movedToPoint:CGPointMake(newX,newY) withVelocity:velocity];
	}	
}

-(void)rotate:(id)sender {
	//NSLog(@"See a rotate gesture");
	
	/*if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
	 return;
	 }*/
	
	LAKMovableView *movableView = (LAKMovableView*) [(UIRotationGestureRecognizer*)sender view];
	CGPoint translatedPoint = movableView.center;
	
	CGFloat newX = translatedPoint.x;
	CGFloat newY = translatedPoint.y;
	
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		movableView.lastRotation = 0.0;
		[self moveView:movableView withSender:sender withTranslated:(CGPoint) translatedPoint newX:(CGFloat) newX newY:(CGFloat) newY];
		return;
	}
	[self moveView:movableView withSender:sender withTranslated:(CGPoint) translatedPoint newX:(CGFloat) newX newY:(CGFloat) newY];
	
	CGFloat rotation = 0.0 - (movableView.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
	
	//CGAffineTransform currentTransform = CGAffineTransformIdentity;
	//CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,[(UIRotationGestureRecognizer*)sender rotation]);
	
	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
	
	movableView.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
	
	CGPoint velocity = CGPointMake(newX-self.lastPoint.x, newY-self.lastPoint.y);
	
	CGFloat t = RadiansToDegrees(TransformToRadians(self.transform))+360;
	if ([_delegate respondsToSelector:@selector(lakMovableView:transformed:toPoint:withVelocity:)]) {
		[_delegate lakMovableView:self transformed:t toPoint:CGPointMake(newX, newY) withVelocity:velocity];
	}
}


-(void) moveView:(LAKMovableView*) movableView withSender:(id) sender withTranslated:(CGPoint) translatedPoint newX:(CGFloat) newX newY:(CGFloat) newY {
	[self.superview bringSubviewToFront:movableView];
	
	translatedPoint = CGPointMake(newX, newY);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationDuration:.35];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationComplete:)];
	[[sender view] setCenter: translatedPoint];
	[UIView commitAnimations];
	
	self.lastPoint = CGPointMake(newX, newY);
	
}

-(void) animationComplete:(id) sender {
	
}

-(void)move:(id)sender {
	//NSLog(@"See a move gesture");
	//	scrollView.scrollEnabled = NO;
	LAKMovableView *movableView = (LAKMovableView*) [(UIPanGestureRecognizer*)sender view];
	
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	CGPoint touchedPoint = [(UIPanGestureRecognizer*)sender locationInView:self.superview];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		movableView.firstPoint = CGPointMake([[sender view] center].x-touchedPoint.x,[[sender view] center].y-touchedPoint.y);
	}
	
	CGPoint translatedPoint = CGPointMake(touchedPoint.x+movableView.firstPoint.x, touchedPoint.y+movableView.firstPoint.y);
	
	CGFloat newX = touchedPoint.x+movableView.firstPoint.x;
	CGFloat newY = touchedPoint.y+movableView.firstPoint.y;
	//	CGPoint newTranslatedPoint;
	
	[self moveView:movableView withSender:sender withTranslated:(CGPoint) translatedPoint newX:(CGFloat) newX newY:(CGFloat) newY];
	//	scrollView.scrollEnabled = YES;
	
	UIPanGestureRecognizer *pRecognizer = (UIPanGestureRecognizer*)sender;
	CGPoint velocity = [pRecognizer velocityInView:self.superview];
	
	if ([_delegate respondsToSelector:@selector(lakMovableView:movedToPoint:withVelocity:)]) {
		[_delegate lakMovableView:self movedToPoint:CGPointMake(newX, newY) withVelocity:velocity];
	}
}

-(void)tapped:(id)sender {
	//	//NSLog(@"See a tap gesture");
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	if ([_delegate respondsToSelector:@selector(lakMovableView:tappedAtPoint:)]) {
		[_delegate lakMovableView:self tappedAtPoint:self.center];
	}
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])  {
		return NO;
	}
	return YES;
	//return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
