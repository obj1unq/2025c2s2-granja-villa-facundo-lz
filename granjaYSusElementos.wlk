import wollok.game.*

object granja{
    const mercadosEnGranja = mercados
    const cultivosEnGranja = cultivos
    const aspersoresEnGranja = aspersores

    method agregarCultivo (cultivo){
        cultivosEnGranja.agregarCultivo(cultivo)
    }

    method eliminarCultivo(cultivo){
        cultivosEnGranja.eliminarCultivo(cultivo)
	}

	method hayCultivoAca(position){
		return cultivosEnGranja.hayCultivoAca(position)
	}

	method cultivoAca (position){
		return cultivosEnGranja.cultivoAca (position)
	}

	method cultivosAlLadoDe (position){
		return cultivosEnGranja.cultivosAlLadoDe (position)
	}

    method agregarAspersor (aspersor){
        aspersoresEnGranja.agregarAspersor(aspersor)
    }

    method hayAspersorAca(position){
		return aspersoresEnGranja.hayAspersorAca(position)
	}

	method hayMercadoAca(position){
		return mercadosEnGranja.hayMercadoAca(position)
	}

	method mercadoAca(position){
		return mercadosEnGranja.mercadoAca(position)
	}

    method hayAlgoAca(position){
		return mercadosEnGranja.hayMercadoAca(position)   or
               aspersoresEnGranja.hayAspersorAca(position) or
               cultivosEnGranja.hayCultivoAca(position)
	}
}

object cultivos{
	const cultivados = #{}

	method agregarCultivo(cultivo){
		cultivados.add(cultivo)
		game.addVisual(cultivo)
	}

	method eliminarCultivo(cultivo){
		cultivados.remove(cultivo)
	}

	method hayCultivoAca(position){
		return cultivados.any({cultivo => cultivo.position() == position})
	}

	method cultivoAca (position){
		return cultivados.find ({cultivo => cultivo.position() == position})
	}

	method cultivosAlLadoDe (position){
		return cultivados.filter({cultivo => cultivo.position().distance(position) == 1 or self.estaEnDiagonalA (cultivo.position(), position)})
	}

	method estaEnDiagonalA (cultivoPosition, position){
		return (cultivoPosition.x() - position.x()).abs() == 1 and (cultivoPosition.y() - position.y()).abs() == 1
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

	method monedas(){ // No es necesario para el funcionamiento del juego, pero es util para hacer test.
		return monedas
	}

	method inventario(){ // No es necesario para el funcionamiento del juego, pero es util para hacer test.
		return inventario
	}
}