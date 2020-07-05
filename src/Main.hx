import hxd.Key;
import echo.util.Debug.HeapsDebug;
import echo.World;

class Main extends hxd.App {

  public static var world:World;

  #if debug
  public var echo_debug_drawer:HeapsDebug;
  #end

  static function main() {
    hxd.Res.initEmbed();
    new Main();
  }

  override function init() {
    super.init();

    // Create a new echo World, set to the size of the heaps engine
    world = new World({
      width: engine.width,
      height: engine.height,
      gravity_y: 20
    });

    #if debug
    echo_debug_drawer = new HeapsDebug(s2d);
    #end

    // add some entities (replicates echo's sample in it's README)
    var a = new Entity(s2d, {
      x: engine.width * 0.5,
      y: engine.height * 0.5,
      elasticity: 0.2,
      shape: {
        type: CIRCLE,
        radius: 16,
      }
    });

    var b = new Entity(s2d, {
      mass: 0,
      x: engine.width * 0.5,
      y: engine.height * 0.5 + 48,
      elasticity: 0.2,
      shape: {
        type: RECT,
        width: 10,
        height: 10
      }
    });

    // give the entities names
    a.name = 'A';
    b.name = 'B';
    
    world.listen(a.body, b.body, {
      separate: true,
      enter: (a, b, c) -> trace('Collision entered between entity ${a.entity.name} and entity ${b.entity.name}'),
      stay: (a, b, c) -> trace('Collision stayed between entity ${a.entity.name} and entity ${b.entity.name}'),
      exit: (a, b) -> trace('Collision exited between entity ${a.entity.name} and entity ${b.entity.name}'),
    });
  }

  override function update(dt:Float) {
    super.update(dt);

    // step all the entities
    for (entity in Entity.all) entity.step(dt);

    // step the world
    world.step(dt);

    #if debug
    if (Key.isPressed(Key.QWERTY_TILDE)) echo_debug_drawer.canvas.visible = !echo_debug_drawer.canvas.visible;
    echo_debug_drawer.draw(world);
    #end
  }
}
