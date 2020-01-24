import Data.List
import System.Random
import Data.Time.Clock
import System.IO.Unsafe
import Control.Concurrent

data Pirata = Pirata
  { nombrePirata :: String
  , botin        :: [Tesoro]
  } deriving (Show, Eq)

data Tesoro = Tesoro
  { nombreTesoro :: String
  , valor        :: Integer
  } deriving (Show, Eq)

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
  Pirata (nombrePirata pirata) (filter ((< 100) . valor) (botin pirata))

perder_tesoros_con_nombre :: String -> Pirata -> Pirata
perder_tesoros_con_nombre nombre pirata =
  Pirata
    (nombrePirata pirata)
    (filter ((/= nombre) . nombreTesoro) (botin pirata))

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





--HISTORIA
comenzar_historia :: IO (String) 
comenzar_historia = do
    putStrLn("Ahoy novato! Estas aqui para convertirte en un poderoso pirata!")
    putStrLn("Es hora de comenzar tu aventura! Pero antes...")
    protagonista <- crear_pirata
    putStrLn("Ahora es hora de salir a navegar los 7 mares! Tu historia comienza en la isla Tortuga.")
    resultado_historia <- menu_historia protagonista
    return resultado_historia

crear_pirata :: IO (Pirata)
crear_pirata = do    
    putStrLn("Cual es tu nombre?")
    nombreProtagonista <- getLine
    putStrLn("Bienvenido " ++ nombreProtagonista ++ "!")
    putStrLn("Ahora que ya tienes un nombre, solo te hace falta un botin...")
    putStrLn("... tienes un botin, verdad?")
    putStrLn("Agh... bueno, en este caso, tu botin inicial consiste en... una media sucia!")
    putStrLn("Tomala!")
    putStrLn("Si te quedas sin botin, seras expulsado de la vida pirata!")
    putStrLn("Y recuerda que el valor de tus tesoros determina tu fortaleza en combate.")
    putStrLn("\n")
    return Pirata {nombrePirata = nombreProtagonista, botin = [media_sucia]}

menu_historia :: Pirata -> IO String
menu_historia protagonista = do
    putStrLn("Que deseas realizar a continuacion?")
    putStrLn("(1)-ROBAR UN BARCO")
    putStrLn("(2)-SAQUEAR CIUDAD")
    putStrLn("(3)-RETIRARSE DE LA PIRATERIA")
    putStrLn("(4)-VER MI ESTADO")
    opcion <- getLine
    desarrollar_historia (read opcion :: Integer) protagonista 

menu_historia_con_barco :: Barco -> IO String
menu_historia_con_barco barco = do
    putStrLn("Que deseas realizar a continuacion?")
    putStrLn("(1)-ATACAR UN BARCO")
    putStrLn("(2)-ANCLAR EN UNA ISLA CERCANA")
    putStrLn("(3)-ATACAR UNA CIUDAD")
    putStrLn("(4)-RETIRARSE DE LA PIRATERIA")
    putStrLn("(5)-VER MI ESTADO")
    opcion <- getLine
    desarrollar_historia_en_barco (read opcion :: Integer) barco

desarrollar_historia :: Integer -> Pirata -> IO String 
desarrollar_historia opcion protagonista = case opcion of
     1 -> robar_barco protagonista
     2 -> elegir_ciudad_a_saquear protagonista
--     3 -> retirarse protagonista
     4 -> ver_estado protagonista
     _ -> menu_historia protagonista

desarrollar_historia_en_barco :: Integer -> Barco -> IO String
desarrollar_historia_en_barco opcion barco = case opcion of
--    1 -> atacar_barco protagonista
      2 -> anclar_en_isla_cercana barco 
      3 -> elegir_ciudad_a_asediar barco
--    4 -> retirarse protagonista
      5 -> ver_estado (head (tripulacion barco))
      _ -> menu_historia_con_barco barco





-- ACCIONES POSIBLES

robar_barco :: Pirata -> IO String
robar_barco protagonista = do
    putStrLn("Solo hay un velero triste anclado en el muelle...")
    putStrLn("Pero... que va, lo tomas y zarpas. Enhorabuena! Ahora es tuyo. Que nombre le pondras?")
    nombreVelero <- getLine
    menu_historia_con_barco Barco { tripulacion = [protagonista] , nombreBarco = nombreVelero}

anclar_en_isla_cercana :: Barco -> IO String
anclar_en_isla_cercana barco = do
    --pirata <- (head (tripulacion barco))
    isla <- islaAleatoria
    putStrLn("Los vientos de los siete mares te arrastran hacia la isla mas cercana.")
    putStrLn("En el horizonte se vislumbra el contorno de la isla " ++ (nombreIsla isla))
    putStrLn("Cuando desbarcan, ven un enorme deposito de " ++ nombreTesoro(elemento_tipico isla))
    putStrLn("Añades el tesoro a tu botin y retomas tu aventura, a la espera de que la proxima vez hagas algo mas emocionante...")
    menu_historia_con_barco $ anclar_en_isla barco isla

elegir_ciudad_a_saquear :: Pirata -> IO String
elegir_ciudad_a_saquear protagonista = do
    putStrLn("\nQue ciudad deseas saquear?")
    putStrLn("(1)-Port Royal") --MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM, MIEDO
    putStrLn("(2)-New Providence")
    eleccion <- getLine
    procesar_eleccion_ciudad eleccion protagonista

saquear_ciudad :: Pirata -> Ciudad -> IO String
saquear_ciudad protagonista ciudad = do
    putStrLn(concat ["Te dirijes con paso firme a la ciudad de " , (nombreCiudad ciudad) , " dispuesto a llevarte todos sus tesoros!!"])
    putStrLn("Pero en la entrada te detienen unos guardias con cara de pocos amigos. Te piden que te retires... Que decisión tomas?\n")
    putStrLn("(1)-SOBORNAR A LOS GUARDIAS PARA QUE TE DEN ALGUNOS TESOROS")
    putStrLn("(2)-COMBATIR CONTRA LOS GUARDIAS\n")
    eleccion <- getLine
    elegir_tipo_saqueo eleccion protagonista ciudad

sobornar_guardias :: Pirata -> Ciudad -> IO String
sobornar_guardias protagonista ciudad
  | length (botin protagonista) > 0 = soborno_exitoso protagonista ciudad
  | otherwise = soborno_imposible protagonista
    
soborno_exitoso :: Pirata -> Ciudad -> IO String
soborno_exitoso protagonista ciudad = do
    let tesoroAEntregar = unsafePerformIO (tesoroAleatorio (botin protagonista))
    putStrLn("Ofreces uno de tus tesoros a los guardias. \nEllos eligen " ++ nombreTesoro tesoroAEntregar)
    putStrLn("Lo entregas y te dan acceso a la boveda de los tesoros a cambio\n")
    menu_historia (protagonista {botin = (realizar_intercambio protagonista tesoroAEntregar (tesorosSaqueables ciudad))})

soborno_imposible :: Pirata -> IO String
soborno_imposible protagonista = return "Pero los guardias se dan cuenta que no tienes ni un doblon de oro. No vacilan en absoluto y te encierran en las mazmorras. Tus dias de pirata estan acabados."

combatir_guardias :: Pirata -> Ciudad -> IO String
combatir_guardias protagonista ciudad = do
    putStrLn("Ningun guardia en todo el caribe puede ser capaz de extorsionarte sin llevarse su merecido!")
    putStrLn("Desenvainas tu espada y te preparas para el combate")
    (resultado_combate_guardias (valorAleatorio [0,1])) protagonista ciudad

resultado_combate_guardias :: IO Int -> (Pirata -> Ciudad -> IO String)
resultado_combate_guardias resultado
  | (unsafePerformIO resultado) == 1 = ganar_combate
  | otherwise = perder_combate

ganar_combate :: Pirata -> Ciudad -> IO String
ganar_combate protagonista ciudad = do
    putStrLn("Con un golpe certero del sable desarmas a tus contrincantes, que huyen atemorizados ante tu habilidad. El tesoro queda a tu merced")
    menu_historia (protagonista { botin = (tesorosSaqueables ciudad) })

perder_combate :: Pirata -> Ciudad -> IO String
perder_combate protagonista ciudad = do
  putStrLn ("Sin embargo, tus enemigos son mas habiles de lo que esperabas. Con golpes certeros te desarman y quedas a su merced. No tienes más alternativa que entregar todos tus tesoros valiosos a cambio de que te dejen escapar.")
  evaluar_si_continua_segun_tesoros (perder_tesoros_valiosos protagonista)

evaluar_si_continua_segun_tesoros :: Pirata -> IO String
evaluar_si_continua_segun_tesoros protagonista
  | cantidad_tesoros_valiosos protagonista > 0 = menu_historia protagonista
  | otherwise = encarcelamiento protagonista

encarcelamiento :: Pirata -> IO String
encarcelamiento protagonista = return "Pero... ya no tienes tesoros que entregar! Los guardias te arrastran a la celda mas lejana de todo el calabozo. Tus dias de pirata estan acabados. Quizas tengas mas suerte la proxima vez.\nFin."


--DESDE BARCO

elegir_ciudad_a_asediar :: Barco -> IO String
elegir_ciudad_a_asediar barco = do
    putStrLn("\nQue ciudad deseas asediar?")
    putStrLn("(1)-Port Royal") --MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM, MIEDO
    putStrLn("(2)-New Providence")
    eleccion <- getLine
    procesar_eleccion_ciudad_asedio eleccion barco

bombardear_ciudad :: Barco -> Ciudad -> IO String
bombardear_ciudad barco ciudad= do
    putStrLn("El barco se alinea, mientras se preparan los cañones y apuntan al fuerte de la ciudad. Te preparas a dar la voz de mando...")
    suspenso(1)
    putStrLn("PREPAREN")
    suspenso(1)
    putStrLn("APUNTEN")
    suspenso(2)
    putStrLn("FUEGOO!")
    suspenso(1)
    (resultado_asedio (valorAleatorio [0,1])) barco ciudad

resultado_asedio :: IO Int -> (Barco -> Ciudad -> IO String)
resultado_asedio resultado_asedio
  | (unsafePerformIO resultado_asedio) == 1 = invadir_ciudad
  | otherwise = ser_repelidos_por_ciudad

invadir_ciudad :: Barco -> Ciudad -> IO String
invadir_ciudad barco ciudad = do
    putStrLn("Las murallas estallan en pedazos y rapidamente te escabulles dentro del fuerte de la ciudad buscando un botin")
    botin_adquirido <- tesoroAleatorio( tesorosSaqueables ciudad )
    putStrLn("Los guardias te persiguen por lo que solo eres capaz de tomar un " ++ nombreTesoro botin_adquirido ++ " antes de volver a embarcar.")
    let protagonista = head(tripulacion barco)
    let protagonista_con_tesoro = protagonista { botin = botin (protagonista) ++ [botin_adquirido] }
    menu_historia_con_barco (barco { tripulacion = protagonista_con_tesoro:(drop 1 (tripulacion barco))})

ser_repelidos_por_ciudad :: Barco -> Ciudad -> IO String
ser_repelidos_por_ciudad barco ciudad = do
    putStrLn("... pero")
    suspenso(1)
    putStrLn("Nada ha pasado.")
    suspenso(1)
    putStrLn("Quizas hubiese sido buena idea revisar el estado de la polvora antes de atacar...")
    putStrLn("Demasiado tarde! Los cañones del fuerte arrasan con tu nave y de pronto te encuentras escupiendo agua y arena en la playa. El mar te arranco algunos tesoro. Sin embargo, aun puedes asaltar la ciudad a pie...")
    let protagonista = head (tripulacion barco)
    saquear_ciudad (protagonista { botin = unsafePerformIO (tesorosAleatorios (botin (protagonista))) }) ciudad

--- FUNCIONES AUXILIARES

tesoroAleatorio :: [Tesoro] -> IO Tesoro 
tesoroAleatorio tesoros = valorAleatorio tesoros

tesorosAleatorios :: [Tesoro] -> IO [Tesoro] 
tesorosAleatorios tesoros = valoresAleatorios tesoros

islaAleatoria :: IO Isla 
islaAleatoria =  valorAleatorio islas

valorAleatorio :: [a] -> IO a
valorAleatorio list = do
    i <- getStdRandom (randomR (0, length list - 1)) 
    return $ list !! i

valoresAleatorios :: [a] -> IO [a]
valoresAleatorios list = do
    i <- getStdRandom (randomR (0, length list)) 
    return $ take i list 

confirmar :: String -> IO Bool
confirmar mensaje_a_confirmar = do
    putStrLn (mensaje_a_confirmar)
    putStrLn ("(s)i/(n)o")
    confirmacion <- getLine
    procesar_confirmacion confirmacion

procesar_confirmacion :: String -> IO Bool
procesar_confirmacion confirmacion 
  | elem confirmacion ["s", "S"] = return True
  | elem confirmacion ["n", "N"] = return False
  | otherwise = confirmar "Has ingresado una opcion incorrecta. Por favor, ingrese"

procesar_eleccion_ciudad :: String -> Pirata -> IO String    
procesar_eleccion_ciudad eleccion protagonista
  | eleccion == "1" = saquear_ciudad protagonista port_royal
  | eleccion == "2" = saquear_ciudad protagonista new_providence
  | otherwise = elegir_ciudad_a_saquear protagonista

procesar_eleccion_ciudad_asedio :: String -> Barco -> IO String   
procesar_eleccion_ciudad_asedio eleccion barco 
  | eleccion == "1" = bombardear_ciudad barco port_royal
  | eleccion == "2" = bombardear_ciudad barco new_providence
  | otherwise = elegir_ciudad_a_asediar barco 

realizar_intercambio :: Pirata -> Tesoro -> [Tesoro] -> [Tesoro]    
realizar_intercambio protagonista tesoroAEntregar tesorosSaqueables =  recibir_tesoros (entregar_tesoro (botin protagonista) tesoroAEntregar) tesorosSaqueables

elegir_tipo_saqueo :: String -> Pirata -> Ciudad -> IO String
elegir_tipo_saqueo eleccion protagonista ciudad
  | eleccion == "1" = sobornar_guardias protagonista ciudad
  | eleccion == "2" = combatir_guardias protagonista ciudad
  | otherwise = saquear_ciudad protagonista ciudad

recibir_tesoros :: [Tesoro] -> [Tesoro] -> [Tesoro]
recibir_tesoros botin tesorosSaqueables = botin ++ (unsafePerformIO (tesorosAleatorios tesorosSaqueables))

entregar_tesoro :: [Tesoro] -> Tesoro -> [Tesoro]
entregar_tesoro tesoros tesoroAEntregar = delete tesoroAEntregar tesoros

ver_estado :: Pirata -> IO String
ver_estado protagonista = do
    putStrLn("\n")
    putStrLn(show protagonista)
    putStrLn("\n")
    menu_historia protagonista

cantidad_tesoros_valiosos :: Pirata -> Int 
cantidad_tesoros_valiosos pirata =
   length (filter ((not . (< 100) . valor)) (botin pirata))

suspenso :: Int -> IO () 
suspenso segundos = threadDelay (1000000 * segundos)
