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
        if minimum > maximum then minimum, maximum = maximum, minimum end -- swap arguments if boundaries are provided in the wrong order
        return math.max(minimum, math.min(maximum, f))
    end

    -- Linear interpolation between x (number) and y (number) using an interpolation value t (number, 0.0 to 1.0); output value is not clamped
    GLOBAL.lerp = function(x, y, t)
        return x * (1.0 - t) + y * t
    end


    -- Global variables
    GLOBAL.DOORS_F_ANGLE_OPEN = 63.0
    GLOBAL.DOORS_F_ANGLE_CLOSED = 0.0
    GLOBAL.DOORS_B_ANGLE_OPEN = 65.0
    GLOBAL.DOORS_B_ANGLE_CLOSED = 0.0
    GLOBAL.TAILGATE_ANGLE_OPEN = 73.0
    GLOBAL.TAILGATE_ANGLE_CLOSED = 0.0
end


-- Define Input and Output parameters
function interface(IN,OUT)
    -- Input Parameters
    IN.Door_F_L_OpeningValue = Type:Float()
    IN.Door_F_R_OpeningValue = Type:Float()
    IN.Door_B_L_OpeningValue = Type:Float()
    IN.Door_B_R_OpeningValue = Type:Float()

    IN.Tailgate_OpeningValue = Type:Float()


    -- Output Parameters
    OUT.Pivot_Door_F_L_Rotation = Type:Vec3f()
    OUT.Pivot_Door_F_R_Rotation = Type:Vec3f()
    OUT.Pivot_Door_B_L_Rotation = Type:Vec3f()
    OUT.Pivot_Door_B_R_Rotation = Type:Vec3f()

    OUT.Pivot_Tailgate_Rotation = Type:Vec3f()
end


-- Calculating Output parameters based on Input parameters
function run(IN,OUT)
    OUT.Pivot_Door_F_L_Rotation = {0.0, -GLOBAL.lerp(GLOBAL.DOORS_F_ANGLE_CLOSED, GLOBAL.DOORS_F_ANGLE_OPEN,
                                                     GLOBAL.clamp(IN.Door_F_L_OpeningValue, 0.0, 1.0)), 0.0}
    OUT.Pivot_Door_F_R_Rotation = {0.0, -GLOBAL.lerp(GLOBAL.DOORS_F_ANGLE_CLOSED, GLOBAL.DOORS_F_ANGLE_OPEN,
                                                     GLOBAL.clamp(IN.Door_F_R_OpeningValue, 0.0, 1.0)), 0.0}
    OUT.Pivot_Door_B_L_Rotation = {0.0, -GLOBAL.lerp(GLOBAL.DOORS_B_ANGLE_CLOSED, GLOBAL.DOORS_B_ANGLE_OPEN,
                                                     GLOBAL.clamp(IN.Door_B_L_OpeningValue, 0.0, 1.0)), 0.0}
    OUT.Pivot_Door_B_R_Rotation = {0.0, -GLOBAL.lerp(GLOBAL.DOORS_B_ANGLE_CLOSED, GLOBAL.DOORS_B_ANGLE_OPEN,
                                                     GLOBAL.clamp(IN.Door_B_R_OpeningValue, 0.0, 1.0)), 0.0}

    OUT.Pivot_Tailgate_Rotation = {0.0, 0.0, GLOBAL.lerp(GLOBAL.TAILGATE_ANGLE_CLOSED, GLOBAL.TAILGATE_ANGLE_OPEN,
                                                         GLOBAL.clamp(IN.Tailgate_OpeningValue, 0.0, 1.0))}
end
