function mostrarTabla(tabla){
    texto=""
    for ( i in tabla){
        texto+= tabla[i]
        texto+="<br/> "
    }
    return texto
}

function tablaBinario(tabla){
    var tablaBinario=[];
    var numBinario=[];
    var fila=[];

    for(i in tabla){
        fila=["0", "0", "0", "0", "0"];
        numBinario=tabla[i].toString(2);

        tablaBinario.push(numBinario.split(""));
        if(tablaBinario[i].length<5){
            while(tablaBinario[i].length<5){    //desplaza los digitos hacia la derecha para que todos tengan la misma longitud
                tablaBinario[i].unshift('0');
            }
        }

    }

    /* convertir string a num
    var nTablaBinario=[];
    var fila=[]
    for(i in tablaBinario){
        fila=[]
        for( j in tablaBinario[i]){
            fila.push(+tablaBinario[i][j]);
        }
        //console.log(fila);
        nTablaBinario[i]=fila;
    }*/
    
    return tablaBinario;
}

//retorna:
//indice de la fila de donde se van a sacar las fichas
//Cantidad de fichas que se van a sacar de la fila
function aplicarEstrategia(tabla, tablaBinario){
    var resultado= tablaBinario[0].slice();
    console.log(tablaBinario);
    
    //calcula suma de cada columna de la matriz binaria
    for(j=0; j<5; j++){
        for(i=1; i<tablaBinario.length; i++){
            resultado[j]= resultado[j] ^ tablaBinario[i][j].slice();
        }
    }
    

    columna= resultado.indexOf(1);
    if(columna !=-1){
        var fila;
        //busca fila en la que hay que retirar fichas
        for(i=tablaBinario.length-1; i>=0; i--){
            if(tablaBinario[i][columna]==1){
                fila=i;
                break;
            }
        }

        //calcula numero de fichas que deben quedar en la fila
        num=tablaBinario[fila].slice();
        for(; columna<num.length; columna++){
            num[columna]=num[columna]^resultado[columna];
        }

        //convertir el numero encontrado a decimal
        var nDecimal="";
        for(k in num){
            nDecimal+=num[k];
        }
        nDecimal=parseInt(nDecimal, 2);

        return [fila, tabla[fila]-nDecimal];
    }
    else{
        //busca la fila que más fichas tenga
        var mayor=tabla[0];
        for(i=1; i< tabla.length; i++){
            if(tabla[i]> mayor){
                mayor=i;
            }
        }
        return [mayor, 1];
    }
    /*
    console.log(resultado);
    console.log(columna);
    console.log(fila);
    console.log(num);
    console.log(nDecimal);*/
}

function juego3(tabla){
    var tablaBinario=this.tablaBinario(tabla);
    console.log(tablaBinario);
    var movimiento=this.aplicarEstrategia(tabla, tablaBinario);
    tabla[movimiento[0]]= tabla[movimiento[0]] - movimiento[1];

}
