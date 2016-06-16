getwd()
setwd('~/Desktop/variant_tables/')
positions <- read.table('tool_position_annotation_count.txt', header = TRUE)
# Histogram of number of positions annotated by each tool
# Need to fix the frequency because there are 37 positions annotated by 1 tool and you can't see that
hist(positions$annotated_tools, main="Number of tools that annotate a position", col = "black")

setwd('~/Desktop/')
count_tools <- read.table('tool_count_position_annotate.txt', header = TRUE)
# Same as one above
hist(count_tools$annotated_tools)
count_exclude_VAT <- read.table('count_tools_exclude_VAT.txt', header = TRUE)
hist(count_exclude_VAT$annotated_tools, col = 'black', labels = TRUE)

# Make aggregate treemap
setwd('~/Desktop/variant_tables/trimmed_files/treemap_files/')
data <- read.csv('tool_effects_treemap.txt', sep = "\t", header = TRUE)
install.packages("treemap")
library(treemap)
treemap(data, index = c('tool', 'effect'), vSize = 'count')

setwd('~/Desktop/variant_tables/trimmed_files/treemap_files/')
data <- read.csv('adjusted_trimmed_variant_tables_treemap.txt', sep = "\t", header = TRUE)
# Original treemap
treemap(data, index = c("tool", "effect"), vSize = "count")

# Treemap with count displayed under effect term
data$label <- paste(data$effect, data$count, sep = "\n")
treemap(data, index = c("tool", "label"), vSize = "count")

# Make individual treemaps
# These files are derived from adjusted_trimmed_variant_tables_treemap.txt
setwd('~/Desktop/variant_tables/trimmed_files/treemap_files/')
# ANNOVAR
annovar <- read.csv('annovar_tool_effects_treemap.txt', sep = "\t", header = TRUE)
treemap(annovar, index = c('tool', 'effect'), vSize = 'count')
# Seattleseq
seattleseq <- read.csv('seattleseq_tool_effects_treemap.txt', sep = "\t", header = TRUE)
treemap(seattleseq, index = c('tool', 'effect'), vSize = 'count')
# snpEff
snpeff <- read.csv('snpeff_tool_effects_treemap.txt', sep = "\t", header = TRUE)
treemap(snpeff, index = c('tool', 'effect'), vSize = 'count')
# VAAST
vaast <- read.csv('vaast_tool_effects_treemap.txt', sep = "\t", header = TRUE)
treemap(vaast, index = c('tool', 'effect'), vSize = 'count')
# VAT
vat <- read.csv('vat_tool_effects_treemap.txt', sep = "\t", header = TRUE)
treemap(vat, index = c('tool', 'effect'), vSize = 'count')
# VEP
vep <- read.csv('vep_tool_effects_treemap.txt', sep = "\t", header = TRUE)
treemap(vep, index = c('tool', 'effect'), vSize = 'count')

# Practice treemaps
dat <- data.frame(letters=letters[1:26], x=1, y=runif(26)*16-4)
treemap(dat, index="letters", vSize="x", vColor="y", type="value", palette="RdYlBu")
treemap(dat, index="letters", vSize="x", vColor="y", type="value", palette="RdYlBu", range=c(-12,12), n = 9)
treemap(dat, index="letters", vSize="x", vColor="y", type="manual", palette="RdYlBu")
treemap(dat, index="letters", vSize="x", vColor="y", type="value", palette="RdYlBu", 
        mapping=c(-10, 10, 30))


treemap(dat, index="letters", vSize="x", vColor="y", type="value", palette="RdYlBu", 
        mapping=c(-10, 10, 30), range=c(-10, 30))
