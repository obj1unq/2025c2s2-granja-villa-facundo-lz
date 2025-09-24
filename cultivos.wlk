import wollok.game.*

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
		return cultivados.filter({cultivo => cultivo.position().distance(position) == 1 or self.estaEnDiagonalA (cultivo, position)})
	}

	method estaEnDiagonalA (cultivo, position){
		const posicionArriba = position.up(1)
		const posicionAbajo = position.down(1)
		const posicionDeCultivo = cultivo.position()
		return posicionDeCultivo == posicionArriba.right(1) or
			   posicionDeCultivo == posicionArriba.left(1) or
			   posicionDeCultivo == posicionAbajo.right(1) or
			   posicionDeCultivo == posicionAbajo.left(1)
	}
}

class Maiz {
	var property position
	var estado = maizBebe

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method serRegado(){
		estado = estado.siguienteEstado()
	}

	method image(){
		return estado.image()
	}

	method estaListaParaCosecha(){
		return estado.estaListaParaCosecha()
	}

	method serCosechada(){
		game.removeVisual(self)
	}

	method precioDeVenta(){
		return 150
	}

	method puedeComprar (valorDeInventario){
		return false
	}
}

object maizBebe{
	const image = "corn_baby.png"
	const siguienteEstado = maizAdulto

	method siguienteEstado(){
		return siguienteEstado
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return false
	}
}

object maizAdulto{
	const image = "corn_adult.png"

	method siguienteEstado(){
		return self
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return true
	}
}

class Trigo {
	var property position
	var estado = trigoPequeño

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method serRegado(){
		estado = estado.siguienteEstado()
	}

	method image(){
		return estado.image()
	}

	method estaListaParaCosecha(){
		return estado.estaListaParaCosecha()
	}

	method serCosechada(){
		game.removeVisual(self)
	}

	method precioDeVenta(){
		return estado.precioDeVenta()
	}

	method puedeComprar (valorDeInventario){
		return false
	}
}

object trigoPequeño{
	const image = "wheat_0.png"
	const siguienteEstado = trigoNormal

	method siguienteEstado(){
		return siguienteEstado
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return false
	}

	method precioDeVenta(){
		return 100
	}
}

object trigoNormal{
	const image = "wheat_1.png"
	const siguienteEstado = trigoGrande

	method siguienteEstado(){
		return siguienteEstado
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return false
	}

	method precioDeVenta(){
		return 200
	}
}

object trigoGrande{
	const image = "wheat_2.png"
	const siguienteEstado = trigoGigante

	method siguienteEstado(){
		return siguienteEstado
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return true
	}

	method precioDeVenta(){
		return 300
	}
}

object trigoGigante{
	const image = "wheat_3.png"

	method siguienteEstado(){
		return self
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return true
	}

	method precioDeVenta(){
		return 400
	}
}

class Tomaco {
	var property position
	const image = "tomaco.png"
	const cultivosEnGranja = cultivos

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method serRegado(){
		if (position.y() == game.height()-1){
			position = position.down(game.height()-1)
		} else { 
			if (!cultivosEnGranja.hayCultivoAca(position)){
				position = position.up(1)
			}
		}
	}

	method image(){
		return image
	}

	method estaListaParaCosecha(){
		return true
	}

	method serCosechada(){
		game.removeVisual(self)
	}

	method precioDeVenta(){
		return 80
	}

	method puedeComprar (valorDeInventario){
		return false
	}
}