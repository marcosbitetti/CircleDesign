package com.blitzagency.filters{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
	import flash.geom.Matrix;

	public class PolarCoordinates{

		public function PolarCoordinates(){}

		public static function convertBitmapData(image:BitmapData):BitmapData{
			var imageWidth:Number = image.width;
			var imageHeight:Number = image.height;
			var radius:Number = imageWidth/2;
			var xCenter:Number = Math.round(imageWidth/2);
			var yCenter:Number = Math.round(imageHeight/2);
			var polarBitmap:BitmapData = new BitmapData(imageWidth,imageHeight,true,0x00000000);
			for(var yPos:Number=0;yPos<imageHeight;yPos++){
				for(var xPos:Number=0;xPos<imageWidth;xPos++){
					var xTrue:Number = xPos - xCenter;
					var yTrue:Number = yPos - yCenter;
					var hypothenuse:Number = Math.sqrt((xTrue*xTrue)+(yTrue*yTrue));
					//hypothenuse = (hypothenuse>radius)?radius-1:hypothenuse;
					var radians:Number = Math.atan2(yTrue, xTrue);
					var degrees:Number = radians*180/Math.PI + 90;
					degrees = (degrees<0)?degrees+360:degrees;
					degrees = (degrees>360)?degrees-360:degrees;
					var invertedDegrees:Number = 360 - degrees;
					var circonference:Number = 2*Math.PI*hypothenuse;
					var cartesianX:Number = Math.round(invertedDegrees*imageWidth/360);
					var cartesianY:Number = Math.round(hypothenuse*imageHeight/radius);
					cartesianX = (cartesianX>=imageWidth)?imageWidth-1:cartesianX;
					cartesianY = (cartesianY>=imageHeight)?imageHeight-1:cartesianY;
					var color:uint = image.getPixel32(cartesianX,cartesianY);
					polarBitmap.setPixel32(xPos,yPos,color);
				}
			}
			return polarBitmap;
		}
        
    }
	
}