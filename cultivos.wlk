import wollok.game.*
import granjaYSusElementos.*

class Maiz {
	var property position
	var estado = maizBebe
	const granjaActual = granja

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
		granjaActual.eliminarCultivo(self)
	}

	method precioDeVenta(){
		return 150
	}

	method estado(){ // No es necesario para el funcionamiento del juego, pero es util para hacer test.
		return estado
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
	const granjaActual = granja

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
		granjaActual.eliminarCultivo(self)
	}

	method precioDeVenta(){
		return estado.precioDeVenta()
	}

	method estado(){ // No es necesario para el funcionamiento del juego, pero es util para hacer test.
		return estado
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
		return 0
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
		return 0
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
		return 100
	}
}

object trigoGigante{
	const image = "wheat_3.png"
	const siguienteEstado = trigoPequeño

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
		return 200
	}
}

class Tomaco {
	var property position
	const image = "tomaco.png"
	const granjaActual = granja

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method serRegado(){
		if (position.y() == game.height()-1){
			self.moverSiPuede (position.down(game.height()-1))
		} else {
			self.moverSiPuede (position.up(1))
		}
	}

	method moverSiPuede(_position){
		if (!granjaActual.hayAlgoAca(_position)){
				position = _position
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
		granjaActual.eliminarCultivo(self)
	}

	method precioDeVenta(){
		return 80
	}
}