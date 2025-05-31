install.packages('GetBCBData')
install.packages('ipeadatar')
install.packages('sidrar')

library(GetBCBData)
library(ipeadatar)
library(dplyr)
library(sidrar)
library(stringr)

# Coletar dados no SGS/BCB
dados_sgs <- GetBCBData::gbcbd_get_series(
  id = c("IPCA_12" = 13522),
  first.date = "2020-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
colnames(dados_sgs)[colnames(dados_sgs) == "ref.date"] <- "date"


# Coletar dados no SGS/BCB múltiplos dados
dados_sgs_2 <- GetBCBData::gbcbd_get_series(
  id = c("Dólar" = 3698, "IBC-Br" = 24363, "Resultado Primário" = 5793),
  first.date = "2020-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
colnames(dados_sgs_2)[colnames(dados_sgs_2) == "ref.date"] <- "date"

# Extrair tabela com todas séries e códigos disponíveis
series_ipeadata <- ipeadatar::available_series()

# Filtrar séries com o termo "caged"
dplyr::filter(
  series_ipeadata,
  stringr::str_detect(source, stringr::regex("caged", ignore_case = TRUE))
)

# Coletar dados no Ipea
dados_ipeadata <- ipeadatar::ipeadata("CAGED12_SALDON12")
dados_ipeadata <- subset(dados_ipeadata, date >= "2021-01-01" & date <= Sys.Date())
dados_ipeadata <- subset(dados_ipeadata, select = c("date", "value"))
colnames(dados_ipeadata)[colnames(dados_ipeadata) == "value"] <- "CAGED Saldo em 12 meses"
tail(dados_ipeadata)

# Código de consulta com filtros na tabela 7060 (Sidra/IBGE)
cod_sidra <- "/t/7060/n1/all/v/63/p/all/c315/7169/d/v63%202"
# Coleta dos dados com o código
dados_sidra <- sidrar::get_sidra(api = cod_sidra)

tail(dplyr::as_tibble(dados_sidra))


