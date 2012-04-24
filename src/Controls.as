package  
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import sliz.miniui.Button;
	import sliz.miniui.Checkbox;
	import sliz.miniui.Radio;
	import sliz.miniui.RadioGroup;
	import sliz.miniui.Silder;
	
	/**
	 * ...
	 * @author @bitetti
	 */
	public class Controls extends Sprite 
	{
		
		public var chk:Checkbox;
		public var sld:Silder;
		
		public function Controls(main:Main) 
		{
			var d:DisplayObject;
			
			addChild( d = new Button("Salvar disco", 8, 8, this, main.saveDisco) );
			addChild( d = new Button("Salvar Base", 8 + d.width + d.x, 8, this, main.saveBase) );
			addChild( d = new Button("Flip X", 8 , 8 + d.height + d.y, this, main.flipX) );
			addChild( d = new Button("Flip Y", 8 + d.width + d.x, d.y, this, main.flipY) );
			addChild( d = new Button("Limpar", 8 + 8 + d.width + d.x, d.y, this, main.clear) );
			addChild( d = chk = new Checkbox("Apagar", 8 , 8 + d.height + d.y, this, main.apagar) );
			addChild( d = new Button("256", 8, 16 + d.height + d.y, this, main.sizer) );
			addChild( d = new Button("512", 8 + d.width + d.x, d.y, this, main.sizer) );
			addChild( d = new Button("1024", 8 + d.width + d.x, d.y, this, main.sizer) );
			addChild( d = new Button("2048", 8 + d.width + d.x, d.y, this, main.sizer) );

			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle(1, 0x404040, 1);
			g.beginGradientFill("linear", [0xeeeeee, 0x808080], [1, 1], [0, 255]);
			g.drawRoundRect(0, 0, this.width + 16, this.height + 16, 16, 16);
			g.endFill();
		}
		
	}

}