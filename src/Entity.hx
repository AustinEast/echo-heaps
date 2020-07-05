import echo.Body;
import echo.data.Options.BodyOptions;
import h2d.RenderContext;
import h2d.Object;

class Entity extends Object {

  /**
   * Array holding all entities added to the scene.
   */
  public static var all:Array<Entity> = [];

  /**
   * Physics body. Overrides the Entity's x/y/rotation every `sync`.
   */
  public var body:Body;

  public var disposed(default, null):Bool = false;

  public function new(?parent:Object, ?body_options:BodyOptions) {
    super(parent);

    // create the Entity's body with the provided options
    body = new Body(body_options);

    // set the body's `entity` reference to this 
    // check out the base.hxml/integration section of echo's README for more info (https://github.com/AustinEast/echo#integration)
    body.entity = this;
  }

  /**
   * Override this to perform logic on every update loop.
   * @param dt elapsed time since the last step.
   */
  public function step(dt:Float) {}

  /**
   * Disposes the Entity. DO NOT use the Entity after disposing it, as it could lead to null reference errors.
   */
  public function dispose() {
    if (disposed) return;
    remove();
    body.dispose();
    body.entity = null;
    body = null;
    disposed = true;
  }

  /**
   * Overriding to add Entity to `all` array and it's body to the World.
   */
  override function onAdd() {
    super.onAdd();

    all.push(this);
    Main.world.add(body);
  }

  /**
   * Overriding to remove Entity from `all` array and it's body from the World.
   */
  override function onRemove() {
    super.onRemove();

    all.remove(this);
    body.remove();
  }

  /**
   * Overriding to apply the body's transform to the Entity.
   */
  override function sync(ctx:RenderContext) {
    if (body != null) {
      if (x != body.x) x = body.x;
      if (y != body.y) y = body.y;
      if (rotation != body.rotation) rotation = body.rotation;
    }

    super.sync(ctx);
  }
}