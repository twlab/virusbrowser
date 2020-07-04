library(dplyr)
library(seqinr)
library(parallel)
library(stringr)
library(jsonlite)
library(bedr)
library(S4Vectors)
options(scipen = 30)
options(stringsAsFactors = F)

#######################
#the main function to generate snv2
#########################


tsv2snv2.2 <- function(tsv.vec, ref.fa, ref.orf.table, min.contig.head.tail = 15, out.snv2.vec,
                       hier.df, thread.master, thread.sub, 
                       bedtools.path ,
                       return.df = F) {
  if (length(tsv.vec) == 0)
    return("tsv.vec has zero length")
  if (is.character(hier.df)) {
    hier.df <- read.table(hier.df, header = T, as.is= T, sep = "\t", quote = "")
  }
  
  if (is.character(ref.orf.table))
    ref.orf.table <- read.table(ref.orf.table, sep = "\t", header = T, quote = "", as.is = T)
  orfs <- colnames(ref.orf.table)
  orfs <- orfs[orfs != "gpos"]
  
  ref <- seqinr::read.fasta(ref.fa, forceDNAtolower = F)[[1]]
  ref.seq <- ref[1:length(ref)] %>% toupper()
  ref.name <- attr(ref, "name")
  
  out.df.list <- mclapply(seq_along(tsv.vec), function(i) {
    # tsv <- tsv.vec  
    tsv <- tsv.vec[i]
    out.snv2 <- out.snv2.vec[i]
    print(tsv)
    prep <- tsv.prep(tsv, n.mask = T, del.mask = T, min.contig.head.tail = min.contig.head.tail, 
                     min.contig.n.mask = 3, min.contig.del.mask = 3, max.gap.n.mask = 1, max.gap.del.mask = 1)
    tsv <- prep$tsv
    # tsv$mismatch[tsv$mismatch == "N"] <- ""
    # print(nrow(tsv))
    if (nrow(tsv) != nrow(ref.orf.table) )
      stop(paste0("the length of tsv (", nrow(tsv), 
                  ") does not match the length of ref.orf.table (", nrow(ref.orf.table), ")"))
    vecs.list <- mclapply(orfs, function(orf) {
      df <- cbind(ref.orf.table[,"gpos"],tsv, ref.orf.table[, orf])
      colnames(df) <- c("gpos","mismatch", "insertion", "deletion", "orf")
      # mut.mask <- apply(tsv, 1, function(x) return(sum(x!="")>0))
      # mut.aa <- df[mut.mask, "orf"] %>% unique()
      mut.aa <- df %>% filter(orf != "") %>% filter(mismatch != "" | insertion != "" | deletion != "") %>% pull(orf)
      mut.df <- df[df$orf %in% mut.aa,]
      # print(length(mut.aa))
      still.df <- df[! df$orf %in% mut.aa, ]
      still.df$info <- ""
      still.df$type <- ""
      # print(nrow(still.df))
      if (length(mut.aa) == 0)
        snv2.df <- still.df
      else {
        snv2.df <- mut.df %>% split(., f = factor(.$orf, levels = .$orf %>% unique())) %>% 
          mclapply(function (x) aa.mutation.core (df = x, ref.name=ref.name, ref.seq = ref.seq, orf.name = orf), mc.cores = thread.sub) %>% 
          Reduce(rbind, .) %>% rbind(still.df) %>%  arrange(gpos) 
      }
      return(list(info = snv2.df$info, type = snv2.df$type))
    }, mc.cores = thread.sub)
    
    snv2.vec <- Reduce(function(x, y) {
      paste0(x ," ; ", y)  %>% 
        sub(" *; *$", "",.) %>% sub("^ *; *", "", .)
    }, 
    lapply(vecs.list, function(x) x[["info"]]))
    type.vec <- Reduce(function(x, y) mut.type.merge(x, y, hier=hier.df), 
                       lapply(vecs.list, function(x) x[["type"]]))
    
    noncoding <- apply(ref.orf.table[, orfs], 1, function(x) sum (x != "")) == 0
    noncoding.df <- noncoding.snv2(tsv = tsv,mask = noncoding, ref.name = ref.name, ref.seq = ref.seq)
    snv2.vec[noncoding] <- noncoding.df$info[noncoding]
    type.vec[noncoding] <- noncoding.df$type[noncoding]
    snv1.vec <- snv1.vec.gen(tsv = tsv)
    if (prep$seq.begin > 1) {
      snv2.vec[1:prep$seq.begin] <- "un_sequenced"
      type.vec[1:prep$seq.begin] <- "un_sequenced"
    }
    if (prep$seq.end < nrow(tsv)) {
      snv2.vec[prep$seq.end:nrow(tsv)] <- "un_sequenced"
      type.vec[prep$seq.end:nrow(tsv)] <- "un_sequenced"
    }
    snv2.vec[prep$n.mask] <- "N_mask"
    type.vec[prep$n.mask] <- "N_mask"
    
    snv2.vec[prep$del.mask] <- "deletion_mask"
    type.vec[prep$del.mask] <- "deletion_mask"
    
    # one more line is intentionally added to avoid producing files with 0 mutations, which tend to
    ##mess up my pipeline
    out.df <- data.frame(ref.name = ref.name, left = 0:(nrow(tsv)), right = 1:(nrow(tsv)+1),
                         type = type.vec %>% c("un_sequenced"),
                         snv1 = snv1.vec %>% c(""),info = snv2.vec %>% c("un_sequenced"))
    
    out.df <- out.df %>% filter(type != "")
    # return(out.df)
    out.df <- collapse.bed.fanc(out.df, bedtools.path = bedtools.path) %>% suppressMessages()
    
    if (!is.null(out.snv2)) {
      write.table(out.df, out.snv2, col.names = F, row.names = F, quote = F, sep = "\t")
      # system(paste0("/bar/cfan/scripts/bed_browser_v2.sh ", out.snv2))
    }
    return(out.df)
    
  }, mc.cores = thread.master)
  if (return.df == T)
    return(out.df.list)
  else
    return(NULL)
}



