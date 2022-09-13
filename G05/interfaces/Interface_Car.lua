function interface(INOUT)
    INOUT.CarPaint = {
        BaseColor = Type:Vec4f(),
        MetallicRoughness = Type:Vec2f(),
        Name = Type:String(),
        NormalScale = Type:Float(),
        SheenRoughness = Type:Float(),
        SheenScale = Type:Float()
    }
    INOUT.Door_B_L_OpeningValue = Type:Float()
    INOUT.Door_B_R_OpeningValue = Type:Float()
    INOUT.Door_F_L_OpeningValue = Type:Float()
    INOUT.Door_F_R_OpeningValue = Type:Float()
    INOUT.Tailgate_OpeningValue = Type:Float()
end
