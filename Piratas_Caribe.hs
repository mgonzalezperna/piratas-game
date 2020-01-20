module Piratas_Caribe where

import Data.List
import Data.Function (on)

data Pirata = Pirata
  { nombrePirata :: String
  , botin        :: [Tesoro]
  } deriving (Eq)

instance Show Pirata where
  show pirata = nombrePirata pirata ++ "\n\nBotin: " ++ show (botin pirata)

data Tesoro = Tesoro
  { nombreTesoro :: String
  , valor        :: Integer
  } deriving (Eq)

instance Show Tesoro where
  show tesoro = " " ++ nombreTesoro tesoro ++ ": $" ++ show (valor tesoro) ++ " " 

data Barco = Barco
   { tripulacion :: [Pirata]
   , nombreBarco    :: String
   } deriving (Show, Eq)

data Isla = Isla
   { elemento_tipico :: Tesoro
   , nombreIsla    :: String
   } deriving (Show, Eq)

data Ciudad = Ciudad
    { nombreCiudad :: String
    , tesorosSaqueables :: [Tesoro] 
    } deriving (Show, Eq)

--TESOROS
auricularesChetos :: Tesoro
auricularesChetos =
  Tesoro {nombreTesoro = "Auriculares Shure SRH 440", valor = 6000}

zapatillasViotti :: Tesoro
zapatillasViotti = Tesoro {nombreTesoro = "Zapatillas Mike", valor = 400}

zapatillasDini :: Tesoro
zapatillasDini = Tesoro {nombreTesoro = "Zapatillas Mike", valor = 500}

biciCopada :: Tesoro
biciCopada = Tesoro {nombreTesoro = "Bicicleta GT Avalanche", valor = 25000}

brujula :: Tesoro
brujula = Tesoro {nombreTesoro = "Brujula", valor = 10000}

frascoJack :: Tesoro
frascoJack = Tesoro {nombreTesoro = "Frasco de arena", valor = 0}

frascoAnne :: Tesoro
frascoAnne = Tesoro {nombreTesoro = "Frasco de arena", valor = 1}

cajitaMusical :: Tesoro
cajitaMusical = Tesoro {nombreTesoro = "Cajita Musical", valor = 1}

doblones :: Tesoro
doblones = Tesoro {nombreTesoro = "Doblones", valor = 100}

moneda :: Tesoro
moneda = Tesoro {nombreTesoro = "Moneda del cofre muerto", valor = 100}

espada :: Tesoro
espada = Tesoro {nombreTesoro = "Espada de hierro", valor = 50}

cuchillo :: Tesoro
cuchillo = Tesoro {nombreTesoro = "Cuchillo", valor = 5}

oro :: Tesoro
oro = Tesoro {nombreTesoro = "Oro", valor = 75000}

ron :: Tesoro
ron = Tesoro {nombreTesoro = "Ron", valor = 25}

media_sucia :: Tesoro
media_sucia = Tesoro {nombreTesoro = "Media sucia", valor = 1}

--PIRATAS
viotti :: Pirata
viotti =
  Pirata
    { nombrePirata = "Viotti el terrible"
    , botin = [auricularesChetos, zapatillasViotti]
    }

dini :: Pirata
dini =
  Pirata
    {nombrePirata = "Dini el magnifico", botin = [biciCopada, zapatillasDini]}

jackSparrow :: Pirata
jackSparrow =
  Pirata {nombrePirata = "Jack Sparrow", botin = [brujula, frascoJack]}

davidJones :: Pirata
davidJones = Pirata {nombrePirata = "David Jones", botin = [cajitaMusical]}

anneBonny :: Pirata
anneBonny = Pirata {nombrePirata = "Anne Bonny", botin = [doblones, frascoAnne]}

elizabethSwann :: Pirata
elizabethSwann = Pirata {nombrePirata = "Elizabeth Swann", botin = [moneda, espada]}

piratas :: [Pirata]
piratas = [viotti, dini, jackSparrow, davidJones, anneBonny, elizabethSwann]

--BARCOS
perla = Barco { tripulacion = [jackSparrow, anneBonny] , nombreBarco = "Perla Negra"}
holandes = Barco { tripulacion = [davidJones]  , nombreBarco = "Holandes Errante"}

barcos :: [Barco]
barcos = [perla, holandes]

--ISLAS
isla_tortuga = Isla { elemento_tipico = frascoAnne, nombreIsla = "Isla Tortuga" }
isla_ron = Isla { elemento_tipico = ron, nombreIsla = "Isla del Ron" }

islas :: [Isla]
islas = [isla_tortuga, isla_ron]

--CIUDADES
port_royal = Ciudad { nombreCiudad = "Port Royal", tesorosSaqueables = [brujula] }
new_providence = Ciudad { nombreCiudad = "Nueva Providencia", tesorosSaqueables = [oro, ron, doblones] }

ciudades :: [Ciudad]
ciudades = [port_royal, new_providence]

--TESOROS PIRATAS
cantidad_tesoros :: Pirata -> Int
cantidad_tesoros pirata = length (botin pirata)

es_afortunado :: Pirata -> Bool
es_afortunado = (> 10000) . sum . valores_tesoros

valores_tesoros :: Pirata -> [Integer]
valores_tesoros pirata = map valor (botin pirata)

comparar_nombres_tesoros :: Tesoro -> Tesoro -> Bool
comparar_nombres_tesoros tesoro_1 tesoro_2 =
  nombreTesoro tesoro_1 == nombreTesoro tesoro_2

comparar_valores_tesoros :: Tesoro -> Tesoro -> Bool
comparar_valores_tesoros tesoro_1 tesoro_2 = valor tesoro_1 /= valor tesoro_2

comparar_valores_de_nombres_iguales :: Tesoro -> Tesoro -> Bool
comparar_valores_de_nombres_iguales tesoro_1 tesoro_2 =
  comparar_nombres_tesoros tesoro_1 tesoro_2 &&
  comparar_valores_tesoros tesoro_1 tesoro_2

cumpleCondicion :: [Tesoro] -> Tesoro -> Bool
cumpleCondicion botin tesoro =
  any (comparar_valores_de_nombres_iguales tesoro) botin

tienen_mismo_tesoro_y_valor_diferente :: Pirata -> Pirata -> Bool
tienen_mismo_tesoro_y_valor_diferente pirata =
  any (cumpleCondicion (botin pirata)) . botin

valor_tesoro_mas_valioso :: Pirata -> Integer
valor_tesoro_mas_valioso = maximum . valores_tesoros

adquirir_tesoro :: Pirata -> Tesoro -> Pirata
adquirir_tesoro pirata tesoro =
  Pirata (nombrePirata pirata) (tesoro : (botin pirata))

perder_tesoros_valiosos :: Pirata -> Pirata
perder_tesoros_valiosos pirata =
  Pirata (nombrePirata pirata) (filter (not . es_valioso) (botin pirata))

perder_tesoros_con_nombre :: String -> Pirata -> Pirata
perder_tesoros_con_nombre nombre pirata =
  Pirata
    (nombrePirata pirata)
    (filter ((/= nombre) . nombreTesoro) (botin pirata))

es_valioso :: Tesoro -> Bool
es_valioso = (>= 100) . valor

tesoro_mas_valioso :: [Tesoro] -> Tesoro
tesoro_mas_valioso tesoros = maximumBy (compare `on` valor) tesoros

--TEMPORADA DE SAQUEOS
saquear :: Pirata -> (Tesoro -> Bool) -> Tesoro -> Pirata
saquear pirata forma_saqueo tesoro 
  | forma_saqueo tesoro = adquirir_tesoro pirata tesoro
  | otherwise = pirata

solo_tesoros_valiosos :: Tesoro -> Bool 
solo_tesoros_valiosos = (>100) . valor

solo_tesoros_especificos :: String -> Tesoro -> Bool 
solo_tesoros_especificos clave = (==clave) . nombreTesoro 

pirata_con_corazon :: Tesoro -> Bool 
pirata_con_corazon tesoro = False

--Nota: condicion de cumplimiento del any
evaluar :: Tesoro -> (Tesoro -> Bool) -> Bool
evaluar tesoro forma = forma tesoro

forma_compleja :: [(Tesoro -> Bool)] -> Tesoro -> Bool
forma_compleja formas tesoro = any (evaluar tesoro) formas


-- NAVEGANDO LOS SIETE MARES
incorporar_a_tripulacion :: Pirata -> Barco -> Barco
incorporar_a_tripulacion pirata barco = Barco ((tripulacion barco) ++ [pirata]) (nombreBarco barco)

abandonar_tripulacion :: Pirata -> Barco -> Barco
abandonar_tripulacion pirata barco =  Barco (delete pirata (tripulacion barco)) (nombreBarco barco)

anclar_en_isla :: Barco -> Isla -> Barco
anclar_en_isla barco isla = Barco (tomar_tesoros (tripulacion barco) (elemento_tipico isla)) (nombreBarco barco)

tomar_tesoros :: [Pirata] -> Tesoro -> [Pirata]
tomar_tesoros tripulacion tesoro = map (flip adquirir_tesoro tesoro) tripulacion

--Nota: cada barco tiene una forma definida de saquear
atacar_ciudad :: Ciudad -> Barco -> (Tesoro -> Bool) -> Barco
atacar_ciudad ciudad barco forma_saqueo = Barco (repartir_tesoros (tripulacion barco) forma_saqueo (tesorosSaqueables ciudad)) (nombreBarco barco)

repartir_tesoros :: [Pirata] -> (Tesoro -> Bool) -> [Tesoro] -> [Pirata]
repartir_tesoros (pirata:piratas) forma_saqueo (tesoro:tesoros) = saquear pirata forma_saqueo tesoro : repartir_tesoros piratas forma_saqueo tesoros
--condicion corte cuando hay mas tesoros que piratas
repartir_tesoros [] forma_saqueo (tesoro:tesoros) = [] 
--condicion de corte cuando hay mas piratas que tesoros 
repartir_tesoros (pirata:piratas) forma_saqueo [] = []
--condicion de corte si hay igual cantidad de piratas que tesoros
repartir_tesoros [] forma_saqueo [] = []