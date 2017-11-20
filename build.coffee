# FILE EXTENSION TO COMPILE #

extension = ".coffee"

# setup #
cmd = require 'node-cmd'
path = require 'path'
fs = require 'fs'
filesToCompile = []

# write functions
fromDir = (startPath, filter) ->
    console.log('[GETFILES] Starting from dir '+startPath+'/');
    if !fs.existsSync(startPath)
        throw '[GETFILES][ERROR] No directory provided. '+ startPath
        return
    files = fs.readdirSync(startPath)
    i = 0
    while i < files.length
        filename = path.join(startPath, files[i])
        stat = fs.lstatSync(filename)
        if filename isnt __filename
            if stat.isDirectory()
                fromDir filename, filter
                #recurse
            else if filename.indexOf(filter) >= 0
                console.log '[GETFILES] Found: '+ filename
                # push filename to file array #
                filesToCompile.push filename
                console.log '[GETFILES] Pushed ' + filename + ' to array'
                console.log '[GETFILES] Files to compile: '+filesToCompile
        i++
    return
compileFiles = () ->
    for i in filesToCompile
        console.log '[DEBUG][COMPILEFILES] Will run command: "'+'typescript -c '+ i+'"'
        cmd.run('typescript -c ""'+i+'"')        


# run functions
fromDir(__dirname, extension)
if not filesToCompile[0]?
    throw "[BUILD][ERROR] No files to build in current directory."
compileFiles()
