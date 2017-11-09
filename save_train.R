
# Check big sampled data = 40%


source("main.R")

#default weights

w1<-.00000001
w2<- .01
w3<-.6


#default thresholds

t1<-0 
t2<-2.664e-06
t3<-2.907e-06
t4<-3.182e-06


taining.dir<-"./clean_data/training/"


train.data<-train(taining.dir,
                  w1,
                  w2,
                  w3,
                  t1,
                  t2,
                  t3,
                  t4)

saveRDS(train.data, file="training_data_10.RDS")

rm(train.data)



