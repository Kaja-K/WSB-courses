# coding: utf-8

# =============================================================================
# LECTURE 2 — PYTHON CHEATSHEET
# =============================================================================


# --- FUNKCJE -----------------------------------------------------------------

def pole_kwadratu(bok):
    pole = bok ** 2
    return pole

wynik = pole_kwadratu(4)
print(wynik)    # 16


# --- KLASY — PODSTAWY --------------------------------------------------------

# Minimalna klasa
class Klasa:
    pass

k = Klasa()     # tworzenie instancji (obiektu)

# Klasa z atrybutem klasowym i metodą
class Klasa:
    atrybut = 1

    def metoda(self, argument):
        print(argument)

k = Klasa()
print(k.atrybut)    # 1  — wywołanie atrybutu
k.metoda(10)        # 10 — wywołanie metody


# --- __init__ I SELF ---------------------------------------------------------

# __init__ — konstruktor, wywoływany automatycznie przy tworzeniu obiektu
# self     — reprezentuje konkretną instancję, musi być pierwszym arg. metody

class Klasa:
    def __init__(self, wartosc):
        self.atrybut = wartosc  # atrybut instancji

k = Klasa(5)
print(k.atrybut)    # 5

# Atrybut klasowy vs instancyjny
class Klasa:
    atrybut = 1                         # klasowy — wspólny dla wszystkich

    def metoda(self, argument):
        self.atrybut = argument         # instancyjny — nadpisuje dla tego obiektu

k = Klasa()
print(k.atrybut)    # 1
k.metoda(2)
print(k.atrybut)    # 2


# --- WYWOŁYWANIE METOD WEWNĄTRZ KLASY ----------------------------------------

class Calculator:
    def __init__(self):
        self.history = []

    def add(self, a, b):
        result = a + b
        self._save(f"{a} + {b} = {result}")   # wywołanie innej metody przez self
        return result

    def multiply(self, a, b):
        result = a * b
        self._save(f"{a} * {b} = {result}")
        return result

    def _save(self, operation):
        # _ na początku = konwencja "prywatna" (chroniona)
        self.history.append(operation)

    def get_history(self):
        return self.history

calc = Calculator()
calc.add(5, 3)
calc.multiply(4, 2)
print(calc.get_history())   # ['5 + 3 = 8', '4 * 2 = 8']


# --- CZĘSTE BŁĘDY Z SELF -----------------------------------------------------

# BŁĄD 1: brak self w definicji metody
class Wrong:
    def method():       # brak self!
        return "błąd"

class Correct:
    def method(self):   # poprawnie
        return "ok"

# BŁĄD 2: wywołanie metody bez self wewnątrz klasy
class Example:
    def __init__(self, value):
        self.value = value

    def get_value(self):
        return self.value

    def double_value(self):
        # return get_value() * 2    # BŁĄD — Python nie wie o co chodzi
        return self.get_value() * 2 # poprawnie

obj = Example(5)
print(obj.double_value())   # 10


# --- DZIEDZICZENIE -----------------------------------------------------------

class KlasaBazowa:
    atrybut1 = 1

    def metoda1(self):
        print(self.atrybut1)

class KlasaPotomna(KlasaBazowa):    # dziedziczy po KlasaBazowa
    atrybut2 = 'tekst'

    def metoda2(self, argument):
        print(argument)

# Potomna ma dostęp do atrybutów i metod bazowej
kp = KlasaPotomna()
print(kp.atrybut1)  # 1   — odziedziczone z bazowej
kp.metoda1()        # 1
kp.metoda2('cześć') # cześć

# Bazowa NIE ma dostępu do atrybutów potomnej
kb = KlasaBazowa()
# print(kb.atrybut2)  # AttributeError!


# --- HERMETYZACJA — GETTERY I SETTERY ----------------------------------------

# _ (jeden podkreślnik)  = konwencja "chroniony" — Python nie blokuje dostępu
# __ (dwa podkreślniki)  = "prywatny" — Python zmienia nazwę w pamięci (name mangling)

# Klasyczne podejście — jawne metody get/set
class Zwierze:
    def __init__(self, imie):
        self.__imie = imie      # atrybut prywatny

    def get_imie(self):
        return self.__imie

    def set_imie(self, nowe_imie):
        if len(nowe_imie) > 2:
            self.__imie = nowe_imie
        else:
            print('Błąd: imię za krótkie!')

pupil = Zwierze('Azor')
# print(pupil.__imie)     # AttributeError — niedostępny bezpośrednio
print(pupil.get_imie())   # Azor
pupil.set_imie('Bo')      # Błąd: imię za krótkie!
pupil.set_imie('Burek')   # ok


# --- DEKORATOR @property — pythonowy styl getter/setter ----------------------

class Produkt:
    def __init__(self, cena):
        self._cena = cena   # _ = chroniony (konwencja)

    @property
    def cena(self):         # getter — wywołanie: p.cena
        return f"{self._cena} PLN"

    @cena.setter
    def cena(self, nowa_cena):  # setter — wywołanie: p.cena = 120
        if nowa_cena < 0:
            raise ValueError('Cena nie może być ujemna!')
        self._cena = nowa_cena

p = Produkt(100)
print(p.cena)   # 100 PLN
p.cena = 120    # wywołuje setter
print(p.cena)   # 120 PLN

# Pełny przykład — @property z walidacją
class ProstokatPythonic:
    def __init__(self, szerokosc, wysokosc):
        self._szerokosc = szerokosc
        self._wysokosc = wysokosc

    @property
    def szerokosc(self):
        return self._szerokosc

    @szerokosc.setter
    def szerokosc(self, wartosc):
        if wartosc <= 0:
            raise ValueError('Szerokość musi być dodatnia!')
        self._szerokosc = wartosc

    @property
    def pole(self):             # właściwość obliczana — brak settera
        return self._szerokosc * self._wysokosc

p2 = ProstokatPythonic(5, 10)
p2.szerokosc = 8        # naturalny zapis (bez set_...)
print(p2.szerokosc)     # 8
print(p2.pole)          # 80  — bez nawiasów!


# --- @classmethod I @staticmethod --------------------------------------------

class Robot:
    populacja = 0   # atrybut klasowy — wspólny dla wszystkich instancji

    def __init__(self, nazwa):
        self.nazwa = nazwa
        Robot.populacja += 1

    @classmethod
    def podaj_liczbe_robotow(cls):
        # cls = klasa (nie obiekt); ma dostęp do atrybutów klasowych
        return f"Mamy {cls.populacja} robotów."

    @staticmethod
    def czy_bezpieczny(temperatura):
        # brak dostępu do klasy ani instancji — zwykła funkcja pomocnicza
        return temperatura < 100

r1 = Robot('R2D2')
r2 = Robot('C3PO')
print(Robot.podaj_liczbe_robotow())  # Mamy 2 robotów.
print(Robot.czy_bezpieczny(85))      # True

# Zmiana atrybutu klasowego przez classmethod
class Pracownik:
    roczna_podwyzka = 1.05

    def __init__(self, pensja):
        self.pensja = pensja

    @classmethod
    def zmien_podwyzke(cls, nowa_wartosc):
        cls.roczna_podwyzka = nowa_wartosc

Pracownik.zmien_podwyzke(1.10)
p1 = Pracownik(5000)
print(p1.roczna_podwyzka)   # 1.1 — zmiana dotyczy CAŁEJ klasy


# --- KLASY ABSTRAKCYJNE (ABCs) -----------------------------------------------

from abc import ABC, abstractmethod

class Ksztalt(ABC):
    @abstractmethod
    def pole(self):
        pass    # brak implementacji — potomne MUSZĄ to zdefiniować

    @abstractmethod
    def obwod(self):
        pass

class Kwadrat(Ksztalt):
    def __init__(self, bok):
        self.bok = bok

    def pole(self):
        return self.bok ** 2

    def obwod(self):
        return 4 * self.bok

# Ksztalt()     # TypeError — nie można tworzyć instancji klasy abstrakcyjnej!
moj_kwadrat = Kwadrat(5)
print(moj_kwadrat.pole())   # 25
print(moj_kwadrat.obwod())  # 20


# --- METODY MAGICZNE (DUNDER METHODS) ----------------------------------------

# __str__  — co widać przy print(obiekt)
# __repr__ — techniczny opis (debugowanie)
# __gt__   — operator >
# __add__  — operator +
# __mul__  — operator *

class Zwierze:
    def __init__(self, imie, wiek):
        self.imie = imie
        self.wiek = wiek

    def __str__(self):
        return f"Zwierzę: {self.imie}, Wiek: {self.wiek} lat"

    def __repr__(self):
        return f"Zwierze(imie='{self.imie}', wiek={self.wiek})"

    def __gt__(self, inne):
        return self.wiek > inne.wiek

azor = Zwierze('Azor', 5)
burek = Zwierze('Burek', 3)
print(azor)             # Zwierzę: Azor, Wiek: 5 lat
print(repr(azor))       # Zwierze(imie='Azor', wiek=5)
print(azor > burek)     # True

# Przykład — przeciążanie operatorów matematycznych (Wektor)
class Wektor:
    def __init__(self, x, y, z):
        self.x, self.y, self.z = x, y, z

    def __str__(self):
        return f"<{self.x}, {self.y}, {self.z}>"

    def __add__(self, a):           # v1 + v2
        return Wektor(self.x + a.x, self.y + a.y, self.z + a.z)

    def __mul__(self, a):           # iloczyn skalarny: v1 * v2
        return self.x*a.x + self.y*a.y + self.z*a.z

v1 = Wektor(1, 2, 3)
v2 = Wektor(4, 5, 6)
print(v1 + v2)  # <5, 7, 9>
print(v1 * v2)  # 32


# --- PRAKTYCZNY PRZYKŁAD — KONTO BANKOWE Z HISTORIĄ -------------------------

class Konto:
    def __init__(self, wlasciciel):
        self.wlasciciel = wlasciciel
        self.saldo = 0
        self.history = []

    def wplata(self, kwota):
        self.saldo += kwota
        self.history.append(f"Wpłacono: {kwota} zł")

    def wyplata(self, kwota):
        if kwota <= self.saldo:
            self.saldo -= kwota
            self.history.append(f"Wypłacono: {kwota} zł")
        else:
            self.history.append(f"Odrzucono: {kwota} zł (brak środków)")

    def __str__(self):
        return f"Konto [{self.wlasciciel}] | Saldo: {self.saldo} zł"

moje_konto = Konto('Jan')
moje_konto.wplata(100)
moje_konto.wyplata(50)
moje_konto.wyplata(200)     # odrzucone

print(moje_konto)
for wpis in moje_konto.history:
    print(f"  - {wpis}")


# --- DEKORATOR — WŁASNY ------------------------------------------------------

def my_decorator(func):
    def wrapper():
        print('Before func.')
        func()
        print('After func.')
    return wrapper

@my_decorator               # równoznaczne z: say_hello = my_decorator(say_hello)
def say_hello():
    print('Hello!')

say_hello()
# Before func.
# Hello!
# After func.


# --- OPERACJE NA PLIKACH -----------------------------------------------------

# Otwieranie i zamykanie — stary sposób (trzeba pamiętać o close!)
try:
    plik = open('plik.txt')
    tekst = plik.read()
finally:
    plik.close()    # zamknij nawet gdy błąd

# Nowoczesny sposób — with (plik zamyka się automatycznie)
with open('plik.txt') as plik:
    tekst = plik.read()             # cały plik jako jeden string

with open('plik.txt') as plik:
    znak = plik.read(1)             # tylko pierwszy znak

with open('plik.txt') as plik:
    linia1 = plik.readline()        # pierwsza linia
    linia2 = plik.readline()        # druga linia

with open('plik.txt') as plik:
    lista = plik.readlines()        # cały plik jako lista linii

# Zapis do pliku
with open('plik.txt', 'w') as plik:     # 'w' = nadpisz
    plik.write('Hello, world!\n')

with open('plik.txt', 'a') as plik:     # 'a' = dopisz na koniec
    plik.write('Nowa linia\n')

# Kodowanie — ważne przy polskich znakach!
with open('plik.txt', encoding='utf-8') as plik:
    tekst = plik.read()