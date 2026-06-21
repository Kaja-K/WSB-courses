# ==============================================================================
# NOTATKI R — CHEATSHEET
# ==============================================================================

# --- PODSTAWOWE OPERACJE ------------------------------------------------------

5 + 8           # 13
sin(pi/2)       # 1
log(2.718282)   # ~1
sum(1,4,3,6,4,3,7,2,3,4)   # 37
factorial(10)   # 3628800


# --- PRINT --------------------------------------------------------------------

print(sin(60*pi/180), digits = 11)              # 0.86602540378
print("Napis w cudzysłowie",  quote = TRUE)     # "Napis w cudzysłowie"
print("Napis bez cudzysłowu", quote = FALSE)    # Napis bez cudzysłowu
print.default(c(1,3,NA,5,3,NA,NA,14), na.print = "Brak wartości")
# 1 3 Brak wartości 5 3 Brak wartości Brak wartości 14


# --- ZMIENNE — PRZYPISANIE ----------------------------------------------------

zmienna  =  2^10    # przez =
zmienna2 <- 2^10    # przez <- (zalecane)
2^10     -> zmienna3  # przez -> (rzadziej używane)

zmienna   # 1024
zmienna2  # 1024

# wynik przypisania NIE jest wyświetlany automatycznie
wynik <- 2 + 2      # brak wydruku
print(wynik)        # 4

wynik <- sin(pi/6)
print(wynik)        # 0.5


# --- TYPY ZMIENNYCH -----------------------------------------------------------

a <- c(1.8, 4.5)              # numeric
b <- c(1 + 2i, 3 - 6i)        # complex
d <- c(23L, 44L)               # integer (sufiks L)

# mieszane typy → R konwertuje do najbardziej ogólnego
t <- c("Time", 24, "October", TRUE, 3.33)  # → character
o <- c(TRUE, 24)                            # → numeric (TRUE=1, FALSE=0)
d <- c(2.5, "May")                          # → character

class(a)   # "numeric"
class(t)   # "character"

# konwersja typów
bar <- 0:5
class(bar)           # "integer"
bar2 <- as.numeric(bar);   class(bar2)    # "numeric"
bar3 <- as.character(bar); class(bar3)    # "character"
bar4 <- as.logical(c(0,1,1,0)); bar4     # FALSE TRUE TRUE FALSE


# --- WEKTORY ------------------------------------------------------------------

# pojedyncza wartość to też wektor (jednoelementowy)
4           # [1] 4

# tworzenie wektorem funkcją c()
c(3, 4, 5)
co_drugi <- c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)  # logiczny
literki  <- c("alfa", "beta", "gamma", "delta")       # tekstowy

# sekwencja liczb — funkcja seq()
sekwencja <- seq(from = 0, to = 10, by = 0.1)
sekwencja <- seq(by = 0.1, from = 0, to = 10)   # kolejność arg. dowolna
sekwencja <- seq(0, 10, 0.1)                     # skrócona forma
# wynik: 101 liczb od 0.0 do 10.0 z krokiem 0.1

# szybka sekwencja całkowita
1:5   # 1 2 3 4 5


# --- INDEKSOWANIE WEKTORA -----------------------------------------------------

LETTERS          # wbudowany wektor 26 liter A–Z
length(LETTERS)  # 26

LETTERS[1]                  # "A"  — pierwszy element
LETTERS[5]                  # "E"  — piąty element
LETTERS[26]                 # "Z"  — ostatni element
LETTERS[length(LETTERS)]    # "Z"  — to samo, bez hardkodowania indeksu

# indeksowanie warunkiem logicznym
LETTERS > "K"               # wektor TRUE/FALSE
LETTERS[LETTERS > "K"]      # "L" "M" "N" ... "Z"

# indeksowanie ujemne — wyklucza elementy
LETTERS[-1]         # wszystkie bez pierwszego
LETTERS[-c(1,2,3)]  # wszystkie bez pierwszych trzech

# UWAGA: nie można mieszać indeksów + i - jednocześnie!


# --- LISTA --------------------------------------------------------------------

# lista może przechowywać elementy RÓŻNYCH typów
my_list <- list(22, "ab", TRUE, 1 + 2i)
my_list[[1]]   # 22
my_list[[2]]   # "ab"
my_list[[3]]   # TRUE
my_list[[4]]   # 1+2i


# --- MACIERZE I TABLICE -------------------------------------------------------

# rbind() — łączy wektory wiersz pod wierszem
tablica3 <- rbind(c(1,8,10), c(-7,3,-5), c(1,-8,-5), c(-3,-2,-3))
tablica3
#      [,1] [,2] [,3]
# [1,]    1    8   10
# [2,]   -7    3   -5
# [3,]    1   -8   -5
# [4,]   -3   -2   -3

tablica3[2,3]   # -5  (wiersz 2, kolumna 3)
tablica3[3,1]   # 1   (wiersz 3, kolumna 1)

# matrix() — tworzy macierz (tablica 2D)
my_matrix <- matrix(1:6, nrow = 3, ncol = 2)
my_matrix
#      [,1] [,2]
# [1,]    1    4
# [2,]    2    5
# [3,]    3    6

dim(my_matrix)   # 3 2


# --- RAMKA DANYCH (data.frame) -----------------------------------------------

dwie_kolumny <- data.frame(litery = c("A", "B", "C"),
                           liczby = c(1, 2, 3))
dwie_kolumny

# indeksowanie wierszy: [wiersze, kolumny]  — pusta kolumna = wszystkie kolumny
# (zakładamy wczytany zbiór koty_ptaki)
# koty_ptaki[c(3, 8:10), ]        # wiersze 3, 8, 9, 10
# koty_ptaki[-c(1, 3, 8:10), ]    # wszystkie POZA 1, 3, 8, 9, 10

# podgląd
# head(koty_ptaki)   # pierwsze 6 wierszy
# tail(koty_ptaki)   # ostatnie 6 wierszy

# sortowanie przez indeksowanie
# kolejnosc <- order(koty_ptaki[,"predkosc"])
# koty_ptaki[kolejnosc, ]


# --- WCZYTYWANIE DANYCH -------------------------------------------------------

# z pliku CSV (tekstowego)
# koty_ptaki <- read.table(
#   file   = "http://biecek.pl/MOOC/dane/koty_ptaki.csv",
#   sep    = ";",
#   dec    = ",",
#   header = TRUE
# )

# pełna sygnatura read.table():
# read.table(file, header=FALSE, sep="", dec=".", nrows=-1,
#            skip=0, comment.char="#", stringsAsFactors=...)

# z pliku binarnego .rda
# load(url("http://biecek.pl/MOOC/dane/koty_ptaki.rda"))
# (load() NIE zwraca wartości — ładuje zmienną bezpośrednio do środowiska)

# przez web API
# install.packages("SmarterPoland")
# library(SmarterPoland)
# tsdtr210 <- getEurostatRCV("tsdtr210")
# head(tsdtr210, 3)
# summary(tsdtr210)


# --- ZAPISYWANIE DANYCH -------------------------------------------------------

# write.table(dwie_kolumny, file = "wazne_dane.csv", sep = ";", dec = ".")

# sprawdzenie katalogu roboczego
# getwd()
# setwd("/inna/sciezka")  # zmiana katalogu roboczego

# pełna sygnatura write.table():
# write.table(x, file="", append=FALSE, quote=TRUE, sep=" ",
#             eol="\n", na="NA", dec=".", row.names=TRUE,
#             col.names=TRUE, qmethod=c("escape","double"), fileEncoding="")


# --- OPERATORY LOGICZNE -------------------------------------------------------

# porównania: ==  !=  >  >=  <  <=
2*2 == 4    # TRUE
7 > 3       # TRUE
-7 > -3     # FALSE
-7 >= -3    # FALSE

# na całym wektorze naraz
c(2,3,5,2,4) == 2   # TRUE FALSE FALSE TRUE FALSE

# łączenie warunków
x <- 10
(x > 7 && x < 15)   # TRUE  — logiczne "i"
(x == 3 || x == 5)  # FALSE — logiczne "lub"
(!is.matrix(x))     # TRUE  — negacja


# --- IF / ELSE / IFELSE -------------------------------------------------------

x <- 10
if (x > 5) {
  print("x jest większe od 5")
} else {
  print("x jest mniejsze lub równe 5")
}

# ifelse() — wektoryzowana wersja (działa na całym wektorze)
v <- c(1, -2, 3, -4)
ifelse(v > 0, "dodatnia", "ujemna")   # "dodatnia" "ujemna" "dodatnia" "ujemna"


# --- PĘTLE --------------------------------------------------------------------

# FOR — dla każdej wartości z zakresu
for (i in 1:5) {
  cat("i =", i, "\n")
}

# WHILE — dopóki warunek spełniony
licznik <- 5
while (licznik > 0) {
  print(paste("Licznik:", licznik))
  licznik <- licznik - 1
}

# REPEAT — nieskończona pętla; wymagane break do zatrzymania
repeat {
  wylosowana <- sample(1:10, size = 1)
  print(paste("Wylosowano:", wylosowana))
  if (wylosowana == 7) {
    print("Znaleziono 7! Stop.")
    break
  }
}

# przydatne funkcje losujące
runif(n = 1, min = 0, max = 10)    # losowa liczba rzeczywista z [0, 10]
sample(1:10, size = 1)             # losowa liczba całkowita z {1..10}
round(3.7)                         # 4 — zaokrąglenie


# --- FUNKCJE ------------------------------------------------------------------

# deklaracja
rysuj_kropki <- function(n_kropek) {
  for (j in 1:n_kropek) {
    cat(".")
  }
}
rysuj_kropki(n_kropek = 20)   # ....................

# argumenty domyślne
rysuj_kropki2 <- function(n_kropek = 20, znak = ".") {
  if (n_kropek > 0) {
    for (j in 1:n_kropek) cat(znak)
  }
}
rysuj_kropki2()              # ....................
rysuj_kropki2(5)             # .....
rysuj_kropki2(znak = "X")   # XXXXXXXXXXXXXXXXXXXX
rysuj_kropki2(znak = "X", n_kropek = 5)  # XXXXX  (kolejność dowolna, ale z nazwami)

# return — R automatycznie zwraca ostatnie wyrażenie
dodaj_liczby <- function(a, b) {
  wynik <- a + b
  wynik           # implicit return
}
dodaj_liczby(5, 10)   # 15

# return() — używamy gdy chcemy wyjść wcześniej
podziel_liczby <- function(a, b) {
  if (b == 0) return("Błąd: dzielenie przez zero!")
  a / b
}
podziel_liczby(10, 0)   # "Błąd: dzielenie przez zero!"
podziel_liczby(10, 2)   # 5


# --- FUNKCJE MATEMATYCZNE -----------------------------------------------------

sin(30*pi/180)   # 0.5  — kąt w radianach: stopnie * pi/180
cos(0)           # 1
tan(pi/4)        # 1
log(exp(1))      # 1    — logarytm naturalny
log10(1000)      # 3    — logarytm dziesiętny
log2(8192)       # 13   — logarytm o podstawie 2
logb(27, 3)      # 3    — logarytm o podstawie 3
exp(1)           # 2.718...
sqrt(16)         # 4
abs(-7)          # 7
factorial(5)     # 120
round(3.14159, digits = 2)   # 3.14
ceiling(3.2)     # 4    — zaokrąglenie w górę
floor(3.9)       # 3    — zaokrąglenie w dół


# --- PROSTY WYKRES (base R) ---------------------------------------------------

sekwencja <- seq(0, 10, 0.1)
poziom    <- exp(sekwencja)

plot(x    = sekwencja,
     y    = poziom,
     xlab = "czas spędzony z R",
     ylab = "poziom Data Science we krwi")


# --- GGPLOT2 — WIZUALIZACJA ---------------------------------------------------

# install.packages("ggplot2")
# library(ggplot2)

# --- histogram (podstawowy)
# ggplot(df, aes(x = Average_income)) +
#   geom_histogram()

# --- histogram (z formatowaniem)
# ggplot(df, aes(x = Average_income)) +
#   geom_histogram(color = "black", fill = "steelblue") +
#   labs(x = "Average Income", y = "Frequency") +
#   ggtitle("Histogram of Average Income") +
#   theme_minimal()

# --- scatter plot z linią regresji
# ggplot(data = Cars93, aes(x = Weight, y = MPG.city)) +
#   geom_point(aes(color = "red")) +
#   geom_smooth(method = "lm") +   # linia regresji liniowej
#   labs(title = "Weight vs City MPG",
#        x = "Weight of Car (in pounds)",
#        y = "City Miles per Gallon")

# --- pie chart (wykres kołowy)
# ggplot(data, aes(x = "", y = amount, fill = category)) +
#   geom_bar(stat = "identity", width = 1) +
#   coord_polar("y", start = 0) +   # zamienia słupkowy w kołowy
#   geom_text(aes(label = paste0(amount, " %")),
#             position = position_stack(vjust = 0.5)) +
#   labs(x = NULL, y = NULL, fill = NULL)
