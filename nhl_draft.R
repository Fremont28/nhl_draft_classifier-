#6/21/18 
library(plyr)
library(dplyr)
library(ggplot2)

#nhl draft 1995 draft through 2017 draft (hockey reference)
draft=read.csv("nhl_draft.csv")

#replace nan with zeros 
na_zero=function(x){
  x[is.na(x)]<-0
  return(x)
}
draft1=na_zero(draft)

#year since draft 
draft1$since_draft=draft1$To-draft1$Year

#games played per year since the player was drafted
draft1$games_since_draft=draft1$GP/draft1$since_draft

#point per year since the draft
draft1$points_since_draft=draft1$PTS/draft1$since_draft

#mean games played per year since being drafted
draft1$Round=as.factor(draft1$Round)

#average draft round metrics 
round_metrics_all=ddply(draft1,.(Round),summarize,avg_gp=mean(games_since_draft),avg_pts=mean(points_since_draft))

#played at least one game in the nhl 
draft2=subset(draft1,GP>0)
round_metrics_sub=ddply(draft2,.(Round),summarize,avg_gp=mean(games_since_draft),avg_pts=mean(points_since_draft))

#summary statistics
summary(draft2$games_since_draft) #q1=3.76, median=16.8, q3=41.33
summary(draft2$points_since_draft) #q1=0.3636 median=8.835 q3=12.27

nueva_draft=read.csv("nhl_draft2.csv")
dim(nueva_draft) #2251 eligible draft picks 

nueva_draft$gp_class=as.factor(nueva_draft$gp_class) 
nueva_draft$points_class=as.factor(nueva_draft$points_class)

#games played probability for draft picks
#train and test data
sample_size=floor(0.7*nrow(nueva_draft))
training=sample(seq_len(nrow(nueva_draft)),size=sample_size)
train=nueva_draft[training,]
test=nueva_draft[-training,]

#multinomial classifier 
library(nnet)
multinomial_gp=multinom(gp_class~Round,data=nueva_draft)
summary(multinomial_gp)

#predict with the test draft pick data
predict_gp_class=predict(multinomial_gp,test)

#confusion matrix/classification error
table(predict_gp_class,test$gp_class)

#probabilities 
probs_gp_class=predict(multinomial_gp,nueva_draft,"probs")
dim(probs_gp_class)

#combine probabilities with test data
test_combine=cbind(nueva_draft,probs_gp_class)

colnames(test_combine)[26]="elite"
colnames(test_combine)[27]="good"
colnames(test_combine)[28]="average"
colnames(test_combine)[29]="poor"

round_gp_prob=ddply(test_combine,.(Round),summarize,elite=mean(elite),good=mean(good),
                    average=mean(average),poor=mean(poor))
round_gp_prob 

#count games played by round
nueva_draft$Round=as.factor(nueva_draft$Round)
class_count=table(nueva_draft$gp_class)
class_counts 

#actual games played tiers 
library(dplyr)
group_class_rounds<-nueva_draft %>% 
  group_by(Round,gp_class) %>%
  summarise(n=n())
group_class_rounds

#reshape data
group_class1=as.data.frame(group_class_rounds)
group_class2=reshape(group_class1,idvar="Round",timevar="gp_class",direction="wide")
group_class2$elite=group_class2$n.1/(group_class2$n.1+group_class2$n.2+group_class2$n.3+group_class2$n.4)
group_class2$good=group_class2$n.2/(group_class2$n.1+group_class2$n.2+group_class2$n.3+group_class2$n.4)
group_class2$average=group_class2$n.3/(group_class2$n.1+group_class2$n.2+group_class2$n.3+group_class2$n.4)
group_class2$poor=group_class2$n.4/(group_class2$n.1+group_class2$n.2+group_class2$n.3+group_class2$n.4)
group_class2

#points vs. games played (outlier analysis)*****
par(mfrow=c(1, 2))
plot(nueva_draft$games_since_draft, nueva_draft$points_since_draft, xlim=c(0, 28), ylim=c(0, 230), main="With Outliers", xlab="Games Played", ylab="Points", pch="*", col="red", cex=2)
abline(lm(nueva_draft$points_since_draft ~ nueva_draft$games_since_draft, data=nueva_draft), col="blue", lwd=3, lty=2)

#cook's distance 
model_games=lm(points_since_draft~games_since_draft,data=nueva_draft)
cooks_distance=cooks.distance(model_games)

#influential points (draft picks with cook's distance 8 times above the mean cook distance value)
influential <- as.numeric(names(cooks_distance)[(cooks_distance > 8*mean(cooks_distance, na.rm=T))])  # influential row numbers
outliers=nueva_draft[influential, ]

#extreme players
outliers_mejor=subset(outliers,points_since_draft<8.83 & games_since_draft<16.8)
outliers_mejor['Player']






