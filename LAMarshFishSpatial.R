#Removal estimates for fish species

library(FSA)
library(openxlsx)
library(tibble)
library(here)

setwd(here())

# Load "FishData.xlsx"
# Create a loop that will go through each row in the "FishData.xlsx" and calculate this function:
# removal(data = row vector(J-S or Pass1-Pass10), method = "Burnham", just.ests = TRUE), results will go in the total column in the "FishData.xlsx"

## Import Fish Data
fish_data <- read.xlsx("FishData.xlsx")
total_ests <- data.frame(No = 0.0, No.se = 0.0, No.LCI = 0.0, No.UCI = 0.0, p = 0.0, p.se = 0.0, p.LCI = 0.0, p.UCI = 0.0)

# Loop through fish_data and convert Pass columns to vector in order to work
# with FSA::removal which requires catch be a vector. Assign to Totals column in
# FishData and also add additional estimates to the total_ests dataframe.

for (i in 1:nrow(fish_data)) {
  tmp <- unname(unlist(fish_data[i,10:19]))
  ests <- removal(tmp, method = "Burnham", just.ests = TRUE)
  fish_data$Total[i] <- ests
  total_ests[i,] <- add_row(as_tibble(as.list(ests)))
}

# This gives us two dataframes, one with fish_data that has totals based off of
# the estimates from removal function and an accompanying total_ests dataframe
# that houses the additional estimates from the removal function. These can be
# joined by rownumber. NAs have been converted to zeros before the file is
# written back to an xlsx.

fish_data$Total[is.na(fish_data$Total)] <- 0
write.xlsx(fish_data, file = "FishDataUpdated.xlsx")
