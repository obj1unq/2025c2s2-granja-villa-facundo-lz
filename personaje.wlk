import wollok.game.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"

	method sembrar(semilla){
		semilla.position(position)
		game.addVisual(semilla)
	}

	method regar(){
		game.uniqueCollider(self).regar()
	}
}
