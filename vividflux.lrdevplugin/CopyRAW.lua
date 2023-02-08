--[[----------------------------------------------------------------------------

Copy.lua
Summary information for ONE-CLICK COPY (Vivid Flux) plug-in

--------------------------------------------------------------------------------

Author:  Bowen Dong
Email 1: dbw1998@stu.pku.edu.cn
Email 2: dbw1998@outlook.com 

--------------------------------------------------------------------------------

Implementation of ONE-CLICK COPY for Lightroom Classic.

    Copy Selected Photos (RAW) with ONE-CLICK.

------------------------------------------------------------------------------]]

local LrFunctionContext = import "LrFunctionContext"
local LrProgressScope = import "LrProgressScope"
local LrTasks = import "LrTasks"

local CopyUtilities = require "CopyUtilities"

local function CopyRAW(lrFunctionContext)


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
            title = LOC("$$$/VividFlux/Copy/CopyRaw=Copy RAW"),
            functionContext = lrFunctionContext,
        }
    )
    progressScope:setPausable(true, true) -- pausable, cancelable
    local progressCount = 0

    -- copy
    local copyFlag = false
    for key, lrPhoto in pairs(lrPhotos) do

        while (progressScope:isPaused() and (not progressScope:isCanceled())) do
            LrTasks.sleep(1/4)
        end

        if progressScope:isCanceled() then
            return copyFlag
        end

        if CopyUtilities.copyRAW(lrPhoto, destDirectory) then
            copyFlag = true
        end

        progressCount = progressCount + 1
        progressScope:setPortionComplete(progressCount, photoCount)
    end

    progressScope:done()
    return copyFlag
end

LrFunctionContext.postAsyncTaskWithContext(
    "CopyRAW",
    CopyRAW
)
