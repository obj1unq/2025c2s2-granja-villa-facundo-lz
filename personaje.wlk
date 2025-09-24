import wollok.game.*
import cultivos.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"
	const inventario = #{}
	const cultivosEnGranja = cultivos
	const aspersoresEnGranja = aspersores
	const mercadosEnGranja = mercados
	var monedas = 0

	method sembrar(semilla){
		self.validarSembrado()
		cultivosEnGranja.agregarCultivo(semilla)
	}

	method validarSembrado(){
		if (cultivosEnGranja.hayCultivoAca(position)){
			self.error("Ya hay algo aca.")
		}
	}

	method regar(){
		self.validarRegado()
		cultivosEnGranja.cultivoAca(position).serRegado()
	}

	method validarRegado(){
		if (!cultivosEnGranja.hayCultivoAca(position)){
			self.error("No hay nada regable aca.")
		}
	}

	method cosechar(){
		self.validarCosechado()
		const cultivoAca = cultivosEnGranja.cultivoAca(position)
		if (cultivoAca.estaListaParaCosecha()){
			inventario.add(cultivoAca)
			cultivoAca.serCosechada()
		}
	}

	method validarCosechado(){
		if (!cultivosEnGranja.hayCultivoAca(position)){
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
		self.validarVender()
		const mercado = mercadosEnGranja.mercadoAca(position)
		if (mercado.puedeComprar(inventario)){
			mercado.comprar(inventario)
			monedas = monedas + inventario.sum({cultivo => cultivo.precioDeVenta()})
			inventario.clear()
		}
	}

	method validarVender(){
		if (!mercadosEnGranja.hayMercadoAca(position)){
			self.error("No hay un mercado aca")
		}
	}

	method hablarDeVentas(){
		game.say(self, "Tengo " + monedas + " monedas, y " + inventario.size() + " plantas para vender")
	}

	method ponerAspersor(){
		self.validarPonerAspersor()
		aspersoresEnGranja.agregarAspersor(position)
	}

	method validarPonerAspersor(){
		if (self.estaSobreAlgo()){
			self.error("Ya hay algo aca.")
		}
	}

	method estaSobreAlgo(){
		return mercadosEnGranja.hayMercadoAca(position) 		  or
			   aspersoresEnGranja.hayAspersorAca(position) or 
			   cultivosEnGranja.hayCultivoAca(position)
	}
}

object aspersores{
	const aspersores = #{}

	method agregarAspersor(position){
		const aspersor = new Aspersor(position = position)
		aspersores.add(aspersor)
		game.addVisual(aspersor)
		game.onTick(1000, "Aspersor riega", {aspersor.regar()})
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
		cultivadas.cultivosAlLadoDe(position).forEach({cultivo => cultivo.serRegado()})
	}

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

object mercados{
	const mercadosEnGranja = #{}

	method agregarMercado(_position, _monedas){
		const mercado = new Mercado (position = _position, monedas = _monedas)
		game.addVisual(mercado)
		mercadosEnGranja.add(mercado)
	}

	method hayMercadoAca(position){
		return mercadosEnGranja.any({mercado => mercado.position() == position})
	}

	method mercadoAca(position){
		return mercadosEnGranja.find({mercado => mercado.position() == position})
	}
}