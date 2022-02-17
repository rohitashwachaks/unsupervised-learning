# Principal Components Analysis
# entering raw data and extracting PCs
# from the correlation matrix
# Basic R commands
fit <- prcomp(AustinApartmentRent[2:9], scale=TRUE)
names(fit) # names of vars in object fit
summary(fit) # print proportion of variance accounted for
fit$sdev^2 # variance explained
fit$rotation # eigenvectors of corr matrix
plot(fit,type="lines") # scree plot
biplot(fit, scale = 0) # biplot PC1 v PC2, scale=0 makes arrows scaled to rep loadings
fit$x # PC scores of each observation
m = cor(AustinApartmentRent[2:9]) # correlation matrix
m # print m
eigen(m) # eigenvalues and eigenvectors of m

