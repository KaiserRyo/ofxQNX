#ifndef TESTAPP_H_
#define TESTAPP_H_

#include "ofMain.h"
#include "ofxQNX.h"

typedef struct {

	float 	x;
	float 	y;
	bool 	bBeingDragged;
	bool 	bOver;
	float 	radius;
	
}draggableVertex;


class testApp : public ofxQNXApp {
	
	public:
		
		void setup();
		void update();
		void draw();

		void keyPressed  (int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);		
		
		int nCurveVertexes;
		draggableVertex curveVertices[7];
		draggableVertex bezierVertices[4];
};

#endif /* TESTAPP_H_ */
