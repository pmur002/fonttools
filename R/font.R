
loadFont <- function(file) {
    py <- py_run_string(paste0('from fontTools import ttLib;',
                               'font = ttLib.TTFont("',
                               file, '")'),
                        local=TRUE)
    py$font
}
