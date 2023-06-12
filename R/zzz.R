
fontToolsEnv <- new.env()

assign("ttLib", NULL, env=fontToolsEnv)

ttLib <- function() {
    tt <- get("ttLib", env=fontToolsEnv)
    if (is.null(tt))
        stop(paste("FontTools is not available;",
                   "try running installFontTools()?"))
    tt
}

boundsPen <- function() {
    bp <- get("boundsPen", env=fontToolsEnv)
    if (is.null(bp))
        stop(paste("FontTools is not available;",
                   "try running installFontTools()?"))
    bp
}

installFontTools <- function() {
    ## Check whether Python exists and is bound to reticulate
    ## Will offer to install Python (miniconda) otherwise
    havePython <- py_available(initialize=TRUE)
    if (!havePython) {
        stop(paste("Python must be installed to use",
                   "the fonttools package"))
    }
    ## Check whether Python library fontTools is installed
    ## Will install fontTools if necessary
    haveFontTools <- py_module_available("fontTools")
    if (!haveFontTools) {
        py_install("fontTools")
        if (!py_module_available("fontTools")) {
            stop(paste("The Python fontTools library must be installed to use",
                       "the fonttools package"))
        }
        assign("ttLib",
               import("fontTools.ttLib", delay_load=TRUE),
               env=fontToolsEnv)
        assign("boundsPen",
               import("fontTools.pens.boundsPen", delay_load=TRUE),
               env=fontToolsEnv)
    }
}

.onLoad <- function(libname, pkgname) {
    assign("ttLib",
           import("fontTools", delay_load = TRUE),
           env=fontToolsEnv)
    assign("boundsPen",
           import("fontTools.pens.boundsPen", delay_load=TRUE),
           env=fontToolsEnv)
}

