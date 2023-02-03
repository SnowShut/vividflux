--[[----------------------------------------------------------------------------

Copy.lua
Summary information for ONE-CLICK COPY (Vivid Flux) plug-in

--------------------------------------------------------------------------------

Author:  Bowen Dong
Email 1: dbw1998@stu.pku.edu.cn
Email 2: dbw1998@outlook.com 

--------------------------------------------------------------------------------

Implementation of ONE-CLICK COPY for Lightroom Classic.

    Copy Selected Photos (RAW and XMP) with ONE-CLICK.

------------------------------------------------------------------------------]]

local LrFunctionContext = import "LrFunctionContext"
local LrProgressScope = import "LrProgressScope"

local CopyUtilities = require "CopyUtilities"

local function CopyRAWWithXMP(lrFunctionContext)


    -- choose destination directory

    local destDirectory = CopyUtilities.chooseDestDirectory()

    if nil == destDirectory then
        return false
    end

    -- get Selected Photos

    local lrPhotos = CopyUtilities.getSelectedPhotos()

    if nil == lrPhotos then
        return false
    end

    -- record copying progress
    local photoCount = #lrPhotos
    local progressScope = LrProgressScope(
        {
            title = LOC("$$$/VividFlux/Copy/CopyRAWWithXMP=Copy RAW with xmp"),
            functionContext = lrFunctionContext,
        }
    )
    progressScope:setPausable(false, false)
    local progressCount = 0

    -- copy
    local copyFlag = false
    for key, lrPhoto in pairs(lrPhotos) do

        if CopyUtilities.copyRAW(lrPhoto, destDirectory) then
            if CopyUtilities.copyXMP(lrPhoto, destDirectory) then
                copyFlag = true
            end
        end

        progressCount = progressCount + 1
        progressScope:setPortionComplete(progressCount, photoCount)
    end

    progressScope:done()
    return copyFlag
end

LrFunctionContext.postAsyncTaskWithContext(
    "CopyRAWWithXMP",
    CopyRAWWithXMP
)
