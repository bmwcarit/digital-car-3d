--[[
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]--


-- Define Input and Output parameters
function interface(IN,OUT)
    -- Input parameters
    IN.ShadowOnGround = Type:Bool() -- Turn on/off drop shadow of the car (DEFAULT: TRUE)
    IN.ShadowOnGroundColor = Type:Vec3f() -- Adjust drop shadow color (DEFAULT: {0.0, 0.0, 0.0, 1.0})
    IN.ShadowOnGroundOpacity = Type:Float() -- Opacity value of the drop shadow (DEFAULT: 1.0)


    -- Output parameters
    OUT.ShadowOnGround = Type:Bool() -- Linked to "Visible" property of the drop shadow of the car
    OUT.ShadowOnGroundColor = Type:Vec3f() -- Linked to material of the drop shadow of the car
    OUT.ShadowOnGroundOpacity = Type:Float() -- Linked to material of the drop shadow of the car
end


-- Passing through the Input parameters to the Output parameters
function run(IN,OUT)
    OUT.ShadowOnGround = IN.ShadowOnGround
    OUT.ShadowOnGroundColor = IN.ShadowOnGroundColor
    OUT.ShadowOnGroundOpacity = IN.ShadowOnGroundOpacity
end
