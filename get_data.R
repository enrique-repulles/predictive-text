dir.create("raw_data")
setwd("raw_data")
url="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(url=url, destfile = "Coursera-SwiftKey.zip")
unzip("Coursera-SwiftKey.zip")
setwd("..")
