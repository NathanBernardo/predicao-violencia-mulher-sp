library(caret)
library(pROC)
library(readr)

df <- read_csv("D:/mary-/Downloads/Artigo/modelo_limpo.csv")

# transformar target em fator
df$grave <- as.factor(df$grave)

# -------------------------
# DIVISÃO TREINO/TESTE
# -------------------------
set.seed(123)

particao <- sample(seq_len(nrow(df)), size = 0.7*nrow(df))

treino <- df[particao, ]
teste  <- df[-particao, ]

# -------------------------
# MODELO LOGÍSTICO
# -------------------------
modelo <- glm(
  grave ~ .,
  data = treino,
  family = binomial
)

summary(modelo)

# -------------------------
# PREDIÇÃO
# -------------------------
prob <- predict(
  modelo,
  newdata = teste,
  type = "response"
)

# -------------------------
# ROC
# -------------------------
roc_obj <- roc(
  response = teste$grave,
  predictor = prob
)

melhor <- coords(roc_obj, "best", ret = c("threshold","sensitivity","specificity"))

thr <- melhor["threshold"]

# -------------------------
# CLASSIFICAÇÃO
# -------------------------
pred_class <- ifelse(prob > as.numeric(thr), "1", "0")

# -------------------------
# MATRIZ DE CONFUSÃO
# -------------------------
confusionMatrix(
  as.factor(pred_class),
  teste$grave
)