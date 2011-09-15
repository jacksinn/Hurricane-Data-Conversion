si <- read.csv("C:/Users/sjackson/Desktop/dev/hurricane/delim_data/storm_info.tab",sep="\t",head=TRUE)
names(si)
plot(si$storm_num_days,si$year,xlab="Number of days in Storm",ylab="Year")
plot(si$sss,si$year,xlab="Severity of Storm",ylab="Year")

