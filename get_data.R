
dir.create("raw_data")
dir.create("clean_data")
setwd("raw_data")

#url="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
#download.file(url=url, destfile = "Coursera-SwiftKey.zip")
#unzip("Coursera-SwiftKey.zip")

download.file(url="https://www.frontgatemedia.com/new/wp-content/uploads/2014/03/Terms-to-Block.csv", destfile = "Terms-to-Block.csv")
setwd("..")


