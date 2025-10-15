import wollok.game.*
import cultivos.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"
	const inventario = #{}
	const aspersores = #{}
	const cultivados = cultivos
	const aspersores = aspersores
	var monedas = 0

	method sembrar(semilla){
		self.validarSembrado()
		semilla.position(position)
		game.addVisual(semilla)
		cultivados.agregarCultivo(semilla)
	}

	method validarSembrado(){
		if (cultivados.hayCultivoAca(position)){
			self.error("Ya hay algo aca.")
		}
	}

	method regar(){
		self.validarRegado()
		cultivados.cultivoAca(position).serRegado()
	}

	method validarRegado(){
		if (!cultivados.hayCultivoAca(position)){
			self.error("No hay nada regable aca.")
		}
	}

	method cosechar(){
		self.validarCosechado()
		const cultivoAca = cultivados.cultivoAca(position)
		if (cultivoAca.estaListaParaCosecha()){
			inventario.add(cultivoAca)
			cultivoAca.serCosechada()
		}
	}

	method validarCosechado(){
		if (!cultivados.hayCultivoAca(position)){
			self.error("No hay nada cosechable aca.")
		}
	}

	/* VENDER DE ANTES DEL BONUS

	method vender(){
		monedas += self.valorDeInventario()
		inventario.clear()
	}
	*/

	method vender(){
		if (self.estaSobreAlgo() and game.uniqueCollider(self).puedeComprar(inventario)){
			game.uniqueCollider(self).comprar(inventario)
			monedas = monedas + inventario.sum({cultivo => cultivo.precioDeVenta()})
			inventario.clear()
		}
	}

	method hablarDeVentas(){
		game.say(self, "Tengo " + monedas + " monedas, y " + inventario.size() + " plantas para vender")
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

object aspersores{
	const aspersores = #{}

	method agregarAspersor(aspersor){
		aspersores.add(aspersor)
	}

	method eliminarAspersor(aspersor){
		aspersores.remove(aspersor)
	}

	method hayAspersorAca(position){
		return aspersores.any({aspersor => aspersor.position() == position})
	}

	method aspersoresAca (position){
		return aspersores.find ({aspersor => aspersor.position() == position})
	}
}

class Aspersor{
	const position
	const image = "aspersor.png"
	const cultivadas = cultivos

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

	method puedeComprar (valorDeInventario){
		return false
	}
}

class Mercado{
	const position
	const image = "market.png"
	const inventario = #{}
	var monedas

	method position(){
		return position
	}

	method image(){
		return image
	}

	method puedeComprar(_inventario){
		return monedas >= _inventario.sum({cultivo => cultivo.precioDeVenta()})
	}

	method comprar(_inventario){
		inventario.addAll(_inventario)
		monedas = monedas - _inventario.sum({cultivo => cultivo.precioDeVenta()})
	}
}