# Qual o total de femin�cidios e o total de tentativas femin�cidios ocorridos no munic�pio do Rio de Janeiro, usando Ci�ncia de Dados?

# Instalando as bibliotecas necess�rias
library(reshape2)
library(ggplot2)
library(zoo)
library(stringr)

# Definindo o diret�rio para importar a base de dados
setwd("C:/Users/Alex/Desktop")

# Importando a base de dados de cFemin�cidios
df <- read.csv("dados_feminicidios.csv", header = TRUE, sep = ";")
View(df)
df <- df[c(1:42),] # Somente delegacias do munic�pio do Rio de Janeiro
df[nrow(df)+1, c(2:ncol(df))] <-  colSums(df[,-1])

# Atribuindo o data frame existente a um novo data frame, que ser� revelado os resultados dos femin�cidios
dft <- data.frame(t(df[c(nrow(df)),-1]))
colnames(dft)[1] <- "numero_casos"
dft$variable <- 0
dft$data <- 0
for (row in 1:nrow(dft)){
  if (substring(row.names(dft)[row], 1, 1)=="t"){
    dft$variable[row] <- "tentativa_feminicidio"
    dft$data[row] <- paste("01",substring(row.names(dft)[row], 6, 11), sep="")
  }  else {
    dft$variable[row] <- "caso_feminicidio"
    dft$data[row] <- paste("01",substring(row.names(dft)[row], 5, 10), sep="")
  }
}

dft$data <- as.Date(dft$data,"%d%m%Y")

str(dft)

ggplot(dft, aes(data, numero_casos, color=variable))+geom_line()+ 
  annotate("text", x=dft[5,3], y=9.5, label= "Tentativas de Feminic�dio", size=3, colour="blue") +
  annotate("text", x=dft[5,3], y=5, label= "Casos de Feminic�dio", size=3, colour="magenta") +
  scale_color_manual(values=c("magenta", "blue"))+
  scale_y_continuous(breaks=c(0,2,4,6,8,10),limits=c(0,10))+
  theme_bw()+ theme(legend.position="none")

ggsave("./plots_raw/feminicidio_rio.png")