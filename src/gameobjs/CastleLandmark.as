package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	import particles.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class CastleLandmark extends Landmark {
		
		public function CastleLandmark() {
			this.loadGraphic(Resource.CASTLE, true, false, 198, 192);
			this.addAnimation("alive", [0]);
			this.addAnimation("dead", [1]);
		}
		
		private var _castle_finished:Boolean = false;		
		private var _princess_help:PrincessHelpPopup;
		public function init(g:GameEngineState):CastleLandmark {
			this.reset(0,0);
			landmark_init();
			_princess_help = (GameEngineState.cons(PrincessHelpPopup, g._game_objects) as PrincessHelpPopup).init();
			
			_castle_finished = false;
			this.play("alive");
			_has_loaded_camera_evt = false;			
			return this;
		}
		private var _has_loaded_camera_evt:Boolean = false;
		
		public override function game_update(g:GameEngineState):void {
			if (!_has_loaded_camera_evt && g._current_mode == GameEngineState.MODE_GAME) {
				g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y - 80, 180, 0.9, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
				_has_loaded_camera_evt = true;
			}
			_princess_help.set_castle_pos(this.get_center().x, this.get_center().y);
			if (_respawn_duration > 0 || _visiting_player != null || _castle_finished) {
				_princess_help._tar_alpha = 0;
			} else {
				_princess_help._tar_alpha = 1;
			}
			if (_castle_finished) {
				this.set_scale(1);
				this.alpha = 1;
				
				
			} else {
				super.game_update(g);
			}
		}
		
		public override function visit_begin(g:GameEngineState, itr_playerball:PlayerBall):void {
			g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y + 40, Number.POSITIVE_INFINITY, 1, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
			super.visit_begin(g, itr_playerball);
		}
		
		public override function visit_finished(g:GameEngineState):void {
			FlxG.play(Resource.SFX_EXPLOSION);
			var i:int = 0;
			for (i = 0; i < 30; i++) {
				(GameEngineState.particle_cons(RotateFadeParticle,g._particles) as RotateFadeParticle)
					.init(this.get_center().x + Util.float_random( -60, 60), this.get_center().y +  Util.float_random( -60, 60))
					.p_set_scale(Util.float_random(1.2, 1.8)).p_set_delay(Util.float_random(0,20));
			}
			this.play("dead");
			_castle_finished = true;
			g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y + 40, Number.POSITIVE_INFINITY, 2, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
			
			var off:Number = (_visiting_player._spawn_ct == 1 ? -10 : (_visiting_player._spawn_ct==3?-4:0));
			var hero:CutSceneObject = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_hero_anim(_visiting_player._spawn_ct).set_centered_position(this.get_center().x-27, this.get_center().y+15+off) as CutSceneObject;
			var princess:CutSceneObject;
			
			var current_level:Number = GameEngineState._current_level;
			if (current_level == 0) {
				princess = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_dog_anim().set_centered_position(this.get_center().x + 27, this.get_center().y + 10) as CutSceneObject;
				g._hud.show_castle_finish_message(g, ["Woof Woof!", "(Wow such brave, but the princess is in another castle!)"]);
				princess.set_talk();
				
			} else if (current_level == 1) {
				princess = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_old_man_anim().set_centered_position(this.get_center().x + 27, this.get_center().y + 10) as CutSceneObject;
				g._hud.show_castle_finish_message(g, ["It's dangerous to go alone, take this!", "(No princesses to see here!)"]);
				princess.set_talk();
				
			} else if (current_level == 2) {
				princess = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_bones_anim().set_centered_position(this.get_center().x + 27, this.get_center().y + 10) as CutSceneObject;
				g._hud.show_castle_finish_message(g, [".....", "(I sure hope that wasn't a princess!)"]);
				
			} else {
				princess = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_princess_anim().set_centered_position(this.get_center().x, this.get_center().y + 10) as CutSceneObject;
				g._hud.show_castle_finish_message(g, ["Wow, you're cute!", "Thanks for saving us! The world is now at peace."]);
				princess.set_talk();
				hero.set_centered_position(this.get_center().x - 3, this.get_center().y + 70);
				
			}
			
			
			g._game_objects.sort("y", FlxGroup.ASCENDING);
			g._current_mode = GameEngineState.MODE_CASTLE_FINISH_CUTSCENE;
			g._hud._castle_transition_start = this.get_center();
		}
		
	}

}