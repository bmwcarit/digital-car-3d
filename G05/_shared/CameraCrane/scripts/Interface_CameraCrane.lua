--[[
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]--


-- Define Input and Output parameters
function interface()
    --[[
    Car asset uses cm as units and is approximately 500 units long
    World origin in relation to the car asset:
        x = 0.0 is roughly at the front axis (horizontal axis, positive = right)
        y = 0.0 is at ground level (vertical axis, positive = up)
        z = 0.0 is at the center of the car (horizontal axis, positive = forward)
    ]]--

    -- Input Parameters

    local craneGimbal =
    {
        Yaw = FLOAT, -- Y-axis rotation of the camera around 'Origin' (vertical axis, deg) (DEFAULT: -40.0) (REMAPPED: 0.0-360.0)
        Pitch = FLOAT, -- X-axis rotation of the camera around 'Origin' (= elevation, deg) (DEFAULT: 10.0) (MIN: 0.0) (MAX: 90.0)
        Roll = FLOAT, -- rotation around the (local) Z-axis of the camera (deg) (DEFAULT: 0.0) (REMAPPED: 0.0 to 360.0)
        Distance = FLOAT, -- distance of camera to Origin on its Z-axis (= zoom in/out, cm) (DEFAULT: 800.0) (MIN: 325.0) (MAX: 1800.0)
    }

    IN.CraneGimbal = craneGimbal

    local viewport =
    {
        OffsetX = INT, -- horizontal viewport offset (px), currently not intented for use (DEFAULT: 0)
        OffsetY = INT, -- vertical viewport offset (px), currently not intented for use (DEFAULT: 0)
        Width = INT, -- horizontal viewport resolution (px) (DEFAULT: 1920) (MIN: 1)
        Height = INT, -- vertical viewport resolution (px) (DEFAULT: 1080) (MIN: 1)
    }

    IN.Viewport = viewport

    local frustum =
    {
        AspectRatio = FLOAT, -- ratio of width to height (DEFAULT: 1.77778), output value per default calculated in run()
        HorizontalFOV = FLOAT, -- horizontal field of view (deg) (DEFAULT: 43.0) (MIN: 0.0001) (MAX: 179.9999)
        NearPlane = FLOAT, -- closest distance where objects will still be visible (cm) (DEFAULT: 50.0)
        FarPlane = FLOAT, -- farthest distance where objects will still be visible (cm) (DEFAULT: 5000.0)
    }

    IN.Frustum = frustum

    IN.Origin = VEC3F -- origin around which the camera orbits (cm) (DEFAULT: {130.0, 50.0, 0.0})
    IN.LocalTranslation = VEC3F -- offset to the camera position in local space (cm) (DEFAULT: {0.0, 0.0, 0.0})
    IN.AspectFromResolution = BOOL -- (DEFAULT: TRUE)
    --[[
        TRUE: 'AspectRatio' is automatically calculated as: Width / Height
        FALSE: 'AspectRatio' input from Frustum is used
    ]]--


    -- Output Parameters (Linked to 'Logic_CameraCrane' script)
    OUT.CraneGimbal = craneGimbal
    OUT.Viewport = viewport
    OUT.Frustum = frustum

    OUT.Origin = VEC3F
    OUT.LocalTranslation = VEC3F
    OUT.AspectFromResolution = BOOL
end


-- Passing through the Input parameters to the Output parameters
function run()
    OUT.CraneGimbal = IN.CraneGimbal
    OUT.Viewport = IN.Viewport
    OUT.Frustum = IN.Frustum

    OUT.Origin = IN.Origin
    OUT.LocalTranslation = IN.LocalTranslation
    OUT.AspectFromResolution = IN.AspectFromResolution
end
