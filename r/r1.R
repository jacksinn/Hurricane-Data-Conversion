si <- read.csv("C:/Users/sjackson/Desktop/dev/hurricane/delim_data/storm_info.tab",sep="\t",head=TRUE)
names(si)
pdf("C:/Users/sjackson/Desktop/dev/hurricane/r/plots.pdf")
plot(si$storm_num_days,si$year,xlab="Number of days in Storm",ylab="Year")
plot(si$year,si$storm_num_this_year,xlab="Year",ylab="Number of Storms")
plot(si$sss,si$year,xlab="Severity of Storm",ylab="Year")
barplot(table(si$year)) #storms per year
barplot(table(si$month)) #storms per month
dev.off()
