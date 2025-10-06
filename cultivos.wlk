import wollok.game.*

class Maiz {
	var property position = game.at(1,1)
	var image = "corn_baby.png"

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method regar(){
		if (image == "corn_baby.png"){
			image = "corn_adult.png"
		}
	}

	method image(){
		return image
	}
}

class Trigo {
	var property position = game.at(1,1)
	var image = "wheat_0.png"

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method regar(){
		if (image == "wheat_0.png"){
			image = "wheat_1.png"
		} else if (image == "wheat_1.png"){
			image = "wheat_2.png"
		} else if (image == "wheat_2.png"){
			image = "wheat_3.png"
		} else {
			image = "wheat_0.png"
		}
	}

	method image(){
		return image
	}
}

class Tomaco {
	var property position = game.at(1,1)
	const image = "tomaco.png"

	method sembrar(_position){
		position = _position
		game.addVisual(self)
	}

	method regar(){
		if (position.y() == game.height()-1){
			position = position.down(game.height()-1)
		} else {
			position = position.up(1)
		}
	}

	method image(){
		return image
	}
}
