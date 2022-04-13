install.packages('ngramr')

library(ngramr)
library(jsonlite)
library(dplyr)
library(readr)

######################################################
# Update directory to local GitHub repository folder #
######################################################

# Load .json from repository #
dict <- fromJSON("wordle-dict.json")
# Only looking at possible answers, not all accepted words #
dict_ans <- dict[1]
# Covert .json to dataframe #
ans_data <- as.data.frame(dict_ans)

# Total frequency of "word" using ngram #
#x <- ngram("word", year_start = 1990, year_end = 2000, case_ins = TRUE)
#x_freq <- sum(x[,3])
#print(x_freq)

# Create column of "NA" in answer dataframe to record frequencies #
ans_data['freq'] <- NA

# Testing updating frequency in dataframe #
#y <- ngram(ans_data[1,1], year_start = 1990, year_end = 2000, case_ins = TRUE)
#y_freq <- sum(y[,3])
#print(y_freq)
#ans_data[1,2] <- y_freq
#print(ans_data[1,])

# Define start and end year for ngram #
start <- 1990
end <- 2000

# Create loop to determine frequency for answers using ngram #
range <- c(1:2315)
for (val in range) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data)

#############################################################
# Trying smaller ranges to get around losing the connection #
#############################################################

range1 <- c(1:50)
range2 <- c(51:100)
range3 <- c(101:150)
range4 <- c(151:200)
range5 <- c(201:250)
range6 <- c(251:300)
range7 <- c(301:350)
range8 <- c(351:400)
range9 <- c(401:450)
range10 <- c(451:500)
range11 <- c(501:550)
range12 <- c(551:600)
range13 <- c(601:650)
range14 <- c(651:700)
range15 <- c(701:750)
range16 <- c(751:800)
range17 <- c(801:850)
range18 <- c(851:900)
range19 <- c(901:950)
range20 <- c(951:1000)
range21 <- c(1001:1050)
range22 <- c(1051:1100)
range23 <- c(1101:1150)
range24 <- c(1151:1200)
range25 <- c(1201:1250)
range26 <- c(1251:1300)
range27 <- c(1301:1350)
range28 <- c(1351:1400)
range29 <- c(1401:1450)
range30 <- c(1451:1500)
range31 <- c(1501:1550)
range32 <- c(1551:1600)
range33 <- c(1601:1650)
range34 <- c(1651:1700)
range35 <- c(1701:1750)
range36 <- c(1751:1800)
range37 <- c(1801:1850)
range38 <- c(1851:1900)
range39 <- c(1901:1950)
range40 <- c(1951:2000)
range41 <- c(2001:2050)
range42 <- c(2051:2100)
range43 <- c(2101:2150)
range44 <- c(2151:2200)
range45 <- c(2201:2250)
range46 <- c(2251:2300)
range47 <- c(2301:2315)


for (val in range1) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range1,])

for (val in range2) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range2,])

for (val in range3) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range3,])

for (val in range4) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range4,])

for (val in range5) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range5,])

for (val in range6) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range6,])

for (val in range7) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range7,])

for (val in range8) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range8,])

for (val in range9) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range9,])

for (val in range10) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range10,])

for (val in range11) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range11,])

for (val in range12) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range12,])

for (val in range13) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range13,])

for (val in range14) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range14,])

for (val in range15) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range15,])

for (val in range16) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range16,])

for (val in range17) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range17,])

for (val in range18) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range18,])

for (val in range19) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range19,])

for (val in range20) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range20,])

for (val in range21) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range21,])

for (val in range22) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range22,])

for (val in range23) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range23,])

for (val in range24) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range24,])

for (val in range25) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range25,])

for (val in range26) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range26,])

for (val in range27) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range27,])

for (val in range28) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range28,])

for (val in range29) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range29,])

for (val in range30) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range30,])

for (val in range31) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range31,])

for (val in range32) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range32,])

for (val in range33) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range33,])

for (val in range34) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range34,])

for (val in range35) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range35,])

for (val in range36) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range36,])

for (val in range37) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range37,])

for (val in range38) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range38,])

for (val in range39) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range39,])

for (val in range40) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range40,])

for (val in range41) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range41,])

for (val in range42) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range42,])

for (val in range43) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range43,])

for (val in range44) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range44,])

for (val in range45) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range45,])

for (val in range46) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range46,])

for (val in range47) {
i <- ngram(ans_data[val,1], year_start = start, year_end = end, case_ins = TRUE)
i_freq <- sum(i[,3])
ans_data[val,2] <- i_freq
}
print(ans_data[range47,])

print(ans_data)


