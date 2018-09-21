#import "BuildingsExample.h"

#import <SceneKit/SceneKit.h>
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
#import <GLKit/GLKit.h>

@import Mapbox;

NSString *const MBXExampleBuildings = @"BuildingsExample";

@interface MGLMapView (FancyAdditions)

@property (nonatomic) GLKView *glView;

@end

@interface FancyBuildingStyleLayer: MGLOpenGLStyleLayer

@property (nonatomic) SCNRenderer *renderer;
@property (nonatomic) SCNNode *cameraNode;

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
    cameraNode.position = SCNVector3Make(-3, 3, 3);
    self.cameraNode = cameraNode;
    
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeOmni;
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = light;
    lightNode.position = SCNVector3Make(1.5, 1.5, 1.5);
    
    SCNBox *cubeGeometry = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
    SCNNode *cubeNode = [SCNNode nodeWithGeometry:cubeGeometry];
    
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:cubeNode];
    constraint.gimbalLockEnabled = YES;
    if (@available(iOS 11.0, *)) {
//        constraint.targetOffset = SCNVector3Make(0, 0, 3);
    } else {
        // Fallback on earlier versions
    }
    cameraNode.constraints = @[constraint];
    
    [scene.rootNode addChildNode:lightNode];
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:cubeNode];
    
//    // https://3dmr.eu/model/4
//    SCNNode *towerContainerNode = [SCNNode node];
//    NSURL *towerURL = [[NSBundle mainBundle] URLForResource:@"eiffel" withExtension:@"obj"];
//    MDLAsset *asset = [[MDLAsset alloc] initWithURL:towerURL];
//    SCNScene *towerScene = [SCNScene sceneWithMDLAsset:asset];
//    SCNNode *towerNode = towerScene.rootNode.childNodes.firstObject;
//    [towerContainerNode addChildNode:towerNode];
//    [scene.rootNode addChildNode:towerContainerNode];
    
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

- (void)drawInMapView:(MGLMapView *)mapView withContext:(MGLStyleLayerDrawingContext)context {
    [super drawInMapView:mapView withContext:context];
    
    if (@available(iOS 11.0, *)) {
//        self.cameraNode.camera.fieldOfView = context.fieldOfView;
//        self.cameraNode.camera.projectionTransform = MGLSCNMatrix4FromMGLMatrix4(context.projectionMatrix);
    } else {
        // Fallback on earlier versions
    }
    [self.renderer renderAtTime:0];
}

- (void)willMoveFromMapView:(MGLMapView *)mapView {
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
