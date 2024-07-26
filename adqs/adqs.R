# Create RDF for ADQS
# Jeffrey Long
# Copyright 2024 Jeffrey Long

library(random.cdisc.data)
ADSL <- radsl(seed = 1)
ADQS <- radqs(ADSL, seed = 1)
ADQS <- ADQS[1:100,]
ADQS <- ADQS[c('STUDYID', 'USUBJID', 'QSSEQ', 'BMRKR2', 'PARAM', 'ADY', 'PCHG')]
ADQS$IDBMRKR <- paste(ADQS$STUDYID, ADQS$USUBJID, ADQS$BMRKR2, sep="_")
ADQS[order(ADQS$PCHG), ]
ADQS <- ADQS[c('IDBMRKR', 'PARAM', 'ADY', 'PCHG')]
# Find unique combinations of IDBMRKR and PARAMs
id_question <- unique(ADQS[,c('IDBMRKR', 'PARAM')]) # first set of relationships
ADQS$PCHG <- trunc(ADQS$PCHG)
question_pchg <- ADQS[c('PARAM', 'PCHG')]

# Issues: it did not like tabs, parens in subject, predicate, objects.
# trucated values were repeated occassionally and formed nodes.
# some real data could be more interesting.

