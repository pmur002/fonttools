
loadFont <- function(file) {
    py <- py_run_string(paste0('from fontTools import ttLib;',
                               'font = ttLib.TTFont("',
                               file, '")'),
                        local=TRUE)
    py$font
}

fontFamily <- function(font) {
    font['name']$getName(1, 1, 0)$toStr()
}

fontWeight <- function(font) {
    font['OS/2']$usWeightClass
}

fontStyle <- function(font) {
    run <- font['hhea']$caretSlopeRun
    if (run != 0) {
        "italic"
    } else {
        "normal"
    }
}

fontGlyphIndex <- function(font, name) {
    font$getGlyphID(name)
}

## unicode is 
fontGlyphName <- function(font, unicode) {
    font$getBestCmap()[[as.character(as.numeric(unicode))]]
}

fontGlyphWidth <- function(font, index) {
    units <- font['head']$unitsPerEm
    width <- unlist(font['hmtx']$metrics[[index]])
    attr(width, "unitsPerEm") <- units
    width
}

fontGlyphHeight <- function(font, index) {
    units <- font['head']$unitsPerEm
    vmtx <- font$get('vmtx')
    height <- NULL
    if (!is.null(vmtx)) {
        height <- unlist(vmtx$metrics[[index]])
        attr(height, "unitsPerEm") <- units
    }
    height
}

fontGlyphBounds <- function(font, index) {
    glyphSet <- font$getGlyphSet()
    bp <- boundsPen()$BoundsPen(glyphSet)
    glyphSet[font$glyphOrder[index]]$draw(bp)
    unlist(bp$bounds)
}
