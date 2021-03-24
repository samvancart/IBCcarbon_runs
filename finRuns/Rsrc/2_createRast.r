# r_no <- regions <- 1
devtools::source_url("https://raw.githubusercontent.com/ForModLabUHel/IBCcarbon_runs/master/finRuns/Rsrc/settings.r")
source_url("https://raw.githubusercontent.com/ForModLabUHel/IBCcarbon_runs/master/general/functions.r")

pathFiles <- paste0("outputDT/forCent",r_no,"/")

load(paste0("input/forCent_",r_no,"_IDsTab.rdata"))
forCentIDsTab <- forCentIDsTab[segID!=0]
setkey(forCentIDsTab,segID)

varXs <- c(varNames[varSel], specialVars)
for(varX in varXs){
  # varX <- varXs[1]
  fileXs <- list.files(path = pathFiles, pattern = varX)
  outX <- data.table()
  for(i in 1:length(fileXs)){
    load(paste0(pathFiles,fileXs[i]))
    outX <- rbind(outX,get(varX))
  }
  
  setkey(outX,segID)

  tabX <- merge(outX,forCentIDsTab)

  
  # can make a loop 
  rastX <- rasterFromXYZ(tabX[,.(x,y,per1)])
  writeRaster(rastX,filename = paste0("rasters/forCent",r_no,"/",
                                      varX,"_",min(per1),"-",max(per1),".tiff"),overwrite=T)
  rastX <- rasterFromXYZ(tabX[,.(x,y,per2)])
  writeRaster(rastX,filename = paste0("rasters/forCent",r_no,"/",
                                      varX,"_",min(per2),"-",max(per2),".tiff"),overwrite=T)
  rastX <- rasterFromXYZ(tabX[,.(x,y,per3)])
  writeRaster(rastX,filename = paste0("rasters/forCent",r_no,"/",
                                      varX,"_",min(per3),"-",max(per3),".tiff"),overwrite=T)
  
  file.remove(paste0(pathFiles,fileXs))
  print(varX)
}
