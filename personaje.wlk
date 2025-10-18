import wollok.game.*
import granjaYSusElementos.*
import cultivos.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"
	const inventario = #{}
	const granjaActual = granja
	var monedas = 0

	method sembrar(semilla){
		self.validarSembrado()
		granjaActual.agregarCultivo(semilla)
	}

	method validarSembrado(){
		if (granjaActual.hayAlgoAca(position)){
			self.error("No puedo sembrar aca.")
		}
	}

	method regar(){
		self.validarRegado()
		granjaActual.cultivoAca(position).serRegado()
	}

	method validarRegado(){
		if (!granjaActual.hayCultivoAca(position)){
			self.error("No tengo nada para regar.")
		}
	}

	method cosechar(){
		self.validarCosechado()
		const cultivoAca = granjaActual.cultivoAca(position)
		if (cultivoAca.estaListaParaCosecha()){
			inventario.add(cultivoAca)
			cultivoAca.serCosechada()
		}
	}

	method validarCosechado(){
		if (!granjaActual.hayCultivoAca(position)){
			self.error("No tengo nada para cosechar.")
		}
	}

	method venderPreBonus (){ // VENDER ORIGINAL DE ANTES DE HACER EL BONUS
		monedas += inventario.sum({cultivo => cultivo.precioDeVenta()})
		inventario.clear()
	}

	method vender(){
		self.validarVender()
		const mercado = granjaActual.mercadoAca(position)
		if (mercado.puedeComprar(inventario)){
			mercado.comprar(inventario)
			monedas = monedas + inventario.sum({cultivo => cultivo.precioDeVenta()})
			inventario.clear()
		}
	}

	method validarVender(){
		if (!granjaActual.hayMercadoAca(position)){
			self.error("No hay un mercado aca")
		}
	}

	method hablarDeVentas(){
		game.say(self, "Tengo " + monedas + " monedas, y " + inventario.size() + " plantas para vender")
	}

	method ponerAspersor(){
		self.validarPonerAspersor()
		granjaActual.agregarAspersor(position)
	}

	method validarPonerAspersor(){
		if (granjaActual.hayAlgoAca(position)){
			self.error("Ya hay algo aca.")
		}
	}

	method monedas(){ // No es necesario para el funcionamiento del juego, pero es util para hacer test.
		return monedas
	}

	method inventario(){ // No es necesario para el funcionamiento del juego, pero es util para hacer test.
		return inventario
	}
}