--[[
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]--


-- Define Input and Output parameters
function interface()
    -- Input Parameters
    IN.CarPaint_ID = INT -- ID of exterior paint (DEFAULT: 1) - all options listed below
    --[[
        1: Pyhtonic Blue
        2: Transanit Blue
        3: Black
        4: Black Metallic
        5: Mineral White
        6: Silver Blue
        7: Ametrin Metallic
    ]]--

    IN.CameraPerspective_ID = INT -- ID of camera perspective (DEFAULT: 1) - all options listed below
    --[[
        1: Side
        2: Wheel close-up
        3: Classic beauty shot
        4: Big front
        5: High roof
        6: Trunk
    ]]--

    IN.Door_F_L_OpeningValue = FLOAT -- Open/close door (front left) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)
    IN.Door_F_R_OpeningValue = FLOAT -- Open/close door (front right) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)
    IN.Door_B_L_OpeningValue = FLOAT -- Open/close door (back left) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)
    IN.Door_B_R_OpeningValue = FLOAT -- Open/close door (back right) (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)

    IN.Tailgate_OpeningValue = FLOAT -- Open/close tailgate (MIN: 0.0 = fully closed, MAX: 1.0 = fully open, DEFAULT: 0.0)


    -- Output Parameters (linked to 'Interface_CameraCrane' script)
    OUT.CameraPerspective = GLOBAL.perspectiveSettings

    -- Output Parameters (linked to 'Interface_Car' script)
    OUT.CarPaint = GLOBAL.paintSettings

    OUT.Door_F_L_OpeningValue = FLOAT
    OUT.Door_F_R_OpeningValue = FLOAT
    OUT.Door_B_L_OpeningValue = FLOAT
    OUT.Door_B_R_OpeningValue = FLOAT

    OUT.Tailgate_OpeningValue = FLOAT
end


-- Initializing (script-global) functions and variables
function init()
    -- Global functions

    -- Clamp f (number) between 'minimum' (number) and 'maximum' (number); returns number
    GLOBAL.clamp = function(f, minimum, maximum)
        if minimum > maximum then minimum, maximum = maximum, minimum end -- swap arguments if boundaries are provided in the wrong order
        return math.max(minimum, math.min(maximum, f))
    end


    -- Global variables

    GLOBAL.perspectiveSettings =
    {
        Yaw = FLOAT,
        Pitch = FLOAT,
        Roll = FLOAT,
        Distance = FLOAT,
        Origin = VEC3F,
    }

    -- List of all possible camera perspectives (can be extended)
    GLOBAL.Perspectives =
    {
        {   -- [1]
            Yaw = 0.0,
            Pitch = 0.0,
            Roll = 0.0,
            Distance = 750.0,
            Origin = {150.0, 90.0, 0.0},
        },
        {   -- [2]
            Yaw = -40.0,
            Pitch = -5.0,
            Roll = 1.5,
            Distance = 450.0,
            Origin = {50.0, 65.0, 0.0},
        },
        {   -- [3]
            Yaw = -70.0,
            Pitch = 15.0,
            Roll = 0.0,
            Distance = 800.0,
            Origin = {150.0, 50.0, -25.0},
        },
        {   -- [4]
            Yaw = -90.0,
            Pitch = 5.0,
            Roll = 0.0,
            Distance = 550.0,
            Origin = {150.0, 60.0, 0.0},
        },
        {   -- [5]
            Yaw = -140.0,
            Pitch = 60.0,
            Roll = 0.0,
            Distance = 950.0,
            Origin = {125.0, 75.0, 0.0},
        },
        {   -- [6]
            Yaw = -255.0,
            Pitch = 10.0,
            Roll = 0.0,
            Distance = 600.0,
            Origin = {220.0, 70.0, 0.0},
        },
    }

    GLOBAL.paintSettings =
    {
        Name = STRING, -- for debugging
        BaseColor = VEC4F,
        MetallicRoughness = VEC2F,
        SheenRoughness = FLOAT,
        SheenScale = FLOAT,
        NormalScale = FLOAT,
    }

    -- List of all possible car paints (can be extended)
    GLOBAL.Paints =
    {
        {   -- [1]
            Name = "Pyhtonic Blue",
            BaseColor = {0.026, 0.095, 0.173, 1.0},
            MetallicRoughness = {0.9, 0.4},
            SheenRoughness = 0.12,
            SheenScale = 0.35,
            NormalScale = 0.05,
        },
        {   -- [2]
            Name = "Tanzanite Blue",
            BaseColor = {0.03, 0.037, 0.12, 1.0},
            MetallicRoughness = {0.9, 0.33},
            SheenRoughness = 0.15,
            SheenScale = 0.3,
            NormalScale = 0.05,
        },
        {   -- [3]
            Name = "Black",
            BaseColor = {0.005, 0.005, 0.005, 1.0},
            MetallicRoughness = {0.5, 0.15},
            SheenRoughness = 0.12,
            SheenScale = 0.0,
            NormalScale = 0.0,
        },
        {   -- [4]
            Name = "Black Metallic",
            BaseColor = {0.005, 0.005, 0.005, 1.0},
            MetallicRoughness = {0.9, 0.4},
            SheenRoughness = 0.2,
            SheenScale = 0.2,
            NormalScale = 0.07,
        },
        {   -- [5]
            Name = "Mineral White",
            BaseColor = {0.55, 0.5, 0.45, 1.0},
            MetallicRoughness = {0.5, 0.4},
            SheenRoughness = 0.2,
            SheenScale = 0.15,
            NormalScale = 0.0,
        },
        {   -- [6]
            Name = "Silver Blue",
            BaseColor = {0.2, 0.4, 0.55, 1.0},
            MetallicRoughness = {0.88, 0.36},
            SheenRoughness = 0.15,
            SheenScale = 0.28,
            NormalScale = 0.05,
        },
        {   -- [7]
            Name = "Ametrin Metallic",
            BaseColor = {0.1, 0.015, 0.017, 1.0},
            MetallicRoughness = {0.8, 0.35},
            SheenRoughness = 0.15,
            SheenScale = 0.22,
            NormalScale = 0.05,
        },
    }
end


-- Passing through the Input parameters to the Output parameters
function run()
    OUT.CameraPerspective = GLOBAL.Perspectives[GLOBAL.clamp(IN.CameraPerspective_ID, 1, #GLOBAL.Perspectives)]

    OUT.CarPaint = GLOBAL.Paints[GLOBAL.clamp(IN.CarPaint_ID, 1, #GLOBAL.Paints)]

    OUT.Door_F_L_OpeningValue = IN.Door_F_L_OpeningValue
    OUT.Door_F_R_OpeningValue = IN.Door_F_R_OpeningValue
    OUT.Door_B_L_OpeningValue = IN.Door_B_L_OpeningValue
    OUT.Door_B_R_OpeningValue = IN.Door_B_R_OpeningValue

    OUT.Tailgate_OpeningValue = IN.Tailgate_OpeningValue
end
