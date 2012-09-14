/*
 *  MaplyTapDelegate.mm
 *  WhirlyGlobeLib
 *
 *  Created by Steve Gifford on 1/20/12.
 *  Copyright 2011-2012 mousebird consulting
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

#import "MaplyTapDelegate.h"
#import "EAGLView.h"
#import "SceneRendererES1.h"
#import "MaplyView.h"
#import "GlobeMath.h"

using namespace WhirlyKit;

@implementation MaplyTapDelegate

- (id)initWithMapView:(MaplyView *)inView
{
    self = [super init];
    if (self)
    {
        mapView = inView;
    }
    
    return self;
}

+ (MaplyTapDelegate *)tapDelegateForView:(UIView *)view mapView:(MaplyView *)mapView
{
	MaplyTapDelegate *tapDelegate = [[MaplyTapDelegate alloc] initWithMapView:mapView];
	[view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:tapDelegate action:@selector(tapAction:)]];
	return tapDelegate;
}

// We'll let other gestures run
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return TRUE;
}

// Called for a tap
- (void)tapAction:(id)sender
{
	UITapGestureRecognizer *tap = sender;
	WhirlyKitEAGLView  *glView = (WhirlyKitEAGLView  *)tap.view;
	WhirlyKitSceneRendererES1 *sceneRender = glView.renderer;
    CoordSystemDisplayAdapter *coordAdapter = mapView.coordAdapter;
//    WhirlyKit::Scene *scene = sceneRender.scene;
    
    // Just figure out where we tapped
	Point3f hit;
    Eigen::Matrix4f theTransform = [mapView calcModelMatrix];
    CGPoint touchLoc = [tap locationOfTouch:0 inView:tap.view];    
    if ([mapView pointOnPlaneFromScreen:touchLoc transform:&theTransform frameSize:Point2f(sceneRender.framebufferWidth,sceneRender.framebufferHeight) hit:&hit])
    {
		WhirlyGlobeTapMessage *msg = [[WhirlyGlobeTapMessage alloc] init];
        [msg setTouchLoc:touchLoc];
        [msg setView:tap.view];
		[msg setWorldLoc:hit];
        Point3f localPt = coordAdapter->displayToLocal(hit);
		[msg setWhereGeo:coordAdapter->getCoordSystem()->localToGeographic(localPt)];
        msg.heightAboveSurface = hit.z();
		
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:WhirlyGlobeTapMsg object:msg]];
    } else {
        // Not expecting this case
    }
}

@end
