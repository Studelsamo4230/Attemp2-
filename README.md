import pandas as pd
import numpy as np

from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans

# Load dataset
df = pd.read_csv("brake_squeal_dataset.csv")
df = df.drop("Test_ID", axis=1)

# Create deviation
df["Delta_f"] = df["Dyno_freq"] - df["CAE_freq"]

# Select features (IMPORTANT: include mic position)
features = [
    "Temp_Disc", "Pressure", "Speed", "Torque",
    "Wear", "Mu",
    "Mic_Distance", "Mic_Angle", "Mic_Height"
]

X = df[features]

# Normalize data
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# ---------------------------
# PCA (Dimensionality Reduction)
# ---------------------------
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

print("Explained Variance Ratio:", pca.explained_variance_ratio_)

# PCA Loadings (VERY IMPORTANT FOR INTERPRETATION)
loadings = pd.DataFrame(
    pca.components_.T,
    columns=["PC1", "PC2"],
    index=features
)

print("\nPCA Loadings:\n", loadings)

kmeans = KMeans(n_clusters=3, random_state=42)
clusters = kmeans.fit_predict(X_pca)

df["Cluster"] = clusters

# ---------------------------
# Analyze clusters
# ---------------------------
cluster_analysis = df.groupby("Cluster").mean()

print("\nCluster Analysis:\n", cluster_analysis)

# ---------------------------
# Check deviation per cluster
# ---------------------------
print("\nDeviation per Cluster:")
print(df.groupby("Cluster")["Delta_f"].mean())
