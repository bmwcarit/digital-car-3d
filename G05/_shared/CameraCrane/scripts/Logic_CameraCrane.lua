--[[
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]--


-- Initializing (script-global) functions and variables
function init()
    -- Global functions

    -- Clamp f (number) between 'minimum' (number) and 'maximum' (number); returns number
    GLOBAL.clamp = function(f, minimum, maximum)
        if minimum > maximum then minimum, maximum = maximum, minimum end -- Swap arguments if boundaries are provided in the wrong order
        return math.max(minimum, math.min(maximum, f))
    end


    -- Global variables
    GLOBAL.CAMERA_MIN_DISTANCE = 250.0 -- Closest possible distance of the scene camera to 'Origin'
    GLOBAL.CAMERA_MAX_DISTANCE = 1500.0 -- Farthest possible distance of the scene camera to 'Origin'
    GLOBAL.CAMERA_MIN_PITCH = -10.0 -- Lowest possible pitch (elevation) of the scene camera
    GLOBAL.CAMERA_MAX_PITCH = 90.0 -- Highest possible pitch (elevation) of the scene camera
end


-- Define Input and Output parameters
function interface()
    IN.CraneGimbal = {
        Yaw = FLOAT,
        Pitch = FLOAT,
        Roll = FLOAT,
        Distance = FLOAT
    }

    IN.Origin = VEC3F
    IN.LocalTranslation = VEC3F

    IN.Viewport = {
        OffsetX = INT,
        OffsetY = INT,
        Width = INT,
        Height = INT
    }

    IN.Frustum = {
        AspectRatio = FLOAT,
        HorizontalFOV = FLOAT,
        NearPlane = FLOAT,
        FarPlane = FLOAT
    }

    IN.AspectFromResolution = BOOL


    -- Linked to Properties of Node with corresponding prefix
    OUT.POS_ORIGIN_Translation = VEC3F
    OUT.POS_ORIGIN_R_Translation = VEC3F
    OUT.YAW_Rotation = VEC3F
    OUT.YAW_R_Rotation = VEC3F
    OUT.PITCH_Rotation = VEC3F
    OUT.PITCH_R_Rotation = VEC3F
    OUT.DIST_Rotation = VEC3F
    OUT.DIST_R_Rotation = VEC3F
    OUT.DIST_Translation = VEC3F
    OUT.DIST_R_Translation = VEC3F
    OUT.CAM_Translation = VEC3F
    OUT.CAM_R_Translation = VEC3F

    -- Linked to Properties of SceneCamera and ReflectionCamera

    OUT.viewport = {
        offsetX = INT,
        offsetY = INT,
        width = INT,
        height = INT
    }

    OUT.frustum = {
        nearPlane = FLOAT,
        farPlane =  FLOAT,
        fieldOfView = FLOAT,
        aspectRatio = FLOAT
    }
end


-- Calculating Output parameters based on Input parameters
function run()
    -- Crane Gimbal

    local origin = IN.Origin
    local localTranslation = IN.LocalTranslation

    OUT.POS_ORIGIN_Translation = {origin[1], origin[2], origin[3]}
    OUT.POS_ORIGIN_R_Translation = {origin[1], -origin[2], origin[3]} -- Reflection mirrored on vertical axis

    OUT.CAM_Translation = {localTranslation[1], localTranslation[2], localTranslation[3]}
    OUT.CAM_R_Translation = {localTranslation[1], -localTranslation[2], localTranslation[3]} -- Reflection mirrored on vertical axis

    local yaw = IN.CraneGimbal.Yaw % 360
    local pitch = GLOBAL.clamp(IN.CraneGimbal.Pitch, GLOBAL.CAMERA_MIN_PITCH, GLOBAL.CAMERA_MAX_PITCH) % 360
    local roll = IN.CraneGimbal.Roll % 360
    local distance = GLOBAL.clamp(IN.CraneGimbal.Distance, GLOBAL.CAMERA_MIN_DISTANCE, GLOBAL.CAMERA_MAX_DISTANCE)

    OUT.YAW_Rotation = {0.0, yaw, 0.0}
    OUT.YAW_R_Rotation = {0.0, yaw, 0.0}  -- Reflection mirrored on vertical axis

    OUT.PITCH_Rotation = {-pitch, 0.0, 0.0}
    OUT.PITCH_R_Rotation = {pitch, 0.0, 0.0}  -- Reflection mirrored on vertical axis

    OUT.DIST_Rotation = {0.0, 0.0, roll} -- = ROLL
    OUT.DIST_R_Rotation = {0.0, 0.0, -roll} -- = ROLL_R, Reflection mirrored on vertical axis

    OUT.DIST_Translation = {0.0, 0.0, distance} -- = DISTANCE
    OUT.DIST_R_Translation = {0.0, 0.0, distance}

    -- Viewport

    local width = math.max(1, IN.Viewport.Width)
    local height = math.max(1, IN.Viewport.Height)

    OUT.viewport = {
        offsetX = IN.Viewport.OffsetX,
        offsetY = IN.Viewport.OffsetY,
        width = width,
        height = height
    }

    -- Frustum

    -- 0.0 < nearPlane < farPlane
    local nearPlane = math.max(0.0001, IN.Frustum.NearPlane)
    local farPlane = math.max(nearPlane + 0.0001, IN.Frustum.FarPlane)
    nearPlane = math.min(nearPlane, farPlane - 0.0001)

    -- this converts the input *horizontal FOV* into RaCo-readable *vertical FOV*
    local fov = math.deg(2.0 * math.atan(math.tan(math.rad(IN.Frustum.HorizontalFOV) * 0.5) / (width / height)))
    fov = GLOBAL.clamp(fov, 0.0001, 179.9999)

    local aspect = IN.AspectFromResolution and width / height or IN.Frustum.AspectRatio

    OUT.frustum = {
        nearPlane = nearPlane,
        farPlane = farPlane,
        fieldOfView = fov,
        aspectRatio = aspect
    }
end
