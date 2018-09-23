#import "BuildingsExample.h"

#import <SceneKit/SceneKit.h>
#import <GLKit/GLKit.h>

@import Mapbox;

NSString *const MBXExampleBuildings = @"BuildingsExample";

@interface MGLMapView (FancyForwardDeclarations)

@property (nonatomic) GLKView *glView;

@end

@implementation MGLMapView (FancyAdditions)

- (SCNVector3)mbx_convertCoordinate:(CLLocationCoordinate2D)coordinate toPositionToView:(UIView *)view {
    CGPoint point = [self convertCoordinate:coordinate toPointToView:view];
    return SCNVector3Make(point.x, CGRectGetHeight(view.bounds) - point.y, 0);
}

@end

@interface FancyBuildingStyleLayer: MGLOpenGLStyleLayer

@property (nonatomic) SCNRenderer *renderer;
@property (nonatomic) SCNNode *cameraNode;
@property (nonatomic) SCNNode *lightNode;

@end

@interface BuildingsExample () <MGLMapViewDelegate>

@end

@implementation FancyBuildingStyleLayer

- (void)didMoveToMapView:(MGLMapView *)mapView {
    [super didMoveToMapView:mapView];
    
    SCNScene *scene = [SCNScene scene];
    scene.background.contents = [UIColor clearColor];
    
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
//    cameraNode.position = SCNVector3Make(0, 0, 3);
    self.cameraNode = cameraNode;
    
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeOmni;
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = light;
//    lightNode.position = SCNVector3Make(1.5, 1.5, 1.5);
    self.lightNode = lightNode;
    
//    SCNBox *cubeGeometry = [SCNBox boxWithWidth:20 height:20 length:20 chamferRadius:2];
//    SCNNode *cubeNode = [SCNNode nodeWithGeometry:cubeGeometry];
//    [cubeNode setValue:[NSValue valueWithMGLCoordinate:CLLocationCoordinate2DMake(48.8582602, 2.29449905431968)]
//                forKey:@"coordinate"];
    
//    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:cubeNode];
//    constraint.gimbalLockEnabled = YES;
//    if (@available(iOS 11.0, *)) {
////        constraint.targetOffset = SCNVector3Make(0, 0, 3);
//    } else {
//        // Fallback on earlier versions
//    }
//    cameraNode.constraints = @[constraint];
    
    [scene.rootNode addChildNode:lightNode];
    [scene.rootNode addChildNode:cameraNode];
//    [scene.rootNode addChildNode:cubeNode];
    
    SCNNode *towerContainerNode = [SCNNode node];
    // https://3dmr.eu/model/4
    SCNScene *towerScene = [SCNScene sceneNamed:@"eiffel.obj"];
    // https://commons.wikimedia.org/wiki/File:EiffelTower_fixed.stl
//    SCNScene *towerScene = [SCNScene sceneNamed:@"EiffelTower_fixed.stl"];
    SCNNode *towerNode = towerScene.rootNode.childNodes.firstObject;
    [towerContainerNode addChildNode:towerNode];
    [towerContainerNode setValue:[NSValue valueWithMGLCoordinate:CLLocationCoordinate2DMake(48.8582602, 2.29449905431968)]
                          forKey:@"coordinate"];
    [towerContainerNode setValue:@(45) forKey:@"heading"];
    [scene.rootNode addChildNode:towerContainerNode];
    
//    // https://gist.github.com/andrewharvey/7b61e9bdb4165e8832b7495c2a4f17f7
//    SCNNode *dishContainerNode = [SCNNode node];
//    SCNScene *dishScene = [SCNScene sceneNamed:@"34M_17.dae"];
//    SCNNode *dishNode = dishScene.rootNode;
//
    
    SCNRenderer *renderer = [SCNRenderer rendererWithContext:mapView.glView.context options:nil];
    renderer.scene = scene;
    
    self.renderer = renderer;
}

static SCNMatrix4 MGLSCNMatrix4FromMGLMatrix4(MGLMatrix4 mglMatrix) {
    SCNMatrix4 scnMatrix;
    
    scnMatrix.m11 = mglMatrix.m00;
    scnMatrix.m12 = mglMatrix.m01;
    scnMatrix.m13 = mglMatrix.m02;
    scnMatrix.m14 = mglMatrix.m03;
    
    scnMatrix.m21 = mglMatrix.m10;
    scnMatrix.m22 = mglMatrix.m11;
    scnMatrix.m23 = mglMatrix.m12;
    scnMatrix.m24 = mglMatrix.m13;
    
    scnMatrix.m31 = mglMatrix.m20;
    scnMatrix.m32 = mglMatrix.m21;
    scnMatrix.m33 = mglMatrix.m22;
    scnMatrix.m34 = mglMatrix.m23;
    
    scnMatrix.m41 = mglMatrix.m30;
    scnMatrix.m42 = mglMatrix.m31;
    scnMatrix.m43 = mglMatrix.m32;
    scnMatrix.m44 = mglMatrix.m33;
    
    return scnMatrix;
}

static SCNVector3 UnitPositionFromCoordinate(CLLocationCoordinate2D coordinate) {
    // Derived from https://gist.github.com/springmeyer/871897
    CGFloat extent = 20037508.34;
    
    CGFloat x = coordinate.longitude * extent / 180.0;
    CGFloat y = log(tan((90 + coordinate.latitude) * M_PI / 360.0)) / (M_PI / 180.0);
    y *= extent / 180.0;
    
    return SCNVector3Make((x + extent) / (2 * extent), 1 - ((y + extent) / (2 * extent)), 0);
}

- (void)drawInMapView:(MGLMapView *)mapView withContext:(MGLStyleLayerDrawingContext)context {
    [super drawInMapView:mapView withContext:context];
    
    SCNNode *towerNode = self.renderer.scene.rootNode.childNodes.lastObject;
    
    CLLocationCoordinate2D towerCoordinate = [[towerNode valueForKey:@"coordinate"] MGLCoordinateValue];
    SCNVector3 towerPosition = [mapView mbx_convertCoordinate:towerCoordinate toPositionToView:mapView];
    CLLocationDirection towerHeading = [[towerNode valueForKey:@"heading"] doubleValue];
    SCNMatrix4 towerTransform = SCNMatrix4Identity;
    towerTransform = SCNMatrix4Rotate(towerTransform, MGLRadiansFromDegrees(context.direction + towerHeading), 0, 1, 0);
    towerTransform = SCNMatrix4Rotate(towerTransform, M_PI_2 - context.pitch, 1, 0, 0);
    towerTransform = SCNMatrix4Translate(towerTransform, towerPosition.x, towerPosition.y, 0);
    towerNode.transform = towerTransform;
    
    CLLocationDistance metersPerPoint = [mapView metersPerPointAtLatitude:context.centerCoordinate.latitude];
    CGFloat screenAltitude = mapView.camera.altitude / metersPerPoint;
    
    MGLLight *light = mapView.style.light;
    CGFloat lightIntensity = [light.intensity.constantValue doubleValue];
    self.lightNode.light.intensity = lightIntensity;
    UIColor *lightColor = light.color.constantValue;
    self.lightNode.light.color = lightColor;
    MGLSphericalPosition lightPosition = [light.position.constantValue MGLSphericalPositionValue];
    self.lightNode.position = SCNVector3Make(50, 50, 20);
//    self.lightNode.position = SCNVector3Make(0, screenAltitude * lightPosition.radial, 0);
//    self.lightNode.eulerAngles = SCNVector3Make(M_PI_2 - context.pitch - MGLRadiansFromDegrees(lightPosition.polar), MGLRadiansFromDegrees(context.direction + lightPosition.azimuthal), 0);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, CGRectGetWidth(mapView.bounds),
                                                      0, CGRectGetHeight(mapView.bounds),
                                                      1, screenAltitude + 100);
    self.cameraNode.position = SCNVector3Make(0, 0, screenAltitude);
    self.cameraNode.camera.projectionTransform = SCNMatrix4FromGLKMatrix4(projectionMatrix);
    
    SCNVector3 translation = UnitPositionFromCoordinate(context.centerCoordinate);
    CGFloat scale = 5.41843220338983e-8;
    
    SCNMatrix4 m = MGLSCNMatrix4FromMGLMatrix4(context.projectionMatrix);
    SCNMatrix4 l = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z);
    l = SCNMatrix4Scale(l, scale, scale, scale);
    l = SCNMatrix4Rotate(l, M_PI_2, 1, 0, 0);
    
//    self.cameraNode.camera.projectionTransform = SCNMatrix4Mult(m, l);
    
    if (@available(iOS 11.0, *)) {
//        self.cameraNode.camera.fieldOfView = context.fieldOfView;
//        self.cameraNode.camera.automaticallyAdjustsZRange = YES;
//        self.cameraNode.camera.zNear = 1;
//        self.cameraNode.camera.zFar = 1000;
//        self.cameraNode.camera.projectionTransform = MGLSCNMatrix4FromMGLMatrix4(context.projectionMatrix);
    } else {
        // Fallback on earlier versions
    }
    [self.renderer renderAtTime:0];
}

- (void)willMoveFromMapView:(MGLMapView *)mapView {
    self.renderer = nil;
    
    [super willMoveFromMapView:mapView];
}

@end

@implementation BuildingsExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the map style to Mapbox Light Style version 9. The map's source will be queried later in this example.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURLWithVersion:9]];
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Center the map view on the Eiffel Tower in Paris, France, and set the camera's pitch, heading, and distance.
    mapView.camera = [MGLMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(48.8582602, 2.29449905431968) altitude:600 pitch:60 heading:210];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
    MGLSource *source = [style sourceWithIdentifier:@"composite"];
    MGLFillExtrusionStyleLayer *layer = [[MGLFillExtrusionStyleLayer alloc] initWithIdentifier:@"buildings" source:source];
    layer.sourceLayerIdentifier = @"building";
    
    // Filter out buildings that should not extrude.
    layer.predicate = [NSPredicate predicateWithFormat:@"type == 'building' AND extrude == 'true'"];
    
    // Set the fill extrusion height to the value for the building height attribute.
    layer.fillExtrusionHeight = [NSExpression expressionForKeyPath:@"height"];
    layer.fillExtrusionOpacity = [NSExpression expressionForConstantValue:@0.75];
    layer.fillExtrusionColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    
    // Insert the fill extrusion layer below a POI label layer. If you aren’t sure what the layer is called, you can view the style in Mapbox Studio or iterate over the style’s layers property, printing out each layer’s identifier.
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"poi-scalerank3"];
    [style insertLayer:layer belowLayer:symbolLayer];
    
    FancyBuildingStyleLayer *fancyLayer = [[FancyBuildingStyleLayer alloc] initWithIdentifier:@"fancy"];
    [style insertLayer:fancyLayer aboveLayer:layer];
}

@end
