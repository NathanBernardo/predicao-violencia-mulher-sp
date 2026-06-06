library(caret)
library(pROC)
library(readr)
library(smotefamily)

# Leitura dos dados
df <- read.csv("modelo_limpo.csv")
df$grave <- as.factor(df$grave)

# Divisão treino/teste (70/30)
set.seed(123)
particao <- sample(seq_len(nrow(df)), size = 0.7 * nrow(df))
treino <- df[particao, ]
teste  <- df[-particao, ]

# Distribuição das classes
print(prop.table(table(df$grave)))

# Modelo logístico
modelo <- glm(grave ~ ., data = treino, family = binomial)
summary(modelo)

# Predição
prob <- predict(modelo, newdata = teste, type = "response")

# Curva ROC e threshold ótimo
roc_obj <- roc(response = teste$grave, predictor = prob)
cat("AUC:", auc(roc_obj), "\n")

melhor <- coords(roc_obj, "best", ret = c("threshold", "sensitivity", "specificity"))
thr <- as.numeric(melhor["threshold"])
cat("Threshold ótimo:", thr, "\n")

# Exportar curva ROC
png("curva_roc.png", width = 800, height = 600, res = 120)
plot(roc_obj, main = "Curva ROC – Modelo de Regressão Logística",
     col = "#2c7bb6", lwd = 2, print.auc = TRUE, print.auc.y = 0.4)
points(x = melhor["specificity"], y = melhor["sensitivity"],
       col = "red", pch = 19, cex = 1.5)
legend("bottomright", legend = paste0("Threshold ótimo = ", round(thr, 4)),
       col = "red", pch = 19, bty = "n")
dev.off()

# Classificação e matriz de confusão
pred_class <- ifelse(prob > thr, "1", "0")
confusionMatrix(as.factor(pred_class), teste$grave, positive = "1")

# SMOTE
treino_num <- treino
treino_num$grave <- as.numeric(as.character(treino_num$grave))

smote_result <- SMOTE(
  X = treino_num[, !names(treino_num) %in% "grave"],
  target = treino_num$grave,
  K = 5, dup_size = 0
)

treino_bal <- smote_result$data
names(treino_bal)[names(treino_bal) == "class"] <- "grave"
treino_bal$grave <- as.factor(treino_bal$grave)

cat("Distribuição após SMOTE:\n")
print(table(treino_bal$grave))

# Modelo balanceado
modelo_bal <- glm(grave ~ ., data = treino_bal, family = binomial)
prob_bal   <- predict(modelo_bal, newdata = teste, type = "response")
roc_bal    <- roc(response = teste$grave, predictor = prob_bal)
cat("AUC (SMOTE):", auc(roc_bal), "\n")

melhor_bal <- coords(roc_bal, "best", ret = c("threshold", "sensitivity", "specificity"))
thr_bal    <- as.numeric(melhor_bal["threshold"])
pred_bal   <- ifelse(prob_bal > thr_bal, "1", "0")
confusionMatrix(as.factor(pred_bal), teste$grave, positive = "1")

# Exportar curva ROC comparativa
png("curva_roc_comparativa.png", width = 900, height = 600, res = 120)
plot(roc_obj, col = "#2c7bb6", lwd = 2, main = "Curva ROC – Original vs. SMOTE")
plot(roc_bal, col = "#d7191c", lwd = 2, add = TRUE)
legend("bottomright",
       legend = c(paste0("Original (AUC = ", round(auc(roc_obj), 3), ")"),
                  paste0("SMOTE   (AUC = ", round(auc(roc_bal),  3), ")")),
       col = c("#2c7bb6", "#d7191c"), lwd = 2, bty = "n")
dev.off()