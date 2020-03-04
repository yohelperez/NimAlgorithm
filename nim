function mostrarTabla(tabla) {
    texto = ""
    for (i in tabla) {
        texto += tabla[i]
        texto += "<br/> "
    }
    return texto
}

/**
 * Genera un arreglo que representa el número de elementos del tablero de juego en binario.
 * @param {Array} tabla  Arreglo que contiene la cantidad de elementos en cada fila,
 * cada indice representa la fila y el contenido representa el número de piezas presentes. 
 * @returns {Array} tablaBinario matriz que representa el número de piezas del tablero en binario.
 * cada indice contiene un arreglo correspondiente al número de piezas por fila en binario.
 */
function tablaBinario(tabla) {
    var tablaBinario = [];
    var numBinario = [];
    var fila = [];

    for (i in tabla) {
        fila = ["0", "0", "0", "0", "0"];
        numBinario = tabla[i].toString(2);

        tablaBinario.push(numBinario.split(""));
        if (tablaBinario[i].length < 5) {
            while (tablaBinario[i].length < 5) {    //desplaza los digitos hacia la derecha para que todos tengan la misma longitud
                tablaBinario[i].unshift('0');
            }
        }

    }
    return tablaBinario;
}

/**
 * Indica la cantidad de piezas que se deben remover de una fila específica para realizar
 * una jugada ganadora, cuando pierde quien quita la última pieza
 * @param {Array} tabla Arreglo que contiene la cantidad de elementos en cada fila,
 * cada indice representa la fila y el contenido representa el número de piezas presentes. 
 * @param {Array} tablaBinario Contiene el número de elementos en cada fila en binario.
 * @returns {Array} El primer elemento representa la fila donde se retirarán las piezas y el segundo
 * la cantidad de piezas.
 */
function aplicarEstrategia1(tabla, tablaBinario) {
       movimiento=aplicarEstrategia3(tabla, tablaBinario);

       //evalua si quedarán una cantidad par de filas con una ficha
       var filasUnaFicha = true;
       var nFilasUnaFicha = 0;
       i = 0;
       while (i < tabla.length && filasUnaFicha == true) {
           if (i == movimiento[0]) {                //evalua para el caso en el que la fila es la que va a ser modificada
               switch (tabla[i] - movimiento[1]) {
                   case 1: nFilasUnaFicha += 1;
                       break;
                   case 0:
                       break;
                   default:
                       filasUnaFicha = false;
               }
           }
           else {                       //evalua para el caso de las demás filas
               switch (tabla[i]) {
                   case 1: nFilasUnaFicha += 1;
                       break;
                   case 0:
                       break;
                   default:
                       filasUnaFicha = false;
               }
           }
           i++;
       }

       if (nFilasUnaFicha % 2 == 0 && filasUnaFicha == true) {
           if (tabla[movimiento[0]] - movimiento[1] == 0) {
               movimiento[1] -= 1;
           }
           else {
               movimiento[1]+=1;
           }
       }

       return movimiento;
}


/**
 * Indica la cantidad de piezas que se deben remover de una fila específica para realizar
 * una jugada ganadora, cuando solo se pueden retirar tres fichas máximo por jugada 
 * y pierde quien quita la última pieza
 * @param {Array} tabla Arreglo que contiene la cantidad de elementos en cada fila,
 * cada indice representa la fila y el contenido representa el número de piezas presentes. 
 * @param {Array} tablaBinario Contiene el número de elementos en cada fila en binario.
 * @returns {Array} El primer elemento representa la fila donde se retirarán las piezas y el segundo
 * la cantidad de piezas.
 */
function aplicarEstrategia2(tabla, tablaBinario) {
    var tablaCopia= tabla.slice();
    var tablaBinarioCopia=tablaBinario.slice();
    var i=1
    while(i<=tabla.length){
        var movimiento=aplicarEstrategia1(tablaCopia, tablaBinarioCopia)
        if(movimiento[1]<=3){
            var datoFila=tablaCopia[movimiento[0]];
            movimiento[0]=tabla.indexOf(datoFila);
            return movimiento;
        }

        tablaCopia.push(tablaCopia[0]);
        tablaCopia.shift();
        tablaBinarioCopia.push(tablaBinarioCopia[0]);
        tablaBinarioCopia.shift();

        i++;
    }

    //busca la fila que más fichas tenga
    var mayor = Math.max(...tabla);
    return [tabla.indexOf(mayor), 1];
}


/**
 * Indica la cantidad de piezas que se deben remover de una fila específica para realizar
 * una jugada ganadora.
 * @param {Array} tabla Arreglo que contiene la cantidad de elementos en cada fila,
 * cada indice representa la fila y el contenido representa el número de piezas presentes. 
 * @param {Array} tablaBinario Contiene el número de elementos en cada fila en binario.
 * @returns {Array} El primer elemento representa la fila donde se retirarán las piezas y el segundo
 * la cantidad de piezas.
 */
function aplicarEstrategia3(tabla, tablaBinario) {
    var resultado = tablaBinario[0].slice();

    //calcula suma de cada columna de la matriz binaria
    for (j = 0; j < 5; j++) {
        for (i = 1; i < tablaBinario.length; i++) {
            resultado[j] = resultado[j] ^ tablaBinario[i][j].slice();
        }
    }


    columna = resultado.indexOf(1);

    //evalua si hay algun 1 en el resultado para decidir que estrategia tomar
    if (columna != -1) {
        var fila;
        //busca fila en la que hay un 1 para retirar fichas
        for (i = tablaBinario.length - 1; i >= 0; i--) {
            if (tablaBinario[i][columna] == 1) {
                fila = i;
                break;
            }
        }

        //calcula numero de fichas que deben quedar en la fila
        num = tablaBinario[fila].slice();
        for (; columna < num.length; columna++) {
            num[columna] = num[columna] ^ resultado[columna];
        }

        //convertir el numero encontrado a decimal
        var nDecimal = "";
        for (k in num) {
            nDecimal += num[k];
        }
        nDecimal = parseInt(nDecimal, 2);

        return [fila, tabla[fila] - nDecimal];
    }
    else {
        //busca la fila que más fichas tenga
        var mayor = Math.max(...tabla);
        return [tabla.indexOf(mayor), 1];
    }
}