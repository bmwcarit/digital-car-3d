<!---
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--->


#
# BMW X5 2018 (G05)

_Created with [Ramses Composer Version 0.13.1](https://github.com/bmwcarit/ramses-composer)_

#
# How to open the project?

## Download the Ramses Composer

Direct links:

* [Windows](https://github.com/COVESA/ramses-composer/releases/download/v0.13.1/RamsesComposerWindows_v0.13.1.zip)
* [Linux](https://github.com/COVESA/ramses-composer/releases/download/v0.13.1/RamsesComposerLinux_v0.13.1.zip)

## Start the Ramses Composer

Go to bin/RelWithDebInfo, start RamsesComposer.exe on Windows, RamsesComposer.sh on Linux.

## Open the car project

Open [the G05 project file](./G05_main.rca) via File->Open.

#
# Change settings and experiment

#
## Open the control script

Uncollapse the `root` node in the `Scene Graph` tab and select the `SceneControls` script:

![Interface](./docs/interface.png)

In the `Property Browser` tab you will see a list of inputs you can set/modify:

![Properties](./docs/properties.png)

#
## Modify some of the car features

### Changing Car Paint

* To change the car paint, use the numeric _CarPaint_ID_ property
* There are 7 different paints with different surface attributes and colors which can be applied to the model

### Changing Camera Perspective

* To change the camera perspective, use the numeric _CameraPerspective_ID_ property
* There are 6 different, pre-defined camera perspectives for viewing the car

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

* To set the tailgate opening angle, use the _Tailgate_OpeningValue_ property
* Analogous to the doors, the tailgate can also be opened or closed
* The tailgate is closed at 0.0 and fully open at 1.0.
For values in between 0 and 1, the tailgate angle is interpolated proportionally to the value (e.g. 0.5 is half-open) 

You can find more detailed documentation of the input values by looking into [the control script](./scripts/SceneControls.lua)
which you can open from the pencil button right next to the `URI` field in the Property Browser.

#
## What to do next

To learn how to modify the scene in more complex ways, or simply understand how it works,
please refer to the [Ramses Composer tutorials](https://github.com/bmwcarit/ramses-composer-docs) which explain the various features of the
Composer with interactive examples.

#
## Rendering Tip

By default, the _Ramses Preview_ window in Ramses Composer shows you the unvarnished truth about every pixel. In order to get an impression of what the car would look like in a target environment with antialiasing enabled, switch the drop down box above the render view from _Nearest filtering_ to _Linear filtering_

#
## Dependencies

This project uses external references extensively (see [the official documentation on external references](https://github.com/bmwcarit/ramses-composer-docs/tree/master/advanced/external_references)).  
It contains external references to the following reusable projects (make sure they remain in the same relative paths):
* [CameraCrane](_shared/CameraCrane)
* [Environment](_shared/Environment)
* [MatLib](_shared/MatLib)

#
## Disclaimer

The G05 OSS is based on a PoC project. Thus, it was created with limited time, resources, and manpower. We know that the project is not perfect and would likely look differently after a few rounds of optimization.

However, we still believe that the G05 is a worthwile demo project for the Ramses Composer, as it displays a great deal of features used, has a fairly complex and quite realistic setup.

Over time, we want to maintain and improve the demo and enrich it with new and upcoming features of Ramses, so stay tuned for that.

#
## License

This work is licensed under the Creative Commons Attribution 4.0 International License.
See [license file](LICENSE.txt) for details.

