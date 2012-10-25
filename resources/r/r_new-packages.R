## R script to load essential packages for new R installs  |  originally for version 2.15.0  |  10/2012 by Ariel Paulson
## loads: All BioC software + CRAN dependencies, all generic BioC annotation + those specific to SIMR models, a few extra CRAN packages
## see 'packlist$CRAN' for extra CRAN package list
## SIMR models are: H.sapiens M.musculus G.gallus D.rerioD.melanogaster C.elegans S.cerevisiae S.pombe
## see 'strings' list for the greps which extract the desired BioC annotation packages.  This list is, obviously, requires manual tuning and thus requires periodic updating.
##  - on that note, see "BioC_annotation_selected.log" and "BioC_annotation_skipped.log" post-installation to make sure everything was in order



## setup

begin <- Sys.time(); begin
source("/n/projects/apa/R/apa_tools.R")  # for qw, mgrep, write.vector
source("http://www.bioconductor.org/biocLite.R")
R.ver <- paste(R.version$major, R.version$minor, sep="."); R.ver
bioc.ver <- tools:::.BioC_version_associated_with_R_version; bioc.ver
repos <- getOption("repos")
repos["CRAN"] <- "http://cran.wustl.edu"
options(repos=repos)
options(BioC_mirror = "http://www.bioconductor.org")
logprefix <- paste("/n/local/bin/bio.brew/logs/r/R-",R.ver,sep="")
packlist <- list(CRAN=c(), BioC.software=c(), BioC.annotation=c())
strings <- bioc.annots <- list()




## get/set packlists

# CRAN packages, broken out into functional grouups
#CRAN <- rownames(available.packages(contrib.url(getOption("repos"))))
dataframes <- qw(sqldf,dataframe,data.table,WriteXLS)
phylo <- qw(ape,pegas)
parallel <- qw(Rmpi,parallel,snow,multicore)
database <- qw(RMySQL,RPostgreSQL,RODBC,RSQLite,RSQLite.extfuns)
hadley <- qw(plyr,stringr,ggplot2)
analysis <- qw(combinat,hsaur,MASS)
graphics <- qw(scatterplot3d)
misc <- qw(R.oo,knitR,knitcitations)

packlist$CRAN <- c(dataframes,phylo,parallel,database,hadley,analysis,graphics,misc)   # and RCurl and Rgraphviz, but manually

packlist$BioC.software <- rownames(available.packages(paste("http://www.bioconductor.org/packages",bioc.ver,"bioc/src/contrib/",sep="/")))




## string sets to grep out BioC annot pkgs for our models:

BioC.annot <- rownames(available.packages(paste("http://www.bioconductor.org/packages",bioc.ver,"data/annotation/src/contrib/",sep="/")))

# genus/species strings for BSgenomes
strings[[1]] <- paste("^BSgenome\\.",qw(Hsap,Mmus,Ggal,Drer,Dmel,Cele,Scer),sep="")   # matching "BSgenome.Gspe"

# genus/species strings for org.*.db, hom.*.inp.db, etc.
strings[[2]] <- paste("*\\.",qw(Hs,Mm,Gg,Dr,Dm,Ce,Sc,Sp),"\\.*",sep=""),   # matching ".Gs."

# prefixes for cdf, .db, other microarray packages
strings[[3]] <- paste("^",qw(hgu,hthgu,gahgu,hu,Hu,hg,Hs,u133,illuminaHu,lumiH,mgu,htmg,mo,mu,illuminaMo,lumiMo,ye,yg,human,mouse,celegans,chicken,dros,fly,worm,zebrafish,OperonHuman,HumanMeth),sep="")

# prefixes for pd.*.db microarray platform design packages
strings[[4]] <- paste("^pd\\.",qw(celegans,chicken,cyto,hg,mg,ht.hg,ht.mg,hu,mu,mo,mirna,u133,yeast,yg,zebrafish),sep="")

# prefixes for other desired annotation package sets
strings[[5]] <- paste("^",qw(RmiR,mir,targetscan,HsAgilent,MmAgilent),sep="")

# manually specify any additional annot packages
strings[[6]] <- qw(GO.db,KEGG.db,PFAM.db,indac.db,oligoData)

# grep annotation packages
for (i in 1:length(strings)) { bioc.annots[[i]] <- mgrep(strings[[i]], BioC.annot) }
packlist$BioC.annotation <- BioC.annot[unlist(bioc.annots)]

# write out the selected vs unselected package lists for later inspection
write.vector(packlist$BioC.annotation, paste(logprefix,"_BioC_annotation_selected.log",sep=""))
write.vector(setdiff(BioC.annot, packlist$BioC.annotation), paste(logprefix,"_BioC_annotation_skipped.log",sep=""))




## install packages

for (p in names(packlist)) {
    logfile <- paste(logprefix,p,"install.log",sep="_")
    if (file.exists(logfile)) {
        already <- as.matrix(read.delim(logfile, sep="\t", header=T, row.names=2))
	fh <- file(logfile, open="at")
    } else {
        fh <- file(logfile, open="wt")
	writeLines("Num\tPackage\tElapsed", fh)
	already <- c()  # dummy object
    }
    N <- length(packlist[[p]])
    for (i in 1:N) {
        if (packlist[[p]][i] %in% rownames(already)) { 
	   next
	} else {
           message("Package: ",i," / ",N,"\n")
           time <- system.time( biocLite(packlist[[p]][i], suppressUpdates=TRUE) )
           writeLines(sprintf("%i\t%s\t%0.2f",i,packlist[[p]][i],time[[3]],sep="\t"), fh)
    	}
    	flush.connection(fh)
    }
}
writeLines("Complete!", fh)

save(packlist, file=paste(logprefix,"packlist.Rdata",sep="."))
end <- Sys.time()

message("begin: ", begin)
message("  end: ", end)


