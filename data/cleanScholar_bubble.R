library(stringr)
setwd("/yourpath")
scholar=read.csv("scholarRaw.csv")

scholar=scholar[!scholar$Name.of.Scholar=="",]

scholar$Scholarship.Awarded=str_trim(scholar$Scholarship.Awarded) #fix extra spaces before and after name
scholar$Scholarship.Awarded=gsub(" \\)","\\)",scholar$Scholarship.Awarded) #remove space) in name

names(scholar)[4]="jcPoly"
scholar$jcPoly=gsub("\\-"," ",scholar$jcPoly)
scholar$school="Unknown"
scholar$school[grep("Raffles Institution|Raffles Junior College",scholar$jcPoly,ignore.case = T)]="Raffles Institution"
scholar$school[grep("Haw Chong Institution|Hwa Chong Institution|Hwa Chong Junior College",scholar$jcPoly,ignore.case = T)]="Hwa Chong Institution"
scholar$school[grep("Singapore Sports School",scholar$jcPoly,ignore.case = T)]="Singapore Sports School"
scholar$school[grep("International School|United World College of South East Asia",scholar$jcPoly,ignore.case = T)]="International Schools"
scholar$school[grep("Anglo Chinese Junior College",scholar$jcPoly,ignore.case = T)]="Anglo Chinese Junior College"
scholar$school[grep("Anglo Chinese School \\(Independent\\)",scholar$jcPoly,ignore.case = T)]="Anglo Chinese School (I)"
scholar$school[grep("Victoria Junior College",scholar$jcPoly,ignore.case = T)]="Victoria Junior College"
scholar$school[grep("National Junior College",scholar$jcPoly,ignore.case = T)]="National Junior College"
scholar$school[grep("Temasek Junior College",scholar$jcPoly,ignore.case = T)]="Temasek Junior College"
scholar$school[grep("Catholic Junior College",scholar$jcPoly,ignore.case = T)]="Catholic Junior College"
scholar$school[grep("Anderson Junior College",scholar$jcPoly,ignore.case = T)]="Anderson Junior College"
scholar$school[grep("Nanyang Junior College",scholar$jcPoly,ignore.case = T)]="Nanyang Junior College"
scholar$school[grep("Jurong Junior College",scholar$jcPoly,ignore.case = T)]="Jurong Junior College"
scholar$school[grep("Pioneer Junior College",scholar$jcPoly,ignore.case = T)]="Pioneer Junior College"
scholar$school[grep("Singapore Polytechnic",scholar$jcPoly,ignore.case = T)]="Singapore Polytechnic"
scholar$school[grep("Ngee Ann Polytechnic",scholar$jcPoly,ignore.case = T)]="Ngee Ann Polytechnic"
scholar$school[grep("Temasek Polytechnic",scholar$jcPoly,ignore.case = T)]="Temasek Polytechnic"
scholar$school[grep("Singapore Polytechnic",scholar$jcPoly,ignore.case = T)]="Singapore Polytechnic"
scholar$school[grep("NUS High School",scholar$jcPoly,ignore.case = T)]="NUS High School"
scholar$school[grep("Singapore Polytechnic",scholar$jcPoly,ignore.case = T)]="Singapore Polytechnic"
scholar$school[grep("Dunman High School",scholar$jcPoly,ignore.case = T)]="Dunman High School"
scholar$school[grep("River Valley High School",scholar$jcPoly,ignore.case = T)]="River Valley High School"
scholar$school[grep("St Joseph's Institution",scholar$jcPoly,ignore.case = T)]="St Joseph's Institution"
scholar$school[grep("Sngapore Polytechnic",scholar$jcPoly,ignore.case = T)]="Sngapore Polytechnic"

##Gender##
scholar$Gender=as.character(scholar$Gender)
scholar$Gender[scholar$Gender=="male"]="Male"
scholar$Gender[scholar$Gender==""]="Unknown"

##Prepare data for bubble##
names(scholar)=gsub("\\.","",names(scholar))
scholar$ScholarshipAwarded=gsub("\\(.*?\\)", "", scholar$ScholarshipAwarded) #remove all text in brackets
scholar$ScholarshipAwarded=gsub("Local-Overseas", "Local - Overseas", scholar$ScholarshipAwarded) 
scholar$ScholarshipAwarded=gsub("Medicine", "", scholar$ScholarshipAwarded) 
scholar$ScholarshipAwarded=gsub("-", "", scholar$ScholarshipAwarded) 
scholar$ScholarshipAwarded=gsub("^ *|(?<= ) | *$", "", scholar$ScholarshipAwarded, perl=T)#replace multiple spaces with one
scholar$type="All Scholars"
scholar=subset(scholar, select=-c(jcPoly,UniversityandCourseofStudy,Country))
scholar$LastKnownRole=gsub(",|Unknown|-","",scholar$LastKnownRole)
scholar$Organisation=gsub(",|Unknown|-","",scholar$Organisation)
scholar$Course=as.character(scholar$Course)
scholar$Course=gsub("\\+","and",scholar$Course)
scholar$NameofScholar=substr(scholar$NameofScholar, 1, 6)

set.seed(1029293)
gender=c("Male","Female")
x=scholar$Gender[scholar$Gender=="Unknown"]
scholar$Gender[scholar$Gender=="Unknown"]=sample(gender,length(scholar$Gender[scholar$Gender=="Unknown"]),replace =T)


scholar$ScholarshipAwarded=as.character(scholar$ScholarshipAwarded)
scholar$ScholarshipAwardedTemp=scholar$ScholarshipAwarded
scholar$ScholarshipAwarded[grep("Overseas Merit Scholarship",scholar$ScholarshipAwardedTemp,ignore.case = T)]="Overseas Merit Scholarship"
scholar$ScholarshipAwarded[grep("Local - Overseas Merit Scholarship",scholar$ScholarshipAwardedTemp,ignore.case = T)]="Local-Overseas Merit Scholarship"
scholar$ScholarshipAwarded[grep("Local Merit Scholarship",scholar$ScholarshipAwardedTemp,ignore.case = T)]="Local Merit Scholarship"
scholar$ScholarshipAwarded[grep("SAF",scholar$ScholarshipAwardedTemp,ignore.case = T)]="SAF's Scholarship"
scholar$ScholarshipAwarded[grep("SPF",scholar$ScholarshipAwardedTemp,ignore.case = T)]="SPF's Scholarship"
scholar$ScholarshipAwarded[grep("Singapore Government Scholarship",scholar$ScholarshipAwardedTemp,ignore.case = T)]="SG Government Scholarship"
scholar$ScholarshipAwarded[grep("MAS|Master",scholar$ScholarshipAwardedTemp,ignore.case = T)]="Others"
scholar$ScholarshipAwarded[grep("President",scholar$ScholarshipAwardedTemp,ignore.case = T)]="President's Scholarship"
scholar$ScholarshipAwarded=as.factor(scholar$ScholarshipAwarded)

scholar$Course=as.character(scholar$Course)
scholar$CourseTemp=scholar$Course
scholar$Course[grep("Science|Biology|Chemistry",scholar$CourseTemp,ignore.case = T)]="Science"
scholar$Course[grep("Engineering",scholar$CourseTemp,ignore.case = T)]="Engineering"
scholar$Course=as.factor(scholar$Course)

keepTop = function(factorIn,varNum){
  tempCol=data.frame(summary(factorIn))
  names(tempCol)="count"  
  tempCol$var=row.names(tempCol)
  #if there is already an others column, count that as 0
  if(any(tempCol$var %in% c("Others"))){tempCol$count[tempCol$var=="Others"]=0}
  tempCol=tempCol[order(tempCol$count,decreasing=T),]
  topVar=tempCol$var[1:varNum]
  factorIn=as.character(factorIn)
  factorIn[!factorIn %in% topVar]="Others"
  factorIn=as.factor(factorIn)
  return (factorIn)
}

#reduce levels of factor
scholar$Course=keepTop(scholar$Course,8)

write.csv(scholar,"scholarData.csv",row.names=F)