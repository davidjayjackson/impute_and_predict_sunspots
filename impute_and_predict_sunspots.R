## Importing packages

# Import daily sunspot data from http://sidc.be
s <-fread("http://sidc.be/silso/DATA/SN_d_tot_V2.0.csv")
colnames(s) <- c("Year","Month","Day", "Fdate","Spots", "Sd","Obs" ,"Defin"  )
s
# Create YYYY-MM-DD field
s$Ymd <- as.Date(paste(s$Year, s$Month, s$Day, sep = "-"))
s$Spots1 <- ifelse(s$Spots == -1,NA,s$Spots)
s$Sd1 <- ifelse(s$Sd == -1,NA,s$Sd)
s$Defin1 <- ifelse(s$Defin == -1,NA,s$Defin)
# Names: 'Year' 'Month' 'Day' 'Fdate' 'Spots' 'Sd' 'Obs' 'Defin' 'Ymd' 'Spots1' 'Sd1'
solar <-s
solar <- solar[,.(Ymd,Year,Defin,Spots,Sd,Defin1,Spots1,Sd1)]
head(solar)
# Impute missing numbers for Defin,Spots and SD for period between 1849 and 2019
impute <- mice(solar[,7:8],m=3,seed=123)
impute$imp$Spots1
data <-complete(impute)

data1 <- as.data.table(data)
solar1 <- cbind(solar,data1)
# solar[,.(Year,Ymd,YesNO,Obs1,)]
data1
db <- dbConnect(SQLite(), dbname="C:\Users\davidjayjackson\Documents\GitHub\db\solar.sqlite3")
dbWriteTable(db, "DAILY", DAILY,overwrite=TRUE)
