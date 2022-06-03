--[[
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]--


-- Initializing (script-global) functions and variables
function init()
    -- Global variables
    GLOBAL.paintSettings =
    {
        Name = Type:String(), -- for debugging
        BaseColor = Type:Vec4f(),
        MetallicRoughness = Type:Vec2f(),
        SheenRoughness = Type:Float(),
        SheenScale = Type:Float(),
        NormalScale = Type:Float(),
    }
end


-- Define Input and Output parameters
function interface(IN,OUT)
    -- Input Parameters
    IN.CarPaint = GLOBAL.paintSettings -- Settings of the currently selected Car Paint (values from 'SceneControls' script)

    IN.Door_F_L_OpeningValue = Type:Float() -- Open/close door (front left) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)
    IN.Door_F_R_OpeningValue = Type:Float() -- Open/close door (front right) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)
    IN.Door_B_L_OpeningValue = Type:Float() -- Open/close door (back left) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)
    IN.Door_B_R_OpeningValue = Type:Float() -- Open/close door (back right) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)

    IN.Tailgate_OpeningValue = Type:Float() -- Open/close tailgate (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)


    -- Output Parameters (Linked to 'Logic_Car' script)
    OUT.CarPaint = GLOBAL.paintSettings

    OUT.Door_F_L_OpeningValue = Type:Float()
    OUT.Door_F_R_OpeningValue = Type:Float()
    OUT.Door_B_L_OpeningValue = Type:Float()
    OUT.Door_B_R_OpeningValue = Type:Float()

    OUT.Tailgate_OpeningValue = Type:Float()
end


-- Passing through the Input parameters to the Output parameters
function run(IN,OUT)
    OUT.Door_F_L_OpeningValue = IN.Door_F_L_OpeningValue
    OUT.Door_F_R_OpeningValue = IN.Door_F_R_OpeningValue
    OUT.Door_B_L_OpeningValue = IN.Door_B_L_OpeningValue
    OUT.Door_B_R_OpeningValue = IN.Door_B_R_OpeningValue
    OUT.Tailgate_OpeningValue = IN.Tailgate_OpeningValue

    OUT.CarPaint = IN.CarPaint
end
