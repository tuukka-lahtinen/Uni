# tallentaa kirjan
def tallenna_kirja(kirjat: dict, koodi: str, nimi: str, kirjoittaja: str, vuosi: int):
    kirjat[koodi] = (nimi, kirjoittaja, vuosi)

# tarkistaa kirjan
def onko_kirja(kirjat: dict, koodi: str) -> bool:
    return koodi in kirjat

# poistaa kirjan
def poista_kirja(kirjat: dict, koodi: str) -> bool:
    if koodi in kirjat:
        del kirjat[koodi]
        return True
    else:
        return False

# palauttaa kirjoittajan kirjat
def kirjoittajan_kirjat(kirjat: dict, kirjoittaja: str) -> list:
    palautus = []

    for koodi in kirjat:
        kirja = kirjat[koodi] 
        if kirja[1] == kirjoittaja:
            palautus.append(kirja)

    return palautus

# tulostaa kirjan tiedot

def tulosta_kirja(kirja: tuple):
    nimi = kirja[0]
    kirjoittaja = kirja[1]
    vuosi = kirja[2]
    print(f"{nimi} ({kirjoittaja}), {vuosi}")

# pääohjelma tietokannalle

def pääohjelma():
    kirjat = {}

    while True:
        print("Valitse:")
        print("1. Lisää kirja")
        print("2. Poista kirja")
        print("3. Tulosta kirja")
        print("4. Kirjoittajan kirjat")
        print("0. Poistu")
        valinta = input("Valinta: ")

        if valinta == "0":
            break

        if valinta == "1":
            koodi = input("Koodi: ")
            nimi = input("Nimi: ")
            kirjoittaja = input("Kirjoittaja: ")
            vuosi = int(input("Vuosi: "))
            tallenna_kirja(kirjat, koodi, nimi, kirjoittaja, vuosi)

        elif valinta == "2":
            koodi = input("Koodi: ")
            if poista_kirja(kirjat, koodi):
                print("Poistettiin!")
            else:
                print("Kirjaa ei löytynyt.")

        elif valinta == "3":
            koodi = input("Koodi: ")
            if onko_kirja(kirjat, koodi):
                tulosta_kirja(kirjat[koodi])
            else:
                print("Kirjaa ei löytynyt.")

        elif valinta == "4":
            kirjoittaja = input("Kirjoittaja: ")
            kirjalista = kirjoittajan_kirjat(kirjat, kirjoittaja)
            if kirjalista:
                for kirja in kirjalista:
                    tulosta_kirja(kirja)
            else:
                print("Kirjoja ei löytynyt.")

pääohjelma()
