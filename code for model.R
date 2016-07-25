#http://amunategui.github.io/binary-outcome-modeling/
# To get model info
getModelInfo()$nnet$type

library(plyr)

library(readxl)
nbp <- read_excel("Z:/Ferguson 13 march/other assignment/DS/NBP Prediction/Data/classification.xlsx")
#Get complete cases

nbp <- na.omit(nbp)

nbp <- nbp[c(-3)]
library(RSNNS)

#Normalize variable which are numeric 
normailze <- as.data.frame(lapply(nbp[c(10,13,14)],normalizeData))
#Remove unwanted columnss 
nbp <- nbp[-c(3,10,12,13)]


#Make the data frame of classification that is the response variable
response <- as.data.frame(nbp$Classification)
colnames(response)[1] <- "classification"
#Remove the reponse variable from the NBP data set
nbp <- nbp[c(-11)]

nbp1 <- as.data.frame(lapply(nbp[c(1:7,9)],as.factor))
nbp1 <- as.data.frame(lapply(nbp1,tolower))
nbp1 <- as.data.frame(lapply(nbp1,as.character))
nbp1 <- as.data.frame(lapply(nbp1,trimws))


nbp <- cbind(nbp1,nbp[c(8,10,11,12)])


nbp$InstallmentType <- mapvalues(nbp$InstallmentType,c("0", "1","annual","annual clean up",    
                                                       "annulaly","gradually","haf yearly","hahf yearly",
                                                       "hahf yeraly","half-yearly","half yearly","halfyearly",         
                                                       "lum sum","lump-sum","lump  sum","lump sum",          
                                                       "lumpsum","lumsum","lupsum","monthely",           
                                                       "monthly","quarterly","quaterly","yearly",             
                                                       "yearly installments", "yeraly"),c("NA","NA","annually",
                                                                                          "annually","annually","annually","half-yearly",
                                                                                          "half-yearly","half-yearly","half-yearly","half-yearly",
                                                                                          "half-yearly","lumpsum","lumpsum","lumpsum","lumpsum","lumpsum",
                                                                                          "lumpsum","lumpsum","monthly","monthly","quarterly","quarterly",
                                                                                          "annually","annually","annually"))

nbp$SubProduct <-lapply(nbp$SubProduct,as.character)
nbp$SubProduct <- tolower(nbp$SubProduct)
nbp$SubProduct <- mapvalues(nbp$SubProduct,c("sme","commercial trade bills"),c("small enterprise","trade bills"))

nbp$Segment <- tolower(nbp$Segment)
nbp$Segment <- trimws(nbp$Segment)
nbp$Segment <- mapvalues(nbp$Segment,c("agriculture finance a/c.","chemicals","constructin company","garments/hoisery","general traders/retailers",
                                       "individual","oil gas & petroleum refining","oil, gas & petroleum refining",
                                       "pharmacetual","p.m self employment scheme","plastic industry & products",
                                       "real estate & construction","leather products & shoes","textiel composite",
                                       "textile compsite","textile","textle","textile weaving","transport"),
                         c("agri business/agriculture","chemicals/pharma","construction / real estate","garments",
                           "general trader","individuals","oil refinery","oil refinery","chemicals/pharma",
                           "pm self employment scheme","plastic products","construction / real estate",
                           "shoes & leather products","textile composite","textile composite","textile composite",
                           "textile composite","textile spining/weaving","transportation services"))

nbp$Segment <- as.factor(nbp$Segment)           


nbp$Purpose <- tolower(nbp$Purpose)
nbp$Purpose <- trimws(nbp$Purpose)
nbp$Purpose <- mapvalues(nbp$Purpose,c("export financing scheme ii","fixed investment",
                                       "import financing scheme ii","purcahse of motor car"),
                         c("export finance scheme","fixed investments","import financing",
                           "purchase of motor car"))
nbp$Purpose <- as.factor(nbp$Purpose)



nbp$series <- matrix(c(1:8745),ncol = 1,nrow = 8745)
response$series <- matrix(c(1:8745),ncol = 1,nrow = 8745)

#cut provision variable into 8 quantiles to make them into categorical 
#variable
library(Hmisc)
nbp$Provision <- cut2(nbp$Provision, g=8)
nbp$Provision <- mapvalues(nbp$Provision,c("0.00000","[0.00015,3.04e-02)","[0.03041,1.05e-01)",
                                           "[0.10500,2.50e-01)","[0.25006,4.71e-01)",
                                           "[0.47100,2.50e+00)","[2.49800,7.62e+02]"),
                           c("1","2","3","4","5","6","7"))

nbp$Provision <- as.factor(nbp$Provision)


#cut variable total number of into into two quartiles to make them into
#categorical variable
nbp$TotalAc <- as.numeric(nbp$TotalAc)
nbp$TotalAc <- cut2(nbp$TotalAc,g = 2)
nbp$TotalAc <- mapvalues(nbp$TotalAc,c("[0, 2)","[2,61]"),c("1","2"))
nbp <- nbp[-c(13)]
nbp <- cbind(nbp,response[,1])
colnames(nbp)[13] <- "classification"
nbp$classification <- mapvalues(nbp$classification,c("Loss"),c("LOSS"))
nbp<-   subset(nbp,InstallmentType!="NA")
nbp <- subset(nbp,Purpose!=2.781)



nbp$SubProduct <- as.factor(nbp$SubProduct)
nbp$Performa <- as.factor(nbp$Performa)
nbp$ClassPercent <- as.factor(nbp$ClassPercent)
nbp2 <- nbp[nbp$classification != "LOSS",]
nbp3 <- nbp[nbp$classification == "LOSS",]
nbp3 <- nbp3[1:2500,]
nbp <- rbind(nbp2, nbp3) 
nbp$Province <- as.numeric(as.character(nbp$Province))
nbp <- nbp[nbp$Province <= 4,]

nbp$Province <- mapvalues(nbp$Province, c(1,3,4), c("Punjab", "Sindh", "KPK"))


library(caret)
splitIndex <- createDataPartition(nbp[,13], p = .75, list = FALSE, times = 1)
trainDF <- nbp[ splitIndex,]
testDF  <- nbp[-splitIndex,]

library(doParallel)
registerDoParallel(4)
model <- train(x = trainDF[,-13], 
                      y = trainDF$classification,
                      method = "nnet")
