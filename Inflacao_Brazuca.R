# Biblioteca do BCB
library(GetBCBData)
library(zoo)
library(openxlsx)
library(ggplot2)
library(dplyr)

# Diretório genérico para salvar os arquivos (substitua pelo caminho desejado)
base_dir <- "C:/Dados/Inflacao_Conjuntura/Inflacao"

# Criar diretório se não existir
if (!dir.exists(base_dir)) {
  dir.create(base_dir, recursive = TRUE)
}

# Coletar dados no SGS/BCB

# IPCA 12 meses
IPCA <- GetBCBData::gbcbd_get_series(
  id = c("IPCA_12" = 13522),
  first.date = "2020-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
colnames(IPCA)[colnames(IPCA) == "ref.date"] <- "date"
ggplot(data = IPCA, aes(x = date, y = IPCA_12)) +
  geom_line(color = "blue", size = 1.5) +
  labs(title = "Variação IPCA fluxo em 12 meses (%)",
       x = "Data",
       y = "Variação em %",
       caption = "Fonte: IBGE") + 
  theme_minimal() +
  theme(panel.background = element_rect(fill = "gray90"))

caminho <- file.path(base_dir, "IPCA.xlsx")
write.xlsx(IPCA, file = caminho, rowNames = FALSE)

# Índice de Difusão
Indice_Difusao <- GetBCBData::gbcbd_get_series(
  id = c("Índice de Difusao" = 21379),
  first.date = "2020-01-01",
  last.date = Sys.Date(),
  format.data = "wide"
)

colnames(Indice_Difusao)[colnames(Indice_Difusao) == "ref.date"] <- "date"
caminho <- file.path(base_dir, "Índice de Difusão.xlsx")
write.xlsx(Indice_Difusao, file = caminho, rowNames = FALSE)

# IPCA 15 em 12 meses
IPCA_15 <- GetBCBData::gbcbd_get_series(
  id = c("IPCA_15" = 7478),
  first.date = "2019-02-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
colnames(IPCA_15)[colnames(IPCA_15) == "ref.date"] <- "date"
IPCA_15 <- IPCA_15 %>%
  mutate(IPCA_15 = (IPCA_15 / 100 + 1)) %>%
  mutate(IPCA_15 = rollapply(IPCA_15, width = 12, FUN = function(x) prod(x) - 1, align = "right", fill = NA) * 100) %>%
  mutate(IPCA_15 = round(IPCA_15, 2))

IPCA_15 <- na.omit(IPCA_15)
caminho <- file.path(base_dir, "IPCA-15.xlsx")
write.xlsx(IPCA_15, file = caminho, rowNames = FALSE)

# IGP-M 12 meses
IGP_M <- GetBCBData::gbcbd_get_series(
  id = c("IGP_M" = 189),
  first.date = "2019-02-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
colnames(IGP_M)[colnames(IGP_M) == "ref.date"] <- "date"
IGP_M <- IGP_M %>%
  mutate(IGP_M = (IGP_M / 100 + 1)) %>%
  mutate(IGP_M = rollapply(IGP_M, width = 12, FUN = function(x) prod(x) - 1, align = "right", fill = NA) * 100) %>%
  mutate(IGP_M = round(IGP_M, 2))

IGP_M <- na.omit(IGP_M)
caminho <- file.path(base_dir, "IGP-M.xlsx")
write.xlsx(IGP_M, file = caminho, rowNames = FALSE)


# IPCA Comercializáveis x Não Comercializáveis em 12 meses
IPCA_Comerc <- GetBCBData::gbcbd_get_series(
  id = c("Comercializáveis" = 4447, "Não Comercializáveis" = 4448),
  first.date = "2019-02-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
IPCA_Comerc <- IPCA_Comerc %>%
  mutate(across(.cols = matches("Comercializáveis|Não Comercializáveis"), 
                .fns = function(x) (x / 100 + 1))) %>%
  mutate(across(.cols = matches("Comercializáveis|Não Comercializáveis"), 
                .fns = ~rollapply(.x, width = 12, FUN = function(x) prod(x) - 1, align = "right", fill = NA) * 100)) %>%
  mutate(across(.cols = matches("Comercializáveis|Não Comercializáveis"), 
                .fns = ~round(.x, 2)))

IPCA_Comerc <- na.omit(IPCA_Comerc)
colnames(IPCA_Comerc)[colnames(IPCA_Comerc) == "ref.date"] <- "date"
caminho <- file.path(base_dir, "IPCA Comercializáveis x N Comercializáveis.xlsx")
write.xlsx(IPCA_Comerc, file = caminho, rowNames = FALSE)

# IPCA Administrados x Livres em 12 meses
IPCA_AdmL <- GetBCBData::gbcbd_get_series(
  id = c("Administrados" = 4449, "Livres" = 11428),
  first.date = "2019-02-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
IPCA_AdmL <- IPCA_AdmL %>%
  mutate(across(.cols = matches("Administrados|Livres"), 
                .fns = function(x) (x / 100 + 1))) %>%
  mutate(across(.cols = matches("Administrados|Livres"), 
                .fns = ~rollapply(.x, width = 12, FUN = function(x) prod(x) - 1, align = "right", fill = NA) * 100)) %>%
  mutate(across(.cols = matches("Administrados|Livres"), 
                .fns = ~round(.x, 2)))

IPCA_AdmL <- na.omit(IPCA_AdmL)
colnames(IPCA_AdmL)[colnames(IPCA_AdmL) == "ref.date"] <- "date"
caminho <- file.path(base_dir, "IPCA Administrados x Livres.xlsx")
write.xlsx(IPCA_AdmL, file = caminho, rowNames = FALSE)

# IPCA Industriais x Serviços em 12 meses
IPCA_Ind_Serv <- GetBCBData::gbcbd_get_series(
  id = c("Serviços" = 10844, "Duráveis" = 10843, "Semi Duráveis" = 10842, "Não Duráveis" = 10841),
  first.date = "2019-02-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
IPCA_Ind_Serv <- IPCA_Ind_Serv %>%
  mutate(across(.cols = matches("Serviços|Duráveis|Semi Duráveis|Não Duráveis"), 
                .fns = function(x) (x / 100 + 1))) %>%
  mutate(across(.cols = matches("Serviços|Duráveis|Semi Duráveis|Não Duráveis"), 
                .fns = ~rollapply(.x, width = 12, FUN = function(x) prod(x) - 1, align = "right", fill = NA) * 100)) %>%
  mutate(across(.cols = matches("Serviços|Duráveis|Semi Duráveis|Não Duráveis"), 
                .fns = ~round(.x, 2)))

IPCA_Ind_Serv <- na.omit(IPCA_Ind_Serv)
colnames(IPCA_Ind_Serv)[colnames(IPCA_Ind_Serv) == "ref.date"] <- "date"
caminho <- file.path(base_dir, "IPCA Industriais x Serviços.xlsx")
write.xlsx(IPCA_Ind_Serv, file = caminho, rowNames = FALSE)

# Componentes do IGP-M em 12 meses
Comp_IGP_M <- GetBCBData::gbcbd_get_series(
  id = c("IPC-M" = 7453, "IPA-M" = 7450, "INCC-M" = 7456),
  first.date = "2019-02-01",
  last.date = Sys.Date(),
  format.data = "wide"
)
Comp_IGP_M <- Comp_IGP_M %>%
  mutate(across(.cols = matches("IPC-M|IPA-M|INCC-M"), 
                .fns = function(x) (x / 100 + 1))) %>%
  mutate(across(.cols = matches("IPC-M|IPA-M|INCC-M"), 
                .fns = ~rollapply(.x, width = 12, FUN = function(x) prod(x) - 1, align = "right", fill = NA) * 100)) %>%
  mutate(across(.cols = matches("IPC-M|IPA-M|INCC-M"), 
                .fns = ~round(.x, 2)))

Comp_IGP_M <- na.omit(Comp_IGP_M)
colnames(Comp_IGP_M)[colnames(Comp_IGP_M) == "ref.date"] <- "date"
caminho <- file.path(base_dir, "Componentes do IGP.xlsx")
write.xlsx(Comp_IGP_M, file = caminho, rowNames = FALSE)
