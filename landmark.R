library(survival)
library(dynpred)

dat <- read.table("C:/data/iaso.dat",header=TRUE)
age1 <- (dat$age/100)^(-1)
 age2 <- (dat$age/100)^(-.5)
      c1 <- coxph(Surv(time/12,death)~age1+age2,data=dat)
      
sf <- survfit(c1,newdata=data.frame(age1=(20/100)^(-1),age2=(20/100)^(-.5)))

summary(sf)

sf$surv[max(which(sf$time<5.01))]


w <- 5*12
tt <- dat$time[dat$death==1]
tt <- sort(unique(c(0,tt,tt-w)))
tt <- tt[tt>=0]

tt <- 1:180
nt <- length(tt)
surv <- NULL
for(i in 1:nt){
    LMdata <- cutLM(data=dat,outcome=list(time="time",status="death"),
        LM=tt[i],horizon=tt[i]+w,covs=list(fixed="age",varying=NULL))
age1 <- (LMdata$age/100)^(-1)
 age2 <- (LMdata$age/100)^(-.5)
    LMcox <- coxph(Surv(time,death) ~age1+age2 , data=LMdata, method="breslow")
sf <- survfit(LMcox,newdata=data.frame(age1=(25/100)^(-1),age2=(25/100)^(-.5)))
surv <- c(surv,sf$surv[length(sf$surv)-1])
cat(i,"   ",sf$surv[length(sf$surv)-1],"\n")
}
plot((1:nt)/12,surv,"s",ylim=c(0,1),ylab="Survival probability",xlab="time in years")

tt <- 1:180
nt <- length(tt)
surv2 <- NULL
for(i in 1:nt){
    LMdata <- cutLM(data=dat,outcome=list(time="time",status="death"),
        LM=tt[i],horizon=tt[i]+w,covs=list(fixed="age",varying=NULL))
age1 <- (LMdata$age/100)^(-1)
 age2 <- (LMdata$age/100)^(-.5)
    LMcox <- coxph(Surv(time,death) ~age1+age2 , data=LMdata, method="breslow")
sf <- survfit(LMcox,newdata=data.frame(age1=(45/100)^(-1),age2=(45/100)^(-.5)))
surv2 <- c(surv2,sf$surv[length(sf$surv)-1])
cat(i,"   ",sf$surv[length(sf$surv)-1],"\n")
}
lines((1:nt)/12,surv,col=2,type="s")

dd <- data.frame(time=(1:nt)/12,surv25=surv,surv45=surv2)
write.table(dd,"C:/data/dd.dat",row.names=FALSE)

library(googleVis)
dd$time <- round(dd$time,2)
L1 <- gvisLineChart(dd, xvar="time", yvar=c("surv25","surv45"),
                    options=list(title = "Dynamic survival ", 
 titleTextStyle="{color:'#3182bd', fontSize:15}",
                                  vAxes="[{title:'5 year survival',
                             titleTextStyle: {color: '#3182bd'},
                             textStyle:{color: '#3182bd'},
                             textPosition: 'out', minValue:0}]",   
                                  hAxes="[{title:'years since diagnosis',
                             titleTextStyle: {color: '#3182bd'},
                             textStyle:{color: '#3182bd'},
                             textPosition: 'out'}]",
width=550, height=480                                  
                     ))                                           



plot(L1)