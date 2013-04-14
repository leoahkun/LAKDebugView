//
//  LAKMovableView.h
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

#import <Foundation/Foundation.h>

@class LAKMovableView;

@protocol LAKMovableViewDelegate <NSObject>
-(void) lakMovableView:(LAKMovableView*) movableView tappedAtPoint:(CGPoint) point;
-(void) lakMovableView:(LAKMovableView*) movableView movedToPoint:(CGPoint) point withVelocity:(CGPoint) velocity;
-(void) lakMovableView:(LAKMovableView*) movableView transformed:(CGFloat) transform toPoint:(CGPoint) point withVelocity:(CGPoint) velocity;

@end

@interface LAKMovableView : UIView <UIGestureRecognizerDelegate>
{
}

@property(nonatomic, weak) id <NSObject, LAKMovableViewDelegate> delegate;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property(nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property(assign) CGFloat lastScale;
@property(assign) CGFloat lastRotation;

@property(assign) CGPoint firstPoint;
@property(assign) CGPoint lastPoint;

-(void) moveView:(LAKMovableView*) lakMovableView withSender:(id) sender withTranslated:(CGPoint) translatedPoint newX:(CGFloat) newX newY:(CGFloat) newY;

@end
