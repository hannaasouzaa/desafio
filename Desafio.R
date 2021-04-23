#leitura dos dados
library(readr)
#lendo banco de dados de entregas
entregas_tab <- read_delim("Desafio/entregas_tab.txt", 
                           "|", escape_double = FALSE, col_names = FALSE, 
                           trim_ws = TRUE, skip = 7)
#excluindo colunas com NA
entregas <- entregas_tab[ ,-c(1,6)]
#renomeando as variaveis
colnames (entregas) <- c("SKU", "Data de Compra", "Data de Chegada", "SKTD" )
#visualizando os dados
View(entregas)

#lendo banco de dados da  descrição dos produtos
prods_tab <- read.csv("~/Desafio/prods_tab.csv")

#excluindo linhas em brancos
prods <- prods_tab[-c(1,5,6,8:10,16),]
#visualizando os dados
View(prods)

#removendo caracteres indevidos e espaços ausentes
library(dplyr)
produtos <- mutate(prods, SKU = gsub("[\\?|I|\ |\\-]","", prods$SKU.),
                          GRP = gsub("$",0, prods$GRP..MERC..3),
                          COD = gsub("$",0, prods$COD..MARC.))
produtos <-  produtos[,-c(3:5)] #remove as colunas com os itens indesejados
View(produtos)

#unificando os bancos de dados
library(plyr)
dados <- plyr::join(entregas, produtos, by = 'SKU') #SKU é a variável que interliga esses bancos
View(dados)

#acrescentando lead time em dias
dados = mutate(dados, leadtime = dados$`Data de Chegada` - dados$`Data de Compra`)
View(dados)
attach(dados)

#calculando média dos fornecedores
dados_finais = aggregate(leadtime ~ ID..Forn.,
          data = dados, FUN = "mean")
colnames(dados_finais) <- c("ID do Fornecedor", "LT Médio")
View(dados_finais)



