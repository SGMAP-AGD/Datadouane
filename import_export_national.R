#Ce scriptrécupère les jeux de données d'import et d'export des douanes pour créer un fichier CSV contenant toutes les données jusqu'à aujour'hui.

#Imports 2015
if (!file.exists("./201503-stat-national-ce-import.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150519-152247/201503-stat-national-ce-import.zip","./201503-stat-national-ce-import.zip")
}
unzip("./201503-stat-national-ce-import.zip", exdir = "2015I")

#Exports 2015
if (!file.exists("./201503-stat-national-ce-export.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150519-151607/201503-stat-national-ce-export.zip","./201503-stat-national-ce-export.zip")
}
unzip("./201503-stat-national-ce-export.zip", exdir = "2015E")

#Imports 2014
if (!file.exists("./201501-stat-national-ce-import.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150519-150221/201501-stat-national-ce-import.zip")
}
unzip("./201501-stat-national-ce-import.zip", exdir = "2014I") 

#Exports 2014
if (!file.exists("./201501-stat-national-ce-export.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150519-145744/201501-stat-national-ce-export.zip")
}
unzip("./201501-stat-national-ce-export.zip", exdir = "2014E")

#Imports 2013
if (!file.exists("./2013-stat-national-ce-import.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150518-163554/2013-stat-national-ce-import.zip","./2013-stat-national-ce-import.zip")
}
unzip("./2013-stat-national-ce-import.zip", exdir = "2013I")

#Exports 2013
if (!file.exists("./2013-stat-national-ce-export.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150518-164559/2013-stat-national-ce-export.zip","./2013-stat-national-ce-export.zip")
}
unzip("./2013-stat-national-ce-export.zip", exdir = "2013E")

#Imports 2012
if (!file.exists("./2012-stat-national-ce-import.zip")){
  download.file("http://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150518-162048/2012-stat-national-ce-import.zip","./2012-stat-national-ce-import.zip")
}
unzip("./2012-stat-national-ce-import.zip", exdir = "2012I")

#Exports 2012
if (!file.exists("./2012-stat-national-ce-export.zip")){
  download.file("https://www.data.gouv.fr/s/resources/statistiques-nationales-du-commerce-exterieur-1/20150518-163235/2012-stat-national-ce-export.zip","./2012-stat-national-ce-export.zip")
}
unzip("./2012-stat-national-ce-export.zip", exdir = "2012E")
```

Liaison des différents jeux de données du commerce extérieur national en un seul dataframe

```{r, cache=TRUE}
national_2015I <- read.csv2("./2015I/NATIONAL_NC8PAYSI/NATIONAL_NC8PAYSI.txt")
national_2015I <- national_2015I[ which(national_2015I$X2015=='2015'),]
colnames(national_2015I) <- c("V1","V2","V3","V4","V5","V6","V7","V8")

national_2015E <- read.csv2("./2015E/NATIONAL_NC8PAYSE/NATIONAL_NC8PAYSE.txt")
national_2015E <- national_2015E[ which(national_2015E$X2015=='2015'),]
colnames(national_2015E) <- c("V1","V2","V3","V4","V5","V6","V7","V8")

national_2014I <- read.csv2("./2014I/NATIONAL_NC8PAYSI/NATIONAL_NC8PAYSI.txt",header = FALSE)
national_2014I <- national_2014I[ which(national_2014I$V3=='2014'),]
national_2014E <- read.csv2("./2014E/NATIONAL_NC8PAYSE/NATIONAL_NC8PAYSE.txt",header = FALSE)
national_2014E <- national_2014E[ which(national_2014E$V3=='2014'),]

national_2013I <- read.csv2("./2013I/2013_Import2.txt",header = FALSE,sep = ";",na.strings = "")
national_2013E <- read.csv2("./2013E/2013_Export2.txt",header = FALSE,sep = ";",na.strings = "")

national_2012I <- read.csv2("./2012I/2012_Import2.txt",header = FALSE)
national_2012E <- read.csv2("./2012E/2012_Export2.txt",header = FALSE)

national <- rbind(national_2015I,
                  national_2015E,
                  national_2014I,
                  national_2014E,
                  national_2013I,
                  national_2013E,
                  national_2012I,
                  national_2012E)

colnames(national) <- c("flow","month","year","nc8","country","value","masse","usup")

#Format des colonnes
national$date <- as.Date(as.character(national$year*10000+national$month*100+1), "%Y%m%d")

#Ecriture du CSV
write.table(national, file = "./national.csv",row.names=FALSE, na="",col.names=TRUE, sep=";")


