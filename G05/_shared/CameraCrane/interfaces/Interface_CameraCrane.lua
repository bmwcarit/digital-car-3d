function interface(INOUT)
    INOUT.AspectFromResolution = Type:Bool()
    INOUT.CraneGimbal = {
        Distance = Type:Float(),
        Pitch = Type:Float(),
        Roll = Type:Float(),
        Yaw = Type:Float()
    }
    INOUT.Frustum = {
        AspectRatio = Type:Float(),
        FarPlane = Type:Float(),
        HorizontalFOV = Type:Float(),
        NearPlane = Type:Float()
    }
    INOUT.LocalTranslation = Type:Vec3f()
    INOUT.Origin = Type:Vec3f()
    INOUT.Viewport = {
        Height = Type:Int32(),
        OffsetX = Type:Int32(),
        OffsetY = Type:Int32(),
        Width = Type:Int32()
    }
end
