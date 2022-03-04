//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This will generate a projectbox for the Colorlight 5A-75B board
//
//  Version 1.0 (13-02-2022)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------

pcbLength=0;
pcbWidth=0;
holeX=0;
holeY1=0;
holeY2=0;
include <./library/YAPPgenerator_v13.scad>

inch = 25.4;
function i(m) = m*25.4;


// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/


//-- which half do you want to print?
printBaseShell    = true;
printLidShell     = true;

//-- Edit these parameters for your own board dimensions
wallThickness       = 1.2;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.7;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWall_heigth) - (standoff_heigth+pcbThickness)
//--      (6.2 + 4.5) - (3.5 + 1.5) ==> 5.7
baseWallHeight    = 6.2;
lidWallHeight     = 4.5;

// https://www.ledcontrollercard.com/media/wysiwyg/ColorLight/5A-75B%20Receiving%20Card.pdf
//-- pcb dimensions
pcbLength         = 143.64; // i(5.6496);
pcbWidth          = 91.69; // i(3.6);
pcbThickness      = 2.0;
                            
//-- padding between pcb and inside wall
paddingFront      = 2;
paddingBack       = 2;
paddingRight      = 2;
paddingLeft       = 2;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight       = 3.5;
ridgeSlack        = 0.1;
roundRadius       = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight    = 3.5;
pinDiameter       = 2.8;
pinHoleSlack      = 0.1;
standoffDiameter  = 4;


//-- D E B U G ----------------------------
showSideBySide    = true;     //-> true
onLidGap          = 5;
shiftLid          = 1;
hideLidWalls      = false;    //-> false
colorLid          = "yellow";   
hideBaseWalls     = false;    //-> false
colorBase         = "white";
showPCB           = false;    //-> false
showMarkers       = false;    //-> false
inspectX          = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY          = 0;  //-> 0=none (>0 from front, <0 from back)
//-- D E B U G ----------------------------


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
holeDistance = 60.33; // i(2.375)
holeX = (pcbLength - 135.26) / 2;
holeY1 = (pcbWidth - 81.28) / 2;
holeY2 = (pcbWidth - 60.33) / 2;
pcbStands = [
                 [            holeX, pcbWidth - holeY2, yappBoth, yappPin]         // back-left
               , [            holeX,            holeY2, yappBoth, yappPin] // back-right
               , [pcbLength - holeX, pcbWidth - holeY1, yappBoth, yappPin]         // back-left
               , [pcbLength - holeX,            holeY1, yappBoth, yappPin] // back-right
             ];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLid =  [
                 [i(0.375+0*1.075), i(0.26), i(2*0.1), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), 25]
               , [i(0.375+1*1.075), i(0.26), i(2*0.1), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), 25]
               , [i(0.375+2*1.075), i(0.26), i(2*0.1), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), 25]
               , [i(0.375+3*1.075), i(0.26), i(2*0.1), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), 25]
               , [i(0.375+0*1.075), pcbWidth-i(0.26+0.1), i(0.2), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), -25]
               , [i(0.375+1*1.075), pcbWidth-i(0.26+0.1), i(0.2), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), -25]
               , [i(0.375+2*1.075), pcbWidth-i(0.26+0.1), i(0.2), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), -25]
               , [i(0.375+3*1.075), pcbWidth-i(0.26+0.1), i(0.2), i(0.8), yappRectangle, yappOffset, i(0.05), i(0.05), -25]
               //, [0, 31.5-1, 12.2+2, 11, yappRectangle]       // USB (right)
               //, [0, 3.5-1, 12, 13.5, yappRectangle]          // Power Jack
               //, [29-1, 12.5-1, 8.5+2, 35+2,  yappRectangle]  // ATmega328
               //, [17.2-1, 49.5-1, 5, 47.4+2,  yappRectangle]  // right headers
               //, [26.5-1, 1-1, 5, 38+2,  yappRectangle]       // left headers
               //, [65.5, 28.5, 8.0, 5.5,  yappRectangle, yappCenter]    // ICSP1
               //, [18.0, 45.5, 6.5, 8.0,  yappRectangle, yappCenter]    // ICSP2
               //, [6, 49, 8, 0, yappCircle]                  // reset button
//-- if space between pcb and LidPlane > 5.5 we do'n need holes for the elco's --
//             , [18.0, 8.6, 7.2, 0, yappCircle]            // elco1
//             , [26.0, 8.6, 7.2, 0, yappCircle]            // elco2
//             , [21.5, 8.6, 7.2, 7, yappRectangle, yappCenter]        // connect elco's
               , [28.2, 35.2, 5, 3.5, yappRectangle, yappCenter]       // TX/RX leds
               , [28.2, 42.5, 3, 3.5, yappRectangle, yappCenter]       // led13
               , [58.5, 37, 3, 3.5, yappRectangle, yappCenter]         // ON led
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBase =   [
                    [30, pcbWidth/2, 25, 2, yappRectangle, yappCenter]
                  , [35, pcbWidth/2, 25, 2, yappRectangle, yappCenter]
                  , [40, pcbWidth/2, 25, 2, yappRectangle, yappCenter]
                  , [45, pcbWidth/2, 25, 2, yappRectangle, yappCenter]
                  , [50, pcbWidth/2, 25, 2, yappRectangle, yappCenter]
                  , [55, pcbWidth/2, 25, 2, yappRectangle, yappCenter]
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBack = [
                 [31.5-1, -1, 12.2+2, 12, yappRectangle]  // USB
               , [3.5-1,  -1, 12,     11, yappRectangle]  // Power Jack
              ];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =     [
                    [10, 5, yappLeft, yappRight, yappSymmetric]
                ];

//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane = [
                [5,  28,   0, "lid", "Arial:style=bold", 5, "Arduino UNO" ]
              , [57, 33,  90, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
              , [35, 36,   0, "lid", "Liberation Mono:style=bold", 3, "RX" ]
              , [35, 40.5, 0, "lid", "Liberation Mono:style=bold", 3, "TX" ]
              , [35, 45.6, 0, "lid", "Liberation Mono:style=bold", 3, "13" ]
              ];


YAPPgenerate();