<!---
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--->

# G05 Open Source

_Created with Ramses Composer Version 0.13.1_

#
## Overview

This project contains a visualisation of the BMW G05 as an interactive 3D car model. It is intended as a showcase to demonstrate the capabilities of the [Ramses Toolchain](http://www.ramses3d.org) with a fairly complex and realistic example.

To view it, start [Ramses Composer](https://github.com/bmwcarit/ramses-composer/blob/main/README.md) and load *G05_main.rca*

#
## Features

Here is a short overview over the currently implemented functions.

For an extended documentation on how to control the scene and the detailed meaning of its parameters, see the documentation in the _interface()_ function of the [SceneControls script](./scripts/SceneControls.lua).

_(All functions are currently implemented without animations.)_

### Changing Car Paint

* There are 7 different paints with different surface attributes and colors which can be applied to the model
* To change the car paint, use the numeric _CarPaint_ID_ property

### Changing Camera Perspective

* There are 6 different, pre-defined camera perspectives for viewing the car
* To change the camera perspective, use the numeric _CameraPerspective_ID_ property

### Opening / Closing the Doors

* All doors can be opened or closed individually
* To set the door opening angles, use these properties:
  * *Door_F_L_OpeningValue* (front left)
  * *Door_F_R_OpeningValue* (front right)
  * *Door_B_L_OpeningValue* (rear left)
  * *Door_B_R_OpeningValue* (rear right)
* The door, for values of its respective property, is closed at 0.0 and fully open at 1.0.  
For values in between 0 and 1, the door angle is interpolated proportionally to the value (e.g. 0.5 is half-open)

### Opening / Closing the Tailgate

* Analogous to the doors, the tailgate can also be opened or closed
* To set the tailgate opening angle, use the _Tailgate_OpeningValue_ property
* The tailgate is closed at 0.0 and fully open at 1.0.  
For values in between 0 and 1, the tailgate angle is interpolated proportionally to the value (e.g. 0.5 is half-open) 

#
## Dependencies

This project uses external references extensively (see [the official documentation on external references](https://github.com/bmwcarit/ramses-composer-docs/tree/master/advanced/external_references)).  
It contains external references to the following reusable projects (make sure they remain in the same relative paths):
* [CameraCrane](_shared/CameraCrane)
* [Environment](_shared/Environment)
* [MatLib](_shared/MatLib)

#
## Rendering Tip

By default, the _Ramses Preview_ window in Ramses Composer shows you the unvarnished truth about every pixel. In order to get an impression of what the car would look like in a target environment with antialiasing enabled, switch the drop down box above the render view from _Nearest filtering_ to _Linear filtering_

#
## Disclaimer

The G05 OSS is based on a PoC project. Thus, it was created with limited time, resources, and manpower. We know that the project is not perfect and would likely look differently after a few rounds of optimization.

However, we still believe that the G05 is a worthwile demo project for the Ramses Composer, as it displays a great deal of features used, has a fairly complex and quite realistic setup.

Over time, we want to maintain and improve the demo and enrich it with new and upcoming features of Ramses, so stay tuned for that.

#
## License

This work is licensed under the Creative Commons Attribution 4.0 International License.
See [license file](LICENSE.txt) for details.

