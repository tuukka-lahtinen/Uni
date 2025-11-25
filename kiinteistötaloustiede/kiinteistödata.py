import pandas as pd
import numpy as np

df = pd.read_csv(
    "/Users/tuukkalahtinen/Desktop/kiinteistötaloustiede/asuntokaupat_hki.csv"
)

# Muokataan dataa poistamalla yksi autopaikka sekä rivi joka ei ole kerrostalo
df = df[
    ~df.apply(lambda row: row.astype(str).str.contains(r"\(autopaikka\)").any(), axis=1)
]
df = df[~((df["Kerrosnumero"] == 1) & (df["Kerroksia"] == 1))]


# velaton hinta
df["log_hinta"] = np.log(df["Velaton_hinta"])


# muuttujat

df["Tontti_oma"] = (df["Tontti"] == "oma").astype(int)
df["Hissi_on"] = (df["Hissi"] == "on").astype(int)
df["Kunto_hyva"] = (df["Kunto"] == "hyvä").astype(int)
df["kerrosbin"] = (df["Kerrosnumero"] > 1).astype(int)
df["Ika"] = 2025 - df["Rakennusvuosi"]


# regressio

import statsmodels.api as sm


X = df[
    [
        "Keskustaetäisyys_km",
        "Hissi_on",
        "Kunto_hyva",
        "Asuinala",
        "Huoneita",
        "Tontti_oma",
        "Ika",
        "kerrosbin",
    ]
]

X = sm.add_constant(X)

y = df["log_hinta"]

model = sm.OLS(y, X).fit()

print(model.summary())


# Arvo 15 asuntoa
portfolio = df.sample(n=15, random_state=505)

# Tee sama X-matriisi portfoliolle kuin mallissa:
X_port = sm.add_constant(portfolio[X.columns.drop("const")])

# Ennusta log-hinnat ja muunna euroiksi
portfolio["log_hinta_pred"] = model.predict(X_port)
portfolio["hinta_pred"] = np.exp(portfolio["log_hinta_pred"])

# Laske portfolion kokonaisarvo
ennustettu_arvo = portfolio["hinta_pred"].sum()
todellinen_arvo = portfolio["Velaton_hinta"].sum()

print("Asuntoportfolion ennustettu arvo:")
print(f"{ennustettu_arvo:,.0f} €")

print("Portfolion todellinen velaton hinta datasta:")
print(f"{todellinen_arvo:,.0f} €\n")

tiedot = [
    "Kaupunginosa",
    "Huoneisto",
    "Asuinala",
    "Velaton_hinta",
]

print(portfolio[tiedot])


import matplotlib.pyplot as plt

df["log_pred"] = model.predict(X)
plt.scatter(df["log_pred"], df["log_hinta"], alpha=0.5)
plt.plot(
    [df["log_pred"].min(), df["log_pred"].max()],
    [df["log_pred"].min(), df["log_pred"].max()],
    color="red",
    linestyle="--",
)
plt.xlabel("Ennustettu hinta")
plt.ylabel("Havaittu hinta")
plt.title("Havaitut vs. ennustetut hinnat")
plt.grid(True)
plt.show()
