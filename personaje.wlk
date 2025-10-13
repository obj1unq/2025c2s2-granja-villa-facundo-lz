import wollok.game.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"
	const cultivadasHastaAhora = #{}
	const aspersores = #{}
	var monedas = 0

	method sembrar(semilla){
		self.validarSembrado()
		semilla.position(position)
		game.addVisual(semilla)
	}

	method validarSembrado(){
		if (self.estaSobreAlgo()){
			self.error("Ya hay algo aca.")
		}
	}

	method regar(){
		self.validarRegado()
		game.uniqueCollider(self).serRegada()
	}

	method validarRegado(){
		if (!self.estaSobreAlgo() or self.estaSobreAspersor()){
			self.error("No hay nada regable aca.")
		}
	}

	method cosechar(){
		self.validarCosechado()
		const cultivoAca = game.uniqueCollider(self)
		if (cultivoAca.estaListaParaCosecha()){
			cultivadasHastaAhora.add(cultivoAca)
			cultivoAca.serCosechada()
		}
	}

	method validarCosechado(){
		if (!self.estaSobreAlgo() or self.estaSobreAspersor()){
			self.error("No hay nada cosechable aca.")
		}
	}

	method vender(){
		monedas += cultivadasHastaAhora.sum({cultivo => cultivo.precioDeVenta()})
		cultivadasHastaAhora.clear()
	}

	method hablarDeVentas(){
		game.say(self, "Tengo " + monedas + " monedas, y " + cultivadasHastaAhora.size() + " plantas para vender")
	}

	method serRegado(){}

	method ponerAspersor(){
		self.validarPonerAspersor()
		const aspersor = new Aspersor(position = position)
		aspersores.add(aspersor)
		game.addVisual(aspersor)
		game.onTick(1000, "Aspersor riega", {aspersor.regar()})
	}

	method validarPonerAspersor(){
		if (self.estaSobreAlgo()){
			self.error("Ya hay algo aca.")
		}
	}

	method estaSobreAlgo(){
		return game.getObjectsIn(position).size() == 2
	}

	method estaSobreAspersor(){
		return aspersores.any({aspersor => aspersor.position() == position})
	}
}

class Aspersor{
	const position
	const image = "aspersor.png"

	method regar(){
		self.regarCruz()
		self.regarDiagonales()
	}

	method regarCruz(){
		self.regarPosicion(position.up(1))
		self.regarPosicion(position.down(1))
		self.regarPosicion(position.right(1))
		self.regarPosicion(position.left(1))
	}

	method regarDiagonales(){
		self.regarPosicion(position.up(1).right(1))
		self.regarPosicion(position.up(1).left(1))
		self.regarPosicion(position.down(1).right(1))
		self.regarPosicion(position.down(1).left(1))
	}

	method regarPosicion(_position){
		game.getObjectsIn(_position).forEach({objeto => objeto.serRegado()})
	}

	method serRegado(){}

	method image(){
		return image
	}

	method position(){
		return position
	}
}

class Mercado{
	const position
	const image = "market.png"
	const inventario = #{}
	const monedas = 1000

	method position(){
		return position
	}

	method image(){
		return image
	}

	method comprar(){}
}