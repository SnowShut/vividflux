--[[----------------------------------------------------------------------------

Info.lua
Summary information for Vivid Flux plug-in

--------------------------------------------------------------------------------

Author:  Bowen Dong
Email 1: dbw1998@stu.pku.edu.cn
Email 2: dbw1998@outlook.com 

--------------------------------------------------------------------------------

Implementation of Vivid Flux for Lightroom Classic.

    
Features:
    1. Copy Selected Photos (RAW, JPG or XMP) with ONE-CLICK.

TODO:
1. upper or lower case
2. change version limit

------------------------------------------------------------------------------]]

return {

    LrSdkVersion = 12.1,        -- TODO: older version of SDK?
	LrSdkMinimumVersion = 12.1, -- minimum SDK version required by this plug-in

    LrToolkitIdentifier = "com.vividflux.lightroom.vividflux",

    LrPluginName = LOC("$$$/VividFlux/PluginName=Vivid Flux"),

    LrLibraryMenuItems = {
        {
            title = LOC("$$$/VividFlux/Copy/CopyRaw=Copy RAW"),
            file = "CopyRAW.lua",
            enabledWhen = "photosSelected",
        },
        {
            title = LOC("$$$/VividFlux/Copy/CopyRAWWithXMP=Copy RAW with xmp"),
            file = "CopyRAWWithXMP.lua",
            enabledWhen = "photosSelected",
        },
        {
            title = LOC("$$$/VividFlux/Copy/CopyJPG=Copy JPG"),
            file = "CopyJPG.lua",
            enabledWhen = "photosSelected",
        }
	},

    VERSION = { major=0, minor=1, revision=0, build=0, },

}
