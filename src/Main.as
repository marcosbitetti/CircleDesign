package 
{
	import com.adobe.images.PNGEncoder;
	import com.blitzagency.filters.PolarCoordinates;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import sliz.miniui.Checkbox;
	
	/**
	 * ...
	 * @author @bitetti
	 */
	public class Main extends Sprite 
	{
		private var polar:BitmapData;
		private var base:Point = new Point(512, 512);
		private var selRec:Rectangle = new Rectangle;
		private var color:uint = 0xffffffff;
		
		private var preview:Bitmap;
		private var area:Bitmap;
		private var sel:Shape = new Shape;
		private var controls:Controls;
		private var info:TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			/*var bmp:BitmapData = new BitmapData(256, 256, false, 0);
			bmp.lock();
			for (var i:uint = 255; i > 0; i--)
			{
				bmp.fillRect(new Rectangle(0, bmp.height - i - 1, bmp.width, 1), i << 16);
				trace(bmp.height - i - 1);
			}
			bmp.unlock();*/
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			info = new TextField;
			info.selectable = false;
			info.width = stage.stageWidth;
			info.height = 24;
			info.textColor = 0x000000;
			info.x = 4;
			info.y = stage.stageHeight - 24 - 4;
			addChild(info);
			
			polar = new BitmapData(256, 256, false, 0);
			preview = new Bitmap(polar);// , "auto", true);
			previewBox = new Sprite;
			area = new Bitmap();
			makeBase();
			
			var B:int = 4;
			previewBox.x = stage.stageWidth - preview.width - B;
			previewBox.y = B;
			area.x = B;
			area.y = B;
			previewBox.filters = [ new GlowFilter(0x204080,0.8,2,2, 4,1)];
			addChild(area);
			previewBox.addChild(preview);
			addChild(previewBox);
			addChild(sel);
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown);
			previewBox.addEventListener(MouseEvent.MOUSE_DOWN, viewDown);
			previewBox.addEventListener(MouseEvent.MOUSE_UP, viewUp );
			
			previewBox.addChild( controls = new Controls(this) );
			controls.y = preview.height + B;
			
		}
		
		private function makeBase():void
		{
			var old:BitmapData = area.bitmapData;
			area.bitmapData = new BitmapData(base.x, base.y, false, 0);
			var s:Number = (stage.stageHeight - 4 - 28) / base.y;
			area.scaleX = area.scaleY = s;
			if (old) old.dispose();
			
			info.text = base.x.toFixed(0) + " x " + base.y.toFixed(0);
			info.y = stage.stageHeight - info.textHeight - 4;
		}
		
		private function makePreview():void
		{
			var t:BitmapData = new BitmapData(polar.width, polar.height, false, 0);
			//
			var m:Matrix = new Matrix;
			var r:Number = polar.width / area.bitmapData.width;
			m.scale( r,r );
			t.draw( area.bitmapData,m );
			polar.draw( PolarCoordinates.convertBitmapData(t) );
			t.dispose();
		}
		
		
		private function mouseDown(e:MouseEvent):void
		{
			//if (area.getBounds(stage).contains( e.stageX, e.stageY ))
			//{
			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp);
			selRec.x = e.stageX
			selRec.y = e.stageY;
			drawSelRec();
			//}
			
			//area.bitmapData.setPixel( area.mouseX,area.mouseY, 0xffffffff);
			
			
			//trace(area.mouseX, area.mouseY);
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			drawSelRec();
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp);
			drawSelRec();
			if (selRec.width < 0)
			{
				selRec.x += selRec.width;
				selRec.width = -selRec.width;
			}
			if (selRec.height < 0)
			{
				selRec.y += selRec.height;
				selRec.height = -selRec.height;
			}
			
			var r:Rectangle = area.getBounds(stage).intersection( selRec );
			r.x -= area.x;
			r.y -= area.y;
			
			var s:Number = 1/area.scaleX;
			r.x *= s;
			r.y *= s;
			r.width *= s;
			r.height *= s;
			
			area.bitmapData.fillRect( r, color );
			makePreview();
		}
		
		private function drawSelRec():void
		{
			selRec.width = (stage.mouseX > 0) ? stage.mouseX - selRec.x : 1;
			selRec.height = (stage.mouseY > 0) ? stage.mouseY - selRec.y : 1 ;
			//if (selRec.width > area.bitmapData.width) selRec.height = area.bitmapData.width;
			//if (selRec.height > area.bitmapData.height) selRec.height = area.bitmapData.height;
			sel.graphics.clear();
			sel.graphics.lineStyle(1, 0x1010a0, 0.8);
			sel.graphics.drawRect(selRec.x, selRec.y, selRec.width, selRec.height);
		}
		
		
		
		public function saveDisco(e:Event):void
		{
			var tmp:BitmapData = PolarCoordinates.convertBitmapData( area.bitmapData );
			preparaSalvar(tmp,"disco.png");
		}
		
		public function saveBase(e:Event):void
		{
			preparaSalvar(area.bitmapData,"base.png");
		}
		
		public function flipX(e:Event):void
		{
			var bmp:BitmapData = area.bitmapData.clone();
			var m:Matrix = new Matrix;
			m.scale( -1, 1);
			m.translate(bmp.width, 0);
			area.bitmapData.draw(bmp, m );
			bmp.dispose();
			makePreview();
		}
		
		public function flipY(e:Event):void
		{
			var bmp:BitmapData = area.bitmapData.clone();
			var m:Matrix = new Matrix;
			m.scale( 1, -1);
			m.translate(0, bmp.height);
			area.bitmapData.draw(bmp, m );
			bmp.dispose();
			makePreview();
		}
		
		public function clear(e:Event):void
		{
			area.bitmapData.fillRect(area.bitmapData.rect, 0);
			makePreview();
		}
		
		public function apagar(e:Event):void
		{
			if ( controls.chk.getToggle())
				color = 0;
			else
				color = 0xffffffff;
		}
		
		public function sizer(e:Event):void
		{
			e.stopPropagation();
			//trace(controls.r0.text);
			var s:int = parseInt((Object( e.target ).text));
			base.x = base.y = s;
			makeBase();
			makePreview();
		}
		
		private function preparaSalvar(b:BitmapData, sugest:String="imagem.png"):void
		{
			var encodedImage:ByteArray = PNGEncoder.encode(b);
			
			var saveFile:FileReference = new FileReference();
			saveFile.addEventListener(Event.COMPLETE, saveCompleteHandler);
			saveFile.addEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
			saveFile.save(encodedImage, sugest);
		}
		
		private function saveCompleteHandler(e:Event):void
		{
			
		}
		
		private function saveIOErrorHandler(e:IOErrorEvent):void
		{
			
		}
		
		private var previewBox:Sprite;
		
		private function viewDown(e:MouseEvent):void
		{
			previewBox.startDrag();
			e.stopPropagation();
		}
		
		private function viewUp(e:MouseEvent):void
		{
			previewBox.stopDrag();
		}
		
	}
	
}