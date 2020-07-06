
#####################
#the helper functions
#####################

triple.aa <- function(input.aa) {
  output.aa <- input.aa %>% as.character() %>% 
    lapply(rep, 3) %>% unlist() 
  if (is.numeric(input.aa))
    output.aa <- as.numeric(output.aa)
  return(output.aa)
}


map.aa <- function(input.vec, start.gpos, stop.gpos, start.aapos, stop.aapos, aa, add.stop.codon) {
  aa <- aa[start.aapos:stop.aapos]
  if (add.stop.codon == T)
    aa <- c(aa, "*")
  aa.pos <- ((1:length(aa))+start.aapos-1) %>% triple.aa()
  aa.triple <- aa %>% triple.aa()
  input.vec[start.gpos:stop.gpos] <- paste0(aa.triple, aa.pos)
  return(input.vec)
}

map.aa.from.gb <- function(input.vec, gb.obj, feature) {
  feat <-gb.obj$FEATURES[[feature]] 
  aa <- feat$translation[1] %>% strsplit("") %>% unlist()
  start.gpos <- feat$start
  stop.gpos <- feat$end
  
  if (length(start.gpos) !=1)
    stop(paste0("halted: start.gpos should be one position, but turned out to be ", length(start.gpos)),
         "\nMaybe it's a ribosome slippage?")
  
  output.vec <- map.aa(input.vec = input.vec, start.gpos = start.gpos, stop.gpos = stop.gpos, 
                       start.aapos = 1, stop.aapos = length(aa), aa = aa, add.stop.codon = T)
  return(output.vec)
}

aa.mutation.core <- function(df, ref.name, ref.seq, orf.name) {
  # the required format of df: columns: c("gpos","mismatch", "insertion", "deletion", "orf"). each row is a genome pos.
  # when df is passed to this function, orf should be identical between rows. 
  # the df should be 3 rows generally (the length of a codon). However, when orf is "" or when there are 
  ##noncanonical things like slippage going on, the length could vary.
  if (length(unique(df$orf)) != 1) 
    stop("when passed to aa.mutation.core, orf must be present and identical")
  codon <- unique(df$orf)
  df$info <- ""
  df$type <- ""
  
  if ((codon == "") || (sum(df[,c("mismatch", "insertion", "deletion")] != "") == 0))
    return(df) 
  df <- arrange(df, gpos)
  ref.nuc <- ref.seq[sort(df$gpos)] %>% paste0(collapse = "")
  strain.nuc <- seq.from.tsv(df, ref.nuc) %>% paste0(collapse = "")
  
  ref.aa <- gsub("\\d*", "", codon)
  translate.res <- translate.codon(nuc = strain.nuc,  aa.orig = ref.aa)
  strain.aa <- translate.res$aa
  type <- translate.res$type
  
  info <- paste0(ref.name, ":", df$gpos[1]-1, "-", df$gpos[nrow(df)], " | ", 
                 orf.name, ":", codon, " | ",
                 ref.nuc, " > ", strain.nuc, " | ", 
                 ref.aa, " > ", strain.aa, " | " ,type)
  info.pos <- apply(df[, c("mismatch", "insertion", "deletion")], 1, function(x) sum(x!=""))
  info.pos <- info.pos > 0
  df$info[info.pos] <- info
  df$type[info.pos] <- type
  return(df)
}

seq.from.tsv <- function(df, ref) {
  # df must contain these columns: c("mismatch", "insertion", "deletion")
  # nrow(df) must equal to the length of ref (a vector of DNA seq)
  # each row correspond to 1 element in ref. make sure the correspondance is correct!!
  if (nchar(ref[1]) > 1)
    ref <- strsplit(ref, "") %>% unlist()
  if (nrow(df) != length(ref))
    stop(paste0("in seq.fram.tsv, the number of rows in df (", nrow(df), 
                ") does not equal the length of ref (", length(ref), ")"))
  df <- select(df, mismatch, insertion, deletion)
  strain <- ref
  for (i in 1:nrow(df)) {
    if (df[i, "deletion"] != "")
      strain[i] <- ""
    else {
      if (df[i, "mismatch"] != "")
        strain[i] <- df[i, "mismatch"]
    }
    strain[i] <- paste0(df[i, "insertion"], strain[i])
  }
  return(strain)
}

translate.codon <- function(nuc, aa.orig) {
  #out <- list(aa = "", type = NULL)
  aa <- ""
  type <- ""
  if (nchar(nuc[1]) > 1)
    nuc <- strsplit(nuc, "") %>% unlist()
  if (length(nuc) >=3)
    aa <- seqinr::translate(nuc)
  
  if (length(nuc) %% 3 != 0 )
    type <- "frameshift"
  else {
    if (length(nuc) == 0)
      type <- "AA_deletion"
    else {
      if (length(nuc) > 3)
        type <- "AA_insertion"
      else {
        # now length(nuc) == 3
        if (aa == aa.orig)
          type <- "silent"
        else type <- "missense"
      }
    }
  }
  aa <- paste0(aa, collapse = "")
  return(list(aa = aa, type = type))
}

mut.type.merge <- function(x, y, hier) {
  if (length(x) != length(y))
    stop(paste0("the length of x: ", length(x), " does not equal to the length of y: ", length(y)))
  res <- rep("", length(x))
  empty <- x=="" & y==""
  
  # x[x==""] <- "match"
  # y[y==""] <- "match"
  res[!empty] <- mapply(function(x,y) {
    if_else((hier %>% dplyr::filter(type == x) %>% dplyr::pull(hier)) < (hier %>% dplyr::filter(type == y) %>% dplyr::pull(hier)),
            x, y)
  }, x[!empty], y[!empty], SIMPLIFY = F) %>% unlist()
  # res[res=="match"] <- ""
  names(res) <- ""
  return(res)
}

noncoding.snv2 <- function(tsv, mask=NULL, ref.name, ref.seq) {
  df <- tsv
  if (!"info" %in% colnames(df))
    df$info <- ""
  if (!"type" %in% colnames(df))
    df$type <- ""
  if (!"gpos" %in% colnames(df))
    df <- add.column.fanc(df, data.frame(gpos = 1:nrow(df)), pos=1)
  
  
  
  to.convert <- mask & apply(df[, c("mismatch", "insertion", "deletion")], 1, function(x) return(sum (x != "") > 0 ))
  if (sum(to.convert) ==0)
    return(df)
  
  df[to.convert, "info"] <- paste0(ref.name, ":", df[to.convert, "gpos"]-1, "-",df[to.convert, "gpos"], " | ",
                                   "ORF:noncoding", " | ",
                                   ref.seq[to.convert], " > ", seq.from.tsv(df = df[to.convert, ], ref = ref.seq[to.convert]))
  df[to.convert, "type"] <- apply(df[to.convert, c("mismatch", "insertion", "deletion")], 1, function(x) {
    if (x[2] != "")
      return("noncoding_insertion")
    if (x[3] != "")
      return("noncoding_deletion")
    if (x[1] != "")
      return("noncoding_mismatch")
    return("")
  })
  
  df[to.convert, "info"] <- paste0(df[to.convert, "info"], " | ",df[to.convert, "type"] )
  return(df)
}

collapse.bed.fanc <- function(in.bed, bedtools.path, outfile = NULL) {
  if (is.character(in.bed))
    in.bed <- read.table(in.bed, header = F, quote = "", sep = "\t", as.is = T)
  df <- in.bed
  col.n.ori <- colnames(df)
  n.col <- ncol(df)
  if (n.col < 4)
    stop("collapse.bed.fanc requires at least 4 columns")
  colnames(df) <- paste0("V", 1:n.col)
  df$sep <- Reduce(function(x,y) paste0(x, "@", y), as.list(df[,4:n.col]))
  
  # print(df)
  df.collapsed <- df %>% select(V1, V2, V3, sep) %>% split(., f= factor(.$sep, levels = unique(.$sep))) %>% 
    lapply(function(x) {
      res <- find.contigs.fanc.2(x, bedtools.path = bedtools.path)
      res$sep <- x$sep[1]
      return(res)
    }) %>% Reduce(rbind, .) %>% arrange(V1, V2)
  
  res <- df.collapsed %>% tidyr::separate(sep, col.n.ori[4:length(col.n.ori)], "@")
  colnames(res) <- col.n.ori
  return(res)
}

find.contigs.fanc.2 <- function(bed, bedtools.path) {
  # only chr, left, right are considered. use collapse.bed.fanc() if you don't want to collapse rows with 
  ##different annotation columns (columns starting from the 4th column)
  # PATH <- Sys.getenv("PATH")
  # PATH <- paste0(PATH, ":", bedtools.path)
  # Sys.setenv(PATH = PATH)
  col.n.ori <- colnames(bed)[1:3]
  bed <- bed[,1:3]
  if (sum(bed[, 2] >=bed[,3]) > 0)
    stop("column 3 of bed must be larger than column 2")
  merged <- bedr::bedr.merge.region(bed, check.chr = F, verbose = F, check.sort = F)
  colnames(merged) <- col.n.ori
  rownames(merged) <- NULL
  return(merged)
}
snv1.vec.gen <- function(tsv) {
  if (is.character(tsv))
    tsv <- read.table(tsv, as.is = T, sep = "\t", quote = "", header = T)
  if (!identical(colnames(tsv), c("mismatch", "insertion", "deletion")))
    stop(paste0("the columns of tsv: ",colnames(tsv), " does not match expection"))
  
  res <- apply(tsv,1, function(x) {
    if (x[2] != "")
      return(paste0("insertion: ", x[2]))
    if (x[3] != "")
      return(paste0("deletion: ", x[3]))
    if (x[1] != "")
      return(paste0("mismatch: ", x[1]))
    return("")
  })
}

add.column.fanc <- function(df1, df2, pos=NULL, before=NULL, after=NULL) {
  # priority: pos, before, and after. If none of them specified: append at the end.
  if(sum(colnames(df2) %in% colnames(df1)) > 0)
    stop("overlapping names between df2 and df1")
  
  if (!is.null(pos)) {
    j <- cbind(df1, df2)
    cnames <- append(colnames(df1), values = colnames(df2), after = pos-1)
    j <- j[,cnames]
    return(j)
  } else if (!is.null(before)) {
    j <- cbind(df1, df2)
    pos <- which(colnames(df1) == before)
    cnames <- append(colnames(df1), values = colnames(df2), after = pos-1)
    j <- j[,cnames]
    return(j)
  } else if (!is.null(after)) {
    j <- cbind(df1, df2)
    pos <- which(colnames(df1) == after) + 1
    cnames <- append(colnames(df1), values = colnames(df2), after = pos-1)
    j <- j[,cnames]
    return(j)
  } else {
    j <- cbind(df1, df2)
    return(j)
  }
  
}


tsv.prep <- function(tsv, min.contig.head.tail = 0, min.contig.n.mask = 0, min.contig.del.mask = 0,
                     n.mask = F, del.mask = F, max.gap.n.mask=0, max.gap.del.mask=0) {
  tsv <- read.table(tsv, as.is = T, header = T, sep = "\t", quote = "", colClasses = "character")
  tsv[is.na(tsv)] <- ""
  #print(tsv %>% head())
  tsv <- tsv[1:(nrow(tsv)-1),]
  if (min.contig.head.tail > 0)
    res <- no.head.tail(tsv, min.contig = min.contig.head.tail, return.pos = T)
  else
    res <- list(tsv= tsv, seq.begin = 1, seq.end = nrow(tsv))
  if (n.mask == T) {
    mask.res <- n.mask(align.tsv = res$tsv,return.n.mask = T, 
                       max.gap = max.gap.n.mask, min.contig = min.contig.n.mask)
    res$tsv <- mask.res$tsv
    res$n.mask <- mask.res$n.mask
  } else {
    res$n.mask <- integer()
  }
  if (del.mask == T) {
    mask.res <- del.mask(align.tsv = res$tsv,return.del.mask = T, 
                         max.gap = max.gap.del.mask, min.contig = min.contig.del.mask)
    res$tsv <- mask.res$tsv
    res$del.mask <- mask.res$del.mask
  } else {
    res$del.mask <- integer()
  }
  
  return(res)
}

n.mask <- function(align.tsv, max.gap, min.contig, return.n.mask = F) {
  n.mask <- which(align.tsv$mismatch == "N")
  # # print(n.mask)
  # n.mask.ext <- lapply(-ext:ext, function(i) return(n.mask + i)) %>% Reduce(c, .) %>% unique()
  # n.mask.ext <- n.mask.ext[n.mask.ext <= nrow(align.tsv) & n.mask.ext > 0]
  # align.tsv[n.mask.ext, ] <- data.frame(mismatch = "", insertion = "", deletion = "")
  # if (return.mask == T)
  #   return(list(tsv= align.tsv, n.mask = n.mask.ext))
  if (length(n.mask) > 0) {
    n.mask.contig <- find.contigs.vec(num.vec = n.mask, max.gap = max.gap) %>% filter(right - left >= min.contig) %>% 
      select(left, right) %>% apply(1, function(x) return(x[1]:x[2])) %>% unlist() %>% sort() %>% unique()
  } else {
    n.mask.contig <- n.mask
  }
  
  align.tsv[n.mask.contig, ] <- data.frame(mismatch = "", insertion = "", deletion = "")
  if (return.n.mask == T)
    return(list(tsv= align.tsv, n.mask = n.mask.contig))
  else
    return(align.tsv)
}



del.mask <- function(align.tsv, max.gap, min.contig, return.del.mask = F) {
  del.mask <- which(align.tsv$deletion != "")
  # # print(del.mask)
  # del.mask.ext <- lapply(-ext:ext, function(i) return(del.mask + i)) %>% Reduce(c, .) %>% unique()
  # del.mask.ext <- del.mask.ext[del.mask.ext <= nrow(align.tsv) & del.mask.ext > 0]
  # align.tsv[del.mask.ext, ] <- data.frame(mismatch = "", insertion = "", deletion = "")
  # if (returdel.mask == T)
  #   return(list(tsv= align.tsv, del.mask = del.mask.ext))
  if (length(del.mask) > 0) {
    del.mask.contig <- find.contigs.vec(num.vec = del.mask, max.gap = max.gap) %>% filter(right - left >= min.contig) %>% 
      select(left, right) %>% apply(1, function(x) return(x[1]:x[2])) %>% unlist() %>% sort() %>% unique()
  } else {
    del.mask.contig <- del.mask
  }
  
  align.tsv[del.mask.contig, ] <- data.frame(mismatch = "", insertion = "", deletion = "")
  if (return.del.mask == T)
    return(list(tsv= align.tsv, del.mask = del.mask.contig))
  else
    return(align.tsv)
}

no.head.tail <- function(align.tsv, min.contig, return.pos = F) {
  seq.rle <- (align.tsv$deletion == "") %>% Rle()
  #print(seq.rle)
  seq.df <- data.frame(length = seq.rle@lengths, value = seq.rle@values)
  seq.df$cumsum <- cumsum(seq.df$length)
  seq.df$index <- (seq.df$cumsum[-length(seq.df$cumsum)] + 1) %>% c(1,.)
  seq.df <- seq.df %>% filter(value == T, length >= min.contig)
  #print(head(seq.df))
  seq.begin <- seq.df[1, "index"]
  seq.end <- seq.df[nrow(seq.df), "cumsum"]
  if(seq.begin > 1) {
    align.tsv[1:(seq.begin-1),"deletion"] <- ""
    align.tsv[1:(seq.begin-1),"insertion"] <- "" # added this line on 6/4/20
    # align.tsv[1:(seq.begin-1),"mismatch"] <- "N"
    align.tsv[1:(seq.begin-1),"mismatch"] <- "" # changed the behavior from N to "". 6/13/20
  }
  if (seq.end < nrow(align.tsv)) {
    align.tsv[(seq.end+1):(nrow(align.tsv)) ,"deletion"] <- ""
    align.tsv[(seq.end+1):(nrow(align.tsv)) ,"insertion"] <- "" # added this line on 6/4/20
    # align.tsv[(seq.end+1):(nrow(align.tsv)) ,"mismatch"] <- "N"
    align.tsv[(seq.end+1):(nrow(align.tsv)) ,"mismatch"] <- "" # changed the behavior from N to "". 6/13/20
  }
  if (return.pos == T)
    return(list(tsv= align.tsv, seq.begin = seq.begin, seq.end = seq.end))
  else return(align.tsv)
}

find.contigs.vec <- function(num.vec, max.gap=0) {
  vec <- num.vec %>% sort()
  vec.shift <- c(vec[-1], max(vec) + max.gap + 2)
  vec.logi <- (vec.shift -vec ) <= 1+max.gap
  seq.rle <- vec.logi %>% Rle()
  seq.df <- data.frame(length = seq.rle@lengths, value = seq.rle@values)
  seq.df$cumsum <- cumsum(seq.df$length)
  seq.df$index.left <- (seq.df$cumsum[-length(seq.df$cumsum)] + 1) %>% c(1,.)
  seq.df$index.right <- seq.df$index.left + seq.df$length - 1
  seq.df$left <- vec[seq.df$index.left]
  seq.df$right <- vec[seq.df$index.right] + 1
  seq.df$length <- seq.df$length + 1
  return(seq.df %>% filter(value == T) %>% select(left, right, length))
}
