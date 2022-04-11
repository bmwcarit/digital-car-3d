--[[
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]--


-- Define Input and Output parameters
function interface()
    -- Input parameters
    IN.ShadowOnGround = BOOL -- Turn on/off drop shadow of the car (DEFAULT: TRUE)
    IN.ShadowOnGroundColor = VEC3F -- Adjust drop shadow color (DEFAULT: {0.0, 0.0, 0.0, 1.0})
    IN.ShadowOnGroundOpacity = FLOAT -- Opacity value of the drop shadow (DEFAULT: 1.0)


    -- Output parameters
    OUT.ShadowOnGround = BOOL -- Linked to "Visible" property of the drop shadow of the car
    OUT.ShadowOnGroundColor = VEC3F -- Linked to material of the drop shadow of the car
    OUT.ShadowOnGroundOpacity = FLOAT -- Linked to material of the drop shadow of the car
end


-- Passing through the Input parameters to the Output parameters
function run()
    OUT.ShadowOnGround = IN.ShadowOnGround
    OUT.ShadowOnGroundColor = IN.ShadowOnGroundColor
    OUT.ShadowOnGroundOpacity = IN.ShadowOnGroundOpacity
end
