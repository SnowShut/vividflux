--[[----------------------------------------------------------------------------

CopyUtilities.lua
Summary information for ONE-CLICK COPY (Vivid Flux) plug-in

--------------------------------------------------------------------------------

Author:  Bowen Dong
Email 1: dbw1998@stu.pku.edu.cn
Email 2: dbw1998@outlook.com 

--------------------------------------------------------------------------------

Implementation of ONE-CLICK COPY for Lightroom Classic.

    Copy Selected Photos (RAW) with ONE-CLICK.

------------------------------------------------------------------------------]]

local LrPathUtils = import "LrPathUtils"
local LrFileUtils = import "LrFileUtils"
local LrApplication = import "LrApplication"
local LrDialogs = import "LrDialogs"
local catalog = LrApplication.activeCatalog()

local CopyUtilities = {}

function CopyUtilities.copyFileWithExtension(lrPhoto, extension, destDirectory)

    -- Copy file with extension
    -- TODO: test upper or lower case?

    local srcPath = LrPathUtils.replaceExtension(
        lrPhoto:getRawMetadata("path"),
        extension
    )

    if "file" == LrFileUtils.exists(srcPath) then

        local destPath = LrFileUtils.chooseUniqueFileName(
            LrPathUtils.child(
                destDirectory,
                LrPathUtils.leafName(srcPath)
            )
        )

        if true == LrFileUtils.copy(srcPath, destPath) then
            return true
        end
    end

    return false

end

function CopyUtilities.chooseDestDirectory()

    -- choose the distination directory for copying

    local panelArgs = {
        title = "Choose Destination Directory",
        canChooseFiles = false,
        canChooseDirectories = true,
        canCreateDirectories = true,
        allowsMultipleSelection = false,
    }

    local pathArr = LrDialogs.runOpenPanel(panelArgs)

    if nil == pathArr then
        return nil
    end

    local destDirectory = pathArr[1]

    if "directory" == LrFileUtils.exists(destDirectory) then
        return destDirectory
    elseif true == LrFileUtils.createAllDirectories(destDirectory) then
        return destDirectory
    else
        return nil
    end

end

function CopyUtilities.getSelectedPhotos()

    -- Get selected photos from catalog

    if catalog:getTargetPhoto() then
        return catalog:getTargetPhotos()
    else
        return nil
    end

end

function CopyUtilities.simpleCopy(lrPhoto, destDirectory)

    -- copy photo

    local srcPath = lrPhoto:getRawMetadata("path")
    local destPath = LrFileUtils.chooseUniqueFileName(
        LrPathUtils.child(
            destDirectory,
            LrPathUtils.leafName(srcPath)
        )
    )
    if true == LrFileUtils.copy(srcPath, destPath) then
        return true
    end
    return false
end

function CopyUtilities.copyRAW(lrPhoto, destDirectory)

    -- copy RAW

    if "RAW" == lrPhoto:getRawMetadata("fileFormat") then
        return CopyUtilities.simpleCopy(lrPhoto, destDirectory)
    end
    return false
end

function CopyUtilities.copyJPG(lrPhoto, destDirectory)
    
    -- copy JPG(JPEG)

    if "JPG" == lrPhoto:getRawMetadata("fileFormat") then
        return CopyUtilities.simpleCopy(lrPhoto, destDirectory)
    elseif CopyUtilities.copyFileWithExtension(lrPhoto, "JPG", destDirectory) then
        return true
    else
        return CopyUtilities.copyFileWithExtension(lrPhoto, "JPEG", destDirectory)
    end
end

function CopyUtilities.copyXMP(lrPhoto, destDirectory)

    -- copy XMP (only with RAW)

    return CopyUtilities.copyFileWithExtension(lrPhoto, "xmp", destDirectory)
end

return CopyUtilities
