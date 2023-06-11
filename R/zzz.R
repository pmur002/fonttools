
fontToolsEnv <- new.env()

assign("ttLib", NULL, env=fontToolsEnv)

ttLib <- function() {
    tt <- get("ttLib", env=fontToolsEnv)
    if (is.null(tt))
        stop(paste("FontTools is not available;",
                   "have you run initFontTools()?"))
    tt
}

initFontTools <- function() {
    ## Check whether Python exists and is bound to reticulate
    havePython <- py_available(initialize=TRUE)
    if (!havePython) {
        install_miniconda()
        py_config()
    }
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
    }
}

.onLoad <- function(libname, pkgname) {
    ## May offer to install (miniconda) Python if no Python is available
    ## Turn off the auto-install with ...
    ## RETICULATE_MINICONDA_ENABLED=FALSE
    havePython <- py_available(initialize=TRUE)
    if (havePython) {
        haveFontTools <- py_module_available("fontTools")
        if (haveFontTools) {
            assign("ttLib",
                   import("fontTools.ttLib", delay_load = TRUE),
                   env=fontToolsEnv)
        } else {
            warning(paste("Python fontTools library must be installed;",
                          "see ?initFontTools"))
        }
    } else {
        warning(paste("Python must be installed;",
                      "see ?initFontTools"))
    }
}

