package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class InnLandmark extends Landmark {
		
		public function InnLandmark() {
			this.loadGraphic(Resource.INN);
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			visitor.hurt(visitor._max_hitpoints - visitor._hitpoints);
		}
	}

}