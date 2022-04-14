install.packages('ngramr')
install.packages('profvis')

library(ngramr)
library(jsonlite)
library(dplyr)
library(readr)
library(profvis)
library(utils)

######################################################
# Update directory to local GitHub repository folder #
######################################################

# Load .json from repository #
dict <- fromJSON("wordle-dict.json")
# Looking at list of accepted words #
dict_acc <- dict[2]
# Covert .json to dataframe #
acc_data <- as.data.frame(dict_acc)

# Create column of "NA" in answer dataframe to record frequencies #
acc_data['freq'] <- NA

# Define start and end year for ngram #
start <- 1990
end <- 2000

# Create loop to determine frequency for accepted words using ngram #
iterations <- c(33:43) # Update this to run different sets of 50 words at a time #
for ( i in iterations) {
var <- i
lower <- 1+(50*var)
upper <- 50+(50*var)
range <- c(lower:upper)
for (val in range) {
i <- ngram(acc_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
acc_data[val,2] <- i_freq
}
write.table(acc_data[range,], file="accept_freqs.txt", append=TRUE, quote=FALSE, sep=" ", col.names=FALSE)
pause(600) # Pauses for 10 minutes #
}
