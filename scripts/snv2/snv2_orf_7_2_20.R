#######################
#the functions we used to generate
#the ORFs information for SARS-CoV-2
#source snv2_helper_7_2_20.R first before start
#########################

ncov.cds.df.gen <- function(outfile) {
  # ggm means gene.genbank.map
  ggm <- c()
  ggm["ORF1ab"] <- "4"
  ggm["ORF1a"] <- "20"
  ggm["S"] <- "35"
  ggm["ORF3a"] <- "37"
  ggm["E"] <- "39"
  ggm["M"] <- "41"
  ggm["ORF6"] <- "43"
  ggm["ORF7a"] <- "45"
  ggm["ORF7b"] <- "47"
  ggm["ORF8"] <- "49"
  ggm["ORF9"] <- "51"
  ggm["ORF10"] <- "53"
  
  df <- matrix(data = rep("", length(ggm) * 29903), nrow = 29903) %>% as.data.frame() %>% `colnames<-`(names(ggm))
  df <- add.column.fanc(df, data.frame(gpos = 1:29903), pos=1)
  
  gb <- entrez_fetch("nuccore", id = "NC_045512.2", rettype = "gb", api_key ="4d2374d16cee57dded1296ac1a48ba9c3b09") %>% 
    parseGenBank(text=.)
  ORF1ab.aa <- gb$FEATURES$`4`$translation[1] %>% strsplit("") %>% unlist()
  df$ORF1ab <- map.aa(input.vec = df$ORF1ab, start.gpos = 266, stop.gpos = 13468, start.aapos=1, stop.aapos= 4401,
                      aa = ORF1ab.aa, add.stop.codon = F)
  df$ORF1ab <- map.aa(input.vec = df$ORF1ab, start.gpos = 13468, stop.gpos = 21555, start.aapos = 4402, stop.aapos = length(ORF1ab.aa),
                      aa = ORF1ab.aa, add.stop.codon = T)
  # ORF1a.aa <- gb$FEATURES$`20`$translation[1] %>% strsplit("") %>% unlist()
  # df$ORF1a <- map.aa(input.vec = df$ORF1a, start.gpos = 266, stop.gpos = 13483, start.aapos=1, stop.aapos= length(ORF1a.aa),
  #                    aa = ORF1a.aa, add.stop.codon = T)
  
  for (i in 2:length(ggm)) {
    gene <- names(ggm[i])
    gb.feature <- ggm[i]
    df[, gene] <- map.aa.from.gb(input.vec = df[, gene], gb.obj = gb, feature = gb.feature)
  }
  
  if (!is.null(outfile)) {
    write.table(df, outfile, quote = F, row.names = F, col.names = T, sep = "\t")
  }
  
  return(df)
}


ncov.cds.df.check <- function(outfile) {
  x <- ncov.cds.df.gen()
  inspect <- x[1, ]
  for (i in c(266, 13468, 21555, 13483, 21563, 25384, 25393,26220, 26245,26472, 26523,27191,
              27202,27387, 27394,27759, 27756,27887, 27894,28259, 28274,29533, 29558, 29674)) {
    inspect <- rbind(inspect, x[(i-5):(i+5), ])
  }
  write.table(inspect, outfile, quote = F, row.names = F, col.names = T, sep = "\t")
  return(inspect)
}
