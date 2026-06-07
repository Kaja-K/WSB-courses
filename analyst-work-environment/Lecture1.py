# coding: utf-8

# =============================================================================
# LECTURE 1 — PYTHON CHEATSHEET
# =============================================================================


# --- TYPY DANYCH I ZMIENNE ---------------------------------------------------

a = 5           # int
b = 3.14        # float
c = 3 + 2j      # complex

type(a)         # <class 'int'>
type(a) is int  # True
dir(a)          # lista metod i atrybutów obiektu


# --- PRINT I FORMATOWANIE TEKSTU ---------------------------------------------

print('hello', 42, 3.14)   # hello 42 3.14

imie = 'Jan'
print(f'Cześć, {imie}!')                    # f-string (najwygodniejsze)
print('Cześć, {}!'.format(imie))            # .format()

print('linia1\nlinia2')     # \n = nowa linia, \t = tabulator
print(r'C:\testy')          # r'' wyłącza znaki ucieczki


# --- OPERATORY ---------------------------------------------------------------

# arytmetyczne
10 + 2      # 12
10 / 3      # 3.333... — dzielenie ZAWSZE zwraca float
10 // 3     # 3         — dzielenie całkowite
10 % 3      # 1         — reszta z dzielenia (modulo)
2 ** 8      # 256       — potęgowanie

# skrócone przypisanie
a = 10
a += 1      # a = a + 1
a -= 1      # a = a - 1
a *= 2      # a = a * 2
a //= 3     # a = a // 3
a **= 2     # a = a ** 2

# porównania
a, b = 1, 2
a < b       # True
a == b      # False
a != b      # True
a >= b      # False

# logiczne
True and False  # False
True or False   # True
not True        # False


# --- WARTOŚCI LOGICZNE — TRUTHINESS ------------------------------------------

# Falsy (dają False)
bool(0)         # False
bool(0.0)       # False
bool("")        # False — pusty string
bool([])        # False — pusta lista
bool({})        # False — pusty słownik
bool(None)      # False

# Truthy (dają True)
bool("Anna")    # True
bool([1, 2])    # True
bool(42)        # True


# --- WARUNKI -----------------------------------------------------------------

import random
a = random.randint(0, 10)

if a == 0:
    print('zero')
elif a % 2 == 0:
    print(a, 'parzysta')
else:
    print(a, 'nieparzysta')


# --- PĘTLE -------------------------------------------------------------------

# while
i = 0
while i < 3:
    print(i)    # 0, 1, 2
    i += 1

# nieskończona pętla + break
while True:
    decyzja = input("Wpisz 'q' aby wyjść: ")
    if decyzja == 'q':
        break
    print(f'Wpisałeś: {decyzja}')

# for + range
for i in range(5):          # 0, 1, 2, 3, 4
    print(i)

for i in range(1, 10, 2):  # 1, 3, 5, 7, 9 (start, stop, krok)
    print(i)

# break, continue
for x in range(1, 6):
    if x == 3:
        continue    # pomiń 3
    if x == 5:
        break       # zatrzymaj przed 5
    print(x)        # 1, 2, 4

# for po liście
owoce = ['jabłko', 'banan', 'wiśnia']
for owoc in owoce:
    print(owoc)

# for po stringu
for litera in 'Python':
    print(litera.upper())


# --- WYJĄTKI -----------------------------------------------------------------

try:
    wynik = 10 / 0
except ZeroDivisionError:
    print('dzielenie przez zero!')
except ValueError:
    print('zła wartość')
else:
    print('sukces, wynik:', wynik)  # tylko gdy brak błędu
finally:
    print('zawsze się wykona')      # zawsze, niezależnie od błędu

# ignorowanie opcjonalnej biblioteki
try:
    import opcjonalna_lib
except ImportError:
    pass    # działamy bez niej


# --- LISTA -------------------------------------------------------------------

lst = [1, 'dwa', 3.0]
lst[0]              # 1    (pierwszy element)
lst[-1]             # 3.0  (ostatni element)
lst[1:3]            # ['dwa', 3.0]  (slice)

lst.append(4)       # dodaj na koniec
lst.insert(1, 'x')  # wstaw na pozycji 1
lst.extend([5, 6])  # rozszerz o inną listę
lst.remove('dwa')   # usuń pierwszą wartość 'dwa'
del lst[0]          # usuń po indeksie
len(lst)            # liczba elementów


# --- KROTKA (tuple) ----------------------------------------------------------

# niemutowalna — nie można zmieniać elementów po utworzeniu
t = (1, 'dwa', 3, 'dwa')
t[2]            # 3
t[1:3]          # ('dwa', 3)
t.index('dwa')  # 1  — indeks pierwszego wystąpienia
t.count('dwa')  # 2  — ile razy wystąpiło


# --- SŁOWNIK (dict) ----------------------------------------------------------

d = {'a': 1, 'b': 2, 'c': 3.5}
d['a']          # 1
d['c'] = 99     # zmień wartość
d['nowy'] = 0   # dodaj nowy klucz
del d['b']      # usuń parę
'a' in d        # True — sprawdź czy klucz istnieje

d.keys()        # widok kluczy
d.values()      # widok wartości
d.items()       # widok par (klucz, wartość)

# tworzenie przez dict()
nukleotydy = dict(A='Adenina', C='Cytozyna', G='Guanina', T='Tymina')


# --- ZBIÓR (set) -------------------------------------------------------------

s = {1, 2, 2, 3}   # {1, 2, 3} — duplikaty znikają automatycznie
pusty = set()       # UWAGA: {} tworzy pusty słownik, nie zbiór!

s.add(4)
s.discard(9)        # usuń — nie rzuca błędu gdy elementu nie ma
s.remove(1)         # usuń — rzuca KeyError gdy elementu nie ma

# operacje na zbiorach
a = {1, 2, 3}
b = {2, 3, 4}
a | b   # {1,2,3,4}  — suma
a & b   # {2,3}      — część wspólna
a - b   # {1}        — różnica
a ^ b   # {1,4}      — różnica symetryczna

# usuwanie duplikatów z listy
lista = [1, 1, 2, 3, 3]
unikalne = list(set(lista))     # [1, 2, 3]


# --- FROZENSET — niemutowalny zbiór ------------------------------------------

fs = frozenset([1, 2, 3, 3])   # frozenset({1, 2, 3})
# fs.add(4)  → AttributeError — nie można modyfikować


# --- ŁAŃCUCH ZNAKÓW (str) ----------------------------------------------------

s = 'Python'
s[0]                # 'P'
s[2:5]              # 'tho'
s.upper()           # 'PYTHON'
s.lower()           # 'python'

# podział i łączenie
'a,b,c'.split(',')          # ['a', 'b', 'c']
';'.join(['a', 'b', 'c'])   # 'a;b;c'


# --- MODUŁY I IMPORTOWANIE ---------------------------------------------------

import math
print(math.pi)              # 3.14159...
print(math.cos(math.pi))    # -1.0

from math import pi, cos    # importuj konkretne obiekty
cos(pi)                     # -1.0

from math import *          # wszystko — ostrożnie, może nadpisać nazwy!


# --- KONWERSJA TYPÓW ---------------------------------------------------------

int('42')           # 42
int(3.99)           # 3    — obcina, nie zaokrągla!
float('3.14')       # 3.14
str(100)            # '100'
bool(0)             # False
list((1, 2, 3))     # [1, 2, 3]
tuple([1, 2, 3])    # (1, 2, 3)
set([1, 1, 2])      # {1, 2}
list('abc')         # ['a', 'b', 'c']


# --- ROZPAKOWANIE KOLEKCJI ---------------------------------------------------

x, y = (1, 2)               # x=1, y=2
a, b, c = [10, 20, 30]      # a=10, b=20, c=30


# --- ENUMERATE ---------------------------------------------------------------

# zwraca pary (indeks, wartość) — przydatne gdy potrzebujemy numeru pozycji
owoce = ['jabłko', 'banan', 'wiśnia']

for i, owoc in enumerate(owoce):
    print(i, owoc)
# 0 jabłko
# 1 banan
# 2 wiśnia

list(enumerate(owoce))
# [(0, 'jabłko'), (1, 'banan'), (2, 'wiśnia')]


# --- PASS — INSTRUKCJA PUSTA -------------------------------------------------

# placeholder: funkcja, którą dopiszemy później
def todo_funkcja():
    pass

# ignorowanie błędu importu
try:
    import opcjonalna_lib
except ImportError:
    pass

# pusta klasa wyjątku
class MojError(Exception):
    pass