
# Bibliotecas 
library(ipeadatar)
library(dplyr)
library(openxlsx)
library(ggplot2)

# Extrair tabela com todas séries e códigos disponíveis
series_ipeadata <- ipeadatar::available_series()

# Coletar dados no Ipea:

# Mercado de Trabalho Novo Caged
caged_admin <- ipeadatar::ipeadata("CAGED12_ADMISN12")
caged_admin <- subset(caged_admin, date >= "2020-01-01" & date <= Sys.Date())
caged_admin <- subset(caged_admin, select = c("date", "value"))
colnames(caged_admin)[colnames(caged_admin) == "value"] <- "CAGED Admissões em 12 meses"



caged_desl <- ipeadatar::ipeadata("CAGED12_DESLIGN12")
caged_desl <- subset(caged_desl, date >= "2022-01-01" & date <= Sys.Date())
caged_desl <- subset(caged_desl, select = c("date", "value"))
colnames(caged_desl)[colnames(caged_desl) == "value"] <- "CAGED Desligamentos em 12 meses"


caged_saldo <- ipeadatar::ipeadata("CAGED12_SALDON12")
caged_saldo <- subset(caged_saldo, date >= "2023-01-01" & date <= Sys.Date())
caged_saldo <- subset(caged_saldo, select = c("date", "value"))
colnames(caged_saldo)[colnames(caged_saldo) == "value"] <- "CAGED Saldo em 12 meses"




